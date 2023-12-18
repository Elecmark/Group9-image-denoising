<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="model.UserModel" %>
<%@ page import="java.io.File, java.io.IOException, javax.servlet.ServletException, javax.servlet.http.Part" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Detail</title>
    <style>
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            text-align: center;
        }

        .user-avatar {
            border-radius: 50%;
            cursor: pointer;
            margin-bottom: 50px;
        }

        .user-info {
            text-align: left;
            margin-bottom: 30px;
            margin-left: 36%;
        }

        .user-info label {
            font-weight: bold;
        }

        .user-info span {
            margin-left: 10px;
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>用户详情</h1>
        <div class="row">
            <div class="col-md-6">
                <div class="form-group">
                    <input type="file" id="avatarInput" style="display: none;">
                    <img src="${sessionScope.USER_INFO.avatarUrl}?t=${System.currentTimeMillis()}" alt="User Avatar" class="user-avatar" width="200" height="200" onclick="selectAvatar()">
                </div>
                <div class="user-info">
                    <label>用户名:</label>
                    <span>${sessionScope.USER_INFO.username}</span>
                </div>
                <div class="user-info">
                    <label>年龄:</label>
                    <span>${sessionScope.USER_INFO.age}</span>
                </div>
                <div class="user-info">
                    <label>电话号码:</label>
                    <span>${USER_INFO.telephone}</span>
                </div>
                <div class="user-info">
                    <label>注册时间:</label>
                    <span>${sessionScope.USER_INFO.registrationTime}</span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectAvatar() {
            document.getElementById("avatarInput").click();
        }

        document.getElementById("avatarInput").addEventListener("change", function(event) {
            var file = event.target.files[0];
            if (file) {
                var extension = file.name.split(".").pop().toLowerCase();
                var allowedExtensions = ["png", "jpg", "jpeg", "ico"];

                if (allowedExtensions.includes(extension)) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        var imgElement = document.querySelector(".user-avatar");
                        imgElement.src = e.target.result;
                    };
                    reader.readAsDataURL(file);

                    // 发起上传请求，将文件上传到服务器
                    var formData = new FormData();
                    var username = "${sessionScope.USER_INFO.username}";
                    var newFileName = username + "." + extension;
                    formData.append("file", file, newFileName);

                    var xhr = new XMLHttpRequest();
                    xhr.open("POST", "uploadAvatar", true);
                    xhr.onreadystatechange = function() {
                        if (xhr.readyState === 4 && xhr.status === 200) {
                            // 上传成功
                            console.log("文件上传成功");
                            // 刷新当前页面显示新头像
                            var avatarUrl = "/profile_picture/" + newFileName;
                            var imgElement = document.querySelector(".user-avatar");
                            imgElement.src = "${request.getContextPath()}" + avatarUrl;
                            // 更新userModel中的avatarUrl属性
                            var userModel = JSON.parse('${sessionScope.USER_INFO}');
                            userModel.avatarUrl = "${request.getContextPath()}" + avatarUrl;
                            // 将更新后的userModel保存到session
                            var userModelString = JSON.stringify(userModel);
                            sessionStorage.setItem("USER_INFO", userModelString);
                        } else if (xhr.readyState === 4 && xhr.status !== 200) {
                            // 上传失败
                            console.error("文件上传失败");
                        }
                    };
                    xhr.send(formData);
                } else {
                    // 文件格式不正确
                    alert("请选择正确的图像格式");
                }
            }
        });
    </script>
</body>
</html>
