from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def home():  # 更改函数名称以更好地反映其功能
    return render_template('Denoising.html')  # 使用 render_template 来加载 HTML 文件

if __name__ == '__main__':
    app.run()
