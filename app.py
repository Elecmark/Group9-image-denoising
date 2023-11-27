from flask import Flask, render_template, request

app = Flask(__name__)


@app.route('/')
def home():  # 更改函数名称以更好地反映其功能
    return render_template('Denoising.html')  # 使用 render_template 来加载 HTML 文件


@app.route('/upload', methods=['POST', 'GET'])
def loginProcesspage():
    if request.method == 'POST':
        nm = request.form['nm']  # 获取姓名文本框的输入值
        pwd = request.form['pwd']  # 获取密码框的输入值
        if nm == 'cao' and pwd == '123':
            return render_template("index.html", data=nm)  # 使用跳转html页面路由
        else:
            return 'the username or userpwd does not match!'


if __name__ == '__main__':
    app.run()
