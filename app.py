from flask import Flask, render_template, request
import os

app = Flask(__name__)

# 获取当前文件（app.py）的绝对路径
current_dir = os.path.dirname(os.path.abspath(__file__))

# 设置上传文件存储的文件夹为'images'的相对路径
UPLOAD_FOLDER = os.path.join('images')
# 允许的文件扩展名
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def home():
    return render_template('Denoising.html')

@app.route('/upload', methods=['POST', 'GET'])
def upload_file():
    if 'image' not in request.files:
        return '没有文件部分'

    image = request.files['image']

    if image.filename == '':
        return '未选择文件'

    if image and allowed_file(image.filename):
        # 移除之前的 'Original' 图片
        previous_image_path = os.path.join(app.config['UPLOAD_FOLDER'], 'Original.jpg')
        if os.path.exists(previous_image_path):
            os.remove(previous_image_path)

        # 保存上传的图片，文件名为 'Original'，保留原始格式
        save_path = os.path.join(app.root_path, app.config['UPLOAD_FOLDER'], 'Original' + os.path.splitext(image.filename)[1])
        image.save(save_path)

        return '图片上传成功！'
    else:
        return '无效的文件格式。支持的格式：png、jpg、jpeg、gif'

if __name__ == '__main__':
    app.run()