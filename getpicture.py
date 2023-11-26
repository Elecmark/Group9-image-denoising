from flask import Flask, request

app = Flask(__name__)

@app.route('/processImage', methods=['POST'])
def process_image():
    # 获取前端上传的图像文件
    image = request.files['image']

    # 在这里进行图像处理操作，例如图像去噪

    # 处理完毕后返回处理后的图像给前端
    return processed_image

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)