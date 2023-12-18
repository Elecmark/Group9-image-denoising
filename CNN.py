import os, time, scipy.io, shutil
from PIL import Image
import torch
import torch.nn as nn
import torch.nn.functional as F
import numpy as np
import glob
import re
import cv2


class FCN(nn.Module):
    def __init__(self):
        super(FCN, self).__init__()

        # 3 ==> 32 的输入卷积
        self.inc = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1),
            nn.ReLU(inplace=True))

        # 32 ==> 32 的中间卷积
        self.conv = nn.Sequential(
            nn.Conv2d(32, 32, 3, padding=1),
            nn.ReLU(inplace=True)
        )

        # 32 ==> 3 的输出卷积
        self.outc = nn.Sequential(
            nn.Conv2d(32, 3, 3, padding=1),
            nn.ReLU(inplace=True)
        )

    def forward(self, x):
        # 第 1 次卷积
        conv1 = self.inc(x)
        # 第 2 次卷积
        conv2 = self.conv(conv1)
        # 第 3 次卷积
        conv3 = self.conv(conv2)
        # 第 4 次卷积
        conv4 = self.conv(conv3)
        # 第 5 次卷积
        conv5 = self.outc(conv4)
        return conv5


class single_conv(nn.Module):
    def __init__(self, in_ch, out_ch):  # 两个参数
        super(single_conv, self).__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(in_ch, out_ch, 3, padding=1),  # 二维卷积3×3，1个像素的           											     # padding保证尺寸
            nn.ReLU(inplace=True))  # ReLU函数

    def forward(self, x):
        x = self.conv(x)
        return x


