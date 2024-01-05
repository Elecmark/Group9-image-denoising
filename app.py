import shutil

from flask import Flask, render_template, request, jsonify, send_from_directory, make_response
import os
import torch
import subprocess


#
app = Flask(__name__)

# 获取当前文件（app.py）的绝对路径
current_dir = os.path.dirname(os.path.abspath(__file__))

# 设置上传文件存储的文件夹为'images'的相对路径
UPLOAD_FOLDER = os.path.join(current_dir, 'static/test')
# 允许的文件扩展名
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/runscript')
def run_script():
    try:
        # 使用 subprocess 调用 Local.py
        result = subprocess.run(['python', 'Local.py'], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

        # 使用 GBK 编码解码输出
        output = result.stdout.decode('gbk')
        # 返回成功状态
        return jsonify(success=True, message="Local.py 运行结束")


    except subprocess.CalledProcessError as e:
        return jsonify({'error': 'Execution of Local.py failed', 'details': str(e)})
    except UnicodeDecodeError as e:
        return jsonify({'error': 'Unicode decode error', 'details': str(e)})





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


@app.route('/save_result', methods=['POST'])
def save_result_file():
    result_filename = 'Result.png'

    if allowed_file(result_filename):
        # 移除之前的 'Result' 图片
        for filename in os.listdir(UPLOAD_FOLDER):
            if filename.startswith('Result'):
                os.remove(os.path.join(UPLOAD_FOLDER, filename))

        # 假设 Local.py 已经生成了 Result.png
        # 保存 Result.png 到上传文件夹
        save_path = os.path.join(UPLOAD_FOLDER, result_filename)
        # 假设 Result.png 在一个可访问的临时位置
        temp_path = os.path.join('images', result_filename)
        shutil.move(temp_path, save_path)

        return '结果图片上传成功！'
    else:
        return '无效的文件格式。支持的格式：png、jpg、jpeg、gif、bmp'


if __name__ == '__main__':
    app.run()
