from flask import Blueprint,request, jsonify, render_template, json,session, redirect, flash,url_for,views,g
from app.utils import restful
from app.utils.upload import change_filename
from werkzeug.utils import secure_filename

import os

bp = Blueprint('test',__name__)

@bp.route('/test/upload/',methods=['POST','GET'])
# @login_required
def upload():
    if request.method == 'POST':
        # 定义上传目录，如果目录不存在，则自动创建
        UPLOAD_FOLDER = os.getcwd() + '/app/static/upload/'    # 上传后保存的本地路径
        file_dir = os.path.join(os.getcwd(), UPLOAD_FOLDER)#constants.
        if not os.path.exists(file_dir):
            os.makedirs(file_dir)

        image = request.files['file']  # 获取前端提交过来的图片
        filename = secure_filename(change_filename(image.filename))  # 修改图片上传的图片名称
        file_path = os.path.join(UPLOAD_FOLDER, filename)  # 获取上传后的绝对路径
        image.save(file_path)  # 保存到本地
        return restful.success(data=os.path.join('/static/upload', filename))
    return render_template('test/upload.html')

