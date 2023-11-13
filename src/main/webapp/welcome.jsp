<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Index</title>
    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
        rel="stylesheet"
        integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
        crossorigin="anonymous">
    <style>
        /* 样式设置 */
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .card-container {
            padding: 20px;
            text-align: center;
            box-shadow: 0 8px 16px 0 rgba(0, 0, 0, 0.2);
            width: 600px; /* 增加卡片的宽度 */
			height: 400px; /* 增加卡片的高度 */
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .success-message {
            color: green;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .error-message {
            color: red;
            font-size: 18px;
            margin-bottom: 10px;
        }

        .spinner {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<div id="cardContainer" style="display: none;">
    <div class="card-container p-0" style="width: 20rem;">
        <img src="images/hello.png" class="card-img-top" alt="...">
        <div class="card-body">
            <div class="m-3">
                <%-- 从会话中获取用户信息 --%>
                <% model.UserModel userInfo = (model.UserModel) request.getSession().getAttribute("USER_INFO"); %>
                <%-- 检查用户信息是否存在 --%>
                <% if (userInfo != null) { %>
                    <h3>欢迎!<br><%= userInfo.getUsername() %></h3>
                <% } %>

                <%-- 从请求属性中获取登录消息 --%>
                <% String loginMessage = (String) request.getAttribute("LOGIN_MESSAGE"); %>
                <%-- 检查登录消息是否存在 --%>
                <% if (loginMessage != null) { %>
                    <%-- 根据登录消息的类型应用相应的样式 --%>
                    <% if (loginMessage.equals("success")) { %>
                        <p class="success-message">登录成功！</p>
                    <% } else if (loginMessage.equals("error")) { %>
                        <p class="error-message">登录失败！</p>
                    <% } %>
                <% } %>
            </div>

            <div class="spinner m-4">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>

            <span class="badge text-bg-success">登陆成功</span>
        </div>
    </div>
</div>

<script>
    var image = new Image();
    image.src = "images/hello.png";
    image.onload = function() {
        var cardContainer = document.getElementById("cardContainer");
        cardContainer.style.display = "block";
    };
    
    function fadeIn(element) {
    	  var opacity = 0;
    	  element.style.opacity = 0; // 初始设置为完全透明

    	  var interval = setInterval(function() {
    	    if (opacity < 1) {
    	      opacity += 0.02;
    	      element.style.opacity = opacity;
    	    } else {
    	      clearInterval(interval);
    	    }
    	  }, 5); // 每隔10毫秒增加不透明度，可以调整这个值来控制动画速度
    	}

   	var cardContainer = document.getElementById("cardContainer");
   	fadeIn(cardContainer);


	setTimeout(function() {
    window.location.href = "index.jsp";
	}, 600); // 延迟1秒后跳转到index.jsp
</script>

</body>
</html>