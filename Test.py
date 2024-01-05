import numpy as np
import cv2
from keras.models import load_model

# 加载保存的模型
model_color = load_model('denoising_autoencoder_color.h5')

# 读取本地图片
image_path = 'test/1.png'
image = cv2.imread(image_path)
image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

# 调整图像尺寸
resized_image = cv2.resize(image, (32, 32))

# 添加噪声
noise_factor = 0.5
noisy_image = resized_image + noise_factor * np.random.normal(loc=0.0, scale=1.0, size=resized_image.shape)
noisy_image = np.clip(noisy_image, 0., 1.)

# 使用模型进行去噪
denoised_image = model_color.predict(np.expand_dims(noisy_image, axis=0))[0]

# 显示原始图像、添加噪声的图像和去噪后的图像
import matplotlib.pyplot as plt

plt.figure(figsize=(12, 4))
plt.subplot(1, 3, 1)
plt.imshow(image)
plt.title('Original Image')
plt.axis('off')

plt.subplot(1, 3, 2)
plt.imshow(noisy_image)
plt.title('Noisy Image')
plt.axis('off')

plt.subplot(1, 3, 3)
plt.imshow(denoised_image)
plt.title('Denoised Image')
plt.axis('off')

plt.tight_layout()
plt.show()