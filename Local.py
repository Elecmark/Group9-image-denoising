import cv2
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from PIL import Image


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

        loss = torch.mean(
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


# Function to convert image from HWC to CHW format
def hwc_to_chw(image):
    return np.transpose(image, (2, 0, 1))


# Function to convert image from CHW to HWC format
def chw_to_hwc(image):
    return np.transpose(image, (1, 2, 0))


# Load the saved model
model = CBDNet()  # 导入网络结构
model_path = "model.pth"  # Replace with the actual path to your saved model
model.load_state_dict(torch.load(model_path, map_location=torch.device('cpu')))  # 导入网络的参数
# device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
# model = model.to(device)

# Specify the directory containing test images
test_dir = "D:/Yee/image-denoising/Group9-image-denoising/images/"  # Replace with the actual path to your test images

# Specify the directory to save the results
result_dir = "D:/Yee/image-denoising/Group9-image-denoising/result/"  # Replace with the desired path to save results

# List of test image file names
# test_fns = ["Original.png"]  # Add your test image file names
#
# for ind, test_img_fn in enumerate(test_fns):
#     # model.eval()
#     with torch.no_grad():
#         # Read the image from the local directory
#         test_img_path = test_dir + test_img_fn
#         noisy_img = cv2.imread(test_img_path)
#         noisy_img = noisy_img[:, :, ::-1] / 255.0
#         noisy_img = np.array(noisy_img).astype('float32')
#
#         temp_noisy_img_chw = hwc_to_chw(noisy_img)
#         input_var = torch.from_numpy(temp_noisy_img_chw.copy()).type(torch.FloatTensor).unsqueeze(0)
#         _, output = model(input_var)
#
#         output_np = output.squeeze().cpu().detach().numpy()
#         output_np = chw_to_hwc(np.clip(output_np, 0, 1))
#
#         tempImg = np.concatenate((noisy_img, output_np), axis=1) * 255.0
#         Image.fromarray(np.uint8(tempImg)).save(fp=result_dir + test_img_fn, format='JPEG')

# List of test image file names
test_fns = ["Original.png"]  # Add your test image file names


for ind, test_img_fn in enumerate(test_fns):
    # model.eval()
    with torch.no_grad():
        # Read the image from the local directory
        test_img_path = test_dir + test_img_fn
        noisy_img = cv2.imread(test_img_path)
        noisy_img = noisy_img[:, :, ::-1] / 255.0
        noisy_img = np.array(noisy_img).astype('float32')

        temp_noisy_img_chw = hwc_to_chw(noisy_img)
        input_var = torch.from_numpy(temp_noisy_img_chw.copy()).type(torch.FloatTensor).unsqueeze(0)
        _, output = model(input_var)

        output_np = output.squeeze().cpu().detach().numpy()
        output_np = chw_to_hwc(np.clip(output_np, 0, 1))

        # Save the model output with a new filename 'result.jpg'
        result_filename = "result.jpg"
        Image.fromarray(np.uint8(output_np * 255.0)).save(fp=result_dir + result_filename, format='JPEG')
