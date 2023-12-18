import numpy as np
import tensorflow as tf
from keras.layers import Input, Conv2D, MaxPooling2D, UpSampling2D
from keras.models import Model
from keras.datasets import mnist
from keras.datasets import cifar10

def denoising_autoencoder_high_capacity(input_shape):
    input_img = Input(shape=input_shape)

    x = Conv2D(64, (3, 3), activation='relu', padding='same')(input_img)
    x = MaxPooling2D((2, 2), padding='same')(x)
    x = Conv2D(128, (3, 3), activation='relu', padding='same')(x)
    x = MaxPooling2D((2, 2), padding='same')(x)
    x = Conv2D(256, (3, 3), activation='relu', padding='same')(x)  # 更多的卷积层和滤波器
    encoded = MaxPooling2D((2, 2), padding='same')(x)

    x = Conv2D(256, (3, 3), activation='relu', padding='same')(encoded)
    x = UpSampling2D((2, 2))(x)
    x = Conv2D(128, (3, 3), activation='relu', padding='same')(x)
    x = UpSampling2D((2, 2))(x)
    x = Conv2D(64, (3, 3), activation='relu', padding='same')(x)
    x = UpSampling2D((2, 2))(x)

    if input_shape[-1] == 1:
        decoded = Conv2D(1, (3, 3), activation='sigmoid', padding='same')(x)
    else:
        decoded = Conv2D(3, (3, 3), activation='sigmoid', padding='same')(x)

    autoencoder = Model(input_img, decoded)
    return autoencoder
# 创建并编译模型（彩色图像），增加模型容量
input_shape_color = (32, 32, 3)
model_color = denoising_autoencoder_high_capacity(input_shape_color)
model_color.compile(optimizer='adam', loss='mean_squared_error')

# 加载CIFAR-10数据集
(X_train_color, _), (X_test_color, _) = cifar10.load_data()

# 数据预处理
X_train_color = X_train_color.astype('float32') / 255.0
X_test_color = X_test_color.astype('float32') / 255.0

# 添加噪声
noise_factor = 0.5
X_train_noisy_color = X_train_color + noise_factor * np.random.normal(loc=0.0, scale=1.0, size=X_train_color.shape)
X_test_noisy_color = X_test_color + noise_factor * np.random.normal(loc=0.0, scale=1.0, size=X_test_color.shape)

X_train_noisy_color = np.clip(X_train_noisy_color, 0., 1.)
X_test_noisy_color = np.clip(X_test_noisy_color, 0., 1.)

# 训练模型
model_color.fit(X_train_noisy_color, X_train_color, epochs=10, batch_size=128, shuffle=True, validation_data=(X_test_noisy_color, X_test_color))

# 保存彩色图像模型
model_color.save('denoising_autoencoder_color.h5')
