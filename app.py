from flask import Flask, render_template, request
import os
import torch
print(torch.__version__)
print(torch.cuda.is_available())
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(device)

#
app = Flask(__name__)

# 获取当前文件（app.py）的绝对路径
current_dir = os.path.dirname(os.path.abspath(__file__))

# 设置上传文件存储的文件夹为'images'的相对路径
UPLOAD_FOLDER = os.path.join(current_dir, 'images')
# 允许的文件扩展名
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def home():
    return render_template('Denoising.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'image' not in request.files:
        return '没有文件部分'

    image = request.files['image']

    if image.filename == '':
        return '未选择文件'

    if image and allowed_file(image.filename):
        # 移除之前的 'Original' 图片
        for filename in os.listdir(UPLOAD_FOLDER):
            if filename.startswith('Original'):
                os.remove(os.path.join(UPLOAD_FOLDER, filename))

        # 保存上传的图片，文件名为 'Original'，保留原始格式
        ext = os.path.splitext(image.filename)[1].lower()
        save_path = os.path.join(UPLOAD_FOLDER, 'Original' + ext)
        image.save(save_path)

        return '图片上传成功！'
    else:
        return '无效的文件格式。支持的格式：png、jpg、jpeg、gif、bmp'

if __name__ == '__main__':
    app.run()

# 最初版
# from flask import send_file
#
# @app.route('/result_image')
# def get_result_image():
#     # 构造result.jpg的完整路径
#     result_image_path = os.path.join(current_dir, 'result', 'result.jpg')
#
#     # 检查文件是否存在
#     if os.path.exists(result_image_path):
#         # 使用Flask的send_file函数发送文件到前端
#         return send_file(result_image_path, mimetype='image/jpeg', download_name='result.jpg')
#     else:
#         return '未找到结果图像'

from flask import Flask, render_template, send_from_directory
import os

app = Flask(__name__)

# 获取当前文件（app.py）的绝对路径
current_dir = os.path.dirname(os.path.abspath(__file__))

# 设置存储图片的文件夹为'images'的相对路径
DOWNLOAD_FOLDER = os.path.join(current_dir, 'result')
app.config['DOWNLOAD_FOLDER'] = DOWNLOAD_FOLDER

@app.route('/')
def home():
    return render_template('Denoising.html')

@app.route('/get_image/<image_filename>')
def get_image(image_filename):
    return send_from_directory(app.config['DOWNLOAD_FOLDER'], image_filename)

if __name__ == '__main__':
    app.run()