class up(nn.Module):
    def __init__(self, in_ch):
        super(up, self).__init__()
        self.up = nn.ConvTranspose2d(in_ch, in_ch // 2, 2, stride=2)  # 反卷积

    def forward(self, x1, x2):
        # x1 上采样
        x1 = self.up(x1)

        # 输入数据是四维的，第一个维度是样本数，剩下的三个维度是 CHW
        # 所以 Y 方向上的悄寸差别在 [2],  X 方向上的尺寸差别在 [3]
        diffY = x2.size()[2] - x1.size()[2]
        diffX = x2.size()[3] - x1.size()[3]
        # 给 x1 进行 padding 操作
        x1 = F.pad(x1, (diffX // 2, diffX - diffX // 2,
                        diffY // 2, diffY - diffY // 2))
        # 把 x2 加到反卷积后的 feature map
        x = x2 + x1
        return x


class outconv(nn.Module):
    def __init__(self, in_ch, out_ch):
        super(outconv, self).__init__()
        self.conv = nn.Conv2d(in_ch, out_ch, 1)

    def forward(self, x):
        x = self.conv(x)
        return x


class UNet(nn.Module):
    def __init__(self):
        super(UNet, self).__init__()

        self.inc = nn.Sequential(
            single_conv(6, 64),
            single_conv(64, 64))

        self.down1 = nn.AvgPool2d(2)  # 2×2的均值pooling
        self.conv1 = nn.Sequential(
            single_conv(64, 128),
            single_conv(128, 128),
            single_conv(128, 128))

        self.down2 = nn.AvgPool2d(2)  # 2×2的均值pooling
        self.conv2 = nn.Sequential(
            single_conv(128, 256),
            single_conv(256, 256),
            single_conv(256, 256),
            single_conv(256, 256),
            single_conv(256, 256),
            single_conv(256, 256))

        self.up1 = up(256)  # cov2反卷积
        self.conv3 = nn.Sequential(
            single_conv(128, 128),
            single_conv(128, 128),
            single_conv(128, 128))

        self.up2 = up(128)  # cov3反卷积
        self.conv4 = nn.Sequential(
            single_conv(64, 64),
            single_conv(64, 64))

        self.outc = outconv(64, 3)

    def forward(self, x):
        # input conv : 6 ==> 64 ==> 64
        inx = self.inc(x)

        # 均值 pooling, 然后 conv1 : 64 ==> 128 ==> 128 ==> 128
        down1 = self.down1(inx)
        conv1 = self.conv1(down1)

        # 均值 pooling，然后 conv2 : 128 ==> 256 ==> 256 ==> 256 ==> 256 ==> 256 ==> 256
        down2 = self.down2(conv1)
        conv2 = self.conv2(down2)

        # up1 : conv2 反卷积，和 conv1 的结果相加，输入256，输出128
        up1 = self.up1(conv2, conv1)
        # conv3 : 128 ==> 128 ==> 128 ==> 128
        conv3 = self.conv3(up1)

        # up2 : conv3 反卷积，和 input conv 的结果相加，输入128，输出64
        up2 = self.up2(conv3, inx)
        # conv4 : 64 ==> 64 ==> 64
        conv4 = self.conv4(up2)

        # output conv: 65 ==> 3，用1x1的卷积降维，得到降噪结果
        out = self.outc(conv4)
        return out


class CBDNet(nn.Module):
    def __init__(self):
        super(CBDNet, self).__init__()
        self.fcn = FCN()
        self.unet = UNet()

    def forward(self, x):
        noise_level = self.fcn(x)
        concat_img = torch.cat([x, noise_level], dim=1)
        out = self.unet(concat_img) + x
        return noise_level, out


class fixed_loss(nn.Module):
    def __init__(self):
        super().__init__()

    def forward(self, out_image, gt_image, est_noise, gt_noise, if_asym):
        # 分别得到图像的高度和宽度
        h_x = est_noise.size()[2]
        w_x = est_noise.size()[3]
        # 每个样本为 CHW ，把 H 方向第一行的数据去掉，统计一下一共多少元素
        count_h = self._tensor_size(est_noise[:, :, 1:, :])
        # 每个样本为 CHW ，把 W 方向第一列的数据去掉，统计一下一共多少元素
        count_w = self._tensor_size(est_noise[:, :, :, 1:])
        # H 方向，第一行去掉得后的矩阵，减去最后一行去掉后的矩阵，即下方像素减去上方像素，平方，然后求和
        h_tv = torch.pow((est_noise[:, :, 1:, :] - est_noise[:, :, :h_x - 1, :]), 2).sum()
        # W 方向，第一列去掉得后的矩阵，减去最后一列去掉后的矩阵，即右方像素减去左方像素，平方，然后求和
        w_tv = torch.pow((est_noise[:, :, :, 1:] - est_noise[:, :, :, :w_x - 1]), 2).sum()
        # 求平均，得到平均每个像素上的 tvloss
        tvloss = h_tv / count_h + w_tv / count_w

        loss = torch.mean( \
            # 第三部分：重建损失
            torch.pow((out_image - gt_image), 2)) + \
               if_asym * 0.5 * torch.mean(
            torch.mul(torch.abs(0.3 - F.relu(gt_noise - est_noise)), torch.pow(est_noise - gt_noise, 2))) + \
               0.05 * tvloss

        return loss

    def _tensor_size(self, t):
        return t.size()[1] * t.size()[2] * t.size()[3]


# 这个类用于存储 loss，观察结果时使用
# 每轮训练一张图像，就计算一下 loss 的均值存储在 self.avg 里，用于输出观察变化
# 同时，把当前 loss 的值存储在 self.val 里
class AverageMeter(object):
    def __init__(self):
        self.reset()

    def reset(self):
        self.val = 0
        self.avg = 0
        self.sum = 0
        self.count = 0

    def update(self, val, n=1):
        self.val = val
        self.sum += val * n
        self.count += n
        self.avg = self.sum / self.count


# 图像矩阵由 hwc 转换为 chw ，这个就不多解释了
def hwc_to_chw(img):
    return np.transpose(img, axes=[2, 0, 1])


# 图像矩阵由 chw 转换为 hwc ，这个也不多解释
def chw_to_hwc(img):
    return np.transpose(img, axes=[1, 2, 0])


# 训练的时候，输入图像尺寸都是 ps x ps 的
ps = 256

train_dir = 'D:/Yee/image-denoising/Group9-image-denoising/mini_denoise_dataset/train/'
train_fns = glob.glob(train_dir + 'Batch_*')

origin_imgs = [None] * len(train_fns)
noised_imgs = [None] * len(train_fns)
# 使用GPU训练
device = torch.device("cuda:0" if torch.cuda.is_available() else "cpu")

# 创建 模型 + 优化器 + 损失函数
model = CBDNet().to(device)
optimizer = torch.optim.Adam(model.parameters(), lr=1e-4)
criterion = fixed_loss()
cnt = 0
total_loss = AverageMeter()
# 设置为训练模式，即启用 BatchNormalization 和 Dropout
model.train()

for epoch in range(200):
    # 内存中清空图片
    for i in range(len(train_fns)):
        origin_imgs[i] = []
        noised_imgs[i] = []

    # 打乱训练图片的顺序
    for idx in np.random.permutation(len(train_fns)):
        # 读入origin image；RGB通道反过来，然后归一化；转化为 float32类型
        origin_img = cv2.imread(glob.glob(train_fns[idx] + '/*Reference.bmp')[0])
        origin_img = origin_img[:, :, ::-1] / 255.0
        origin_imgs[idx] = np.array(origin_img).astype('float32')

        # 读入noised image；因为一个文件夹里有2张噪声图，这里写了一个循环
        train_noised_list = glob.glob(train_fns[idx] + '/*Noisy.bmp')
        for nidx in range(len(train_noised_list)):
            noised_img = cv2.imread(train_noised_list[nidx])
            noised_img = noised_img[:, :, ::-1] / 255.0
            noised_img = np.array(noised_img).astype('float32')
            noised_imgs[idx].append(noised_img)

            H, W, C = origin_img.shape
            # 从图像中随机取 256x256 大小的块
            xx = np.random.randint(0, W - ps + 1)
            yy = np.random.randint(0, H - ps + 1)
            temp_origin_img = origin_imgs[idx][yy:yy + ps, xx:xx + ps, :]
            temp_noised_img = noised_imgs[idx][nidx][yy:yy + ps, xx:xx + ps, :]

            # 生成 0，1 随机数，随机做图像的左右、上下、通道翻转，增加训练样本的多样性
            if np.random.randint(0, 2) == 1:  # 左右翻转
                temp_origin_img = np.flip(temp_origin_img, axis=1)
                temp_noised_img = np.flip(temp_noised_img, axis=1)
            if np.random.randint(0, 2) == 1:  # 上下翻转
                temp_origin_img = np.flip(temp_origin_img, axis=0)
                temp_noised_img = np.flip(temp_noised_img, axis=0)
            if np.random.randint(0, 2) == 1:  # 通道翻转
                temp_origin_img = np.transpose(temp_origin_img, (1, 0, 2))
                temp_noised_img = np.transpose(temp_noised_img, (1, 0, 2))

            temp_noised_img_chw = hwc_to_chw(temp_noised_img)
            temp_origin_img_chw = hwc_to_chw(temp_origin_img)

            cnt += 1

            # 这里给输入数据增加一个维度，即原来是三维的，现在是四维的，方便CNN处理
            input_var = torch.from_numpy(temp_noised_img_chw.copy()).type(torch.FloatTensor).unsqueeze(0).to(device)
            target_var = torch.from_numpy(temp_origin_img_chw.copy()).type(torch.FloatTensor).unsqueeze(0).to(device)

            # 噪声图像输入网络处理
            noise_level_est, output = model(input_var)
            # 计算损失
            loss = criterion(output, target_var, noise_level_est, 0, 0)
            total_loss.update(loss.item())
            # 常规操作： 梯度归零 + 反向传播 + 优化
            optimizer.zero_grad()
            loss.backward()
            optimizer.step()

    print('[Epoch %d] [Img count %d] [Loss.val: %.4f] ([loss.avg: %.4f])\t' % (
    epoch, cnt, total_loss.val, total_loss.avg))
torch.save(model.state_dict(), "model.pth1")
test_dir = 'D:/Fork/Group9-image-denoising/mini_denoise_dataset/test/'
test_fns = glob.glob(test_dir + '*.bmp')

# 建立 result 目录，保存图片处理结果
result_dir = './result/'
if not os.path.exists(result_dir):
    os.mkdir(result_dir)
for ind, test_img_path in enumerate(test_fns):
    model.eval()
    with torch.no_grad():
        print(test_img_path)
        # 读入图像，切换RGB通道并归一化，转化为 numpy float32格式
        noisy_img = cv2.imread(test_img_path)
        noisy_img = noisy_img[:, :, ::-1] / 255.0
        noisy_img = np.array(noisy_img).astype('float32')

        # 转化为 chw 才符合 pytorch 网络的输入格式
        temp_noisy_img_chw = hwc_to_chw(noisy_img)
        # 图像放到 gpu 上
        input_var = torch.from_numpy(temp_noisy_img_chw.copy()).type(torch.FloatTensor).unsqueeze(0).to(device)
        # 输入模型得到结果
        _, output = model(input_var)

        # 输出结果转化为 numpy ，同时，把数据转到 0，1 之间（因为可能会有一些异常值）
        output_np = output.squeeze().cpu().detach().numpy()
        output_np = chw_to_hwc(np.clip(output_np, 0, 1))
        # 把噪声图像，和降噪后的图像拼接在一起，然后保存图像
        tempImg = np.concatenate((noisy_img, output_np), axis=1) * 255.0

        Image.fromarray(np.uint8(tempImg)).save(fp=result_dir + 'test_%d.jpg' % (ind), format='JPEG')
