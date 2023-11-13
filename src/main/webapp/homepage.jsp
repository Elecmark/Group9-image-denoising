<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="zh">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<title>Home</title>
</head>
<body>


<style>
  .full-width-container {
    background-image: url('images/文件UI.png');
    background-size: auto 110%;
    background-repeat: no-repeat;
    background-position: center;
  }
   .left-align {
    text-align: left;
    margin-left: 20%;
  }
  .custom-margin {
    margin-top: 10px;
    margin-bottom: 10px;
  }

  .custom-padding {
    padding-top: 30px;
    padding-bottom: 30px;
  }
</style>

<div class="container-fluid full-width-container">
		<div class="row mt-3">
			<div class="col">
				<div class="col text-left">
				    <%-- 从会话中获取用户信息 --%>
			        <% model.UserModel userInfo = (model.UserModel) request.getSession().getAttribute("USER_INFO"); %>
			        <%-- 检查用户信息是否存在 --%>
			        <% if (userInfo != null) { %>
			            <h1 class="display-3">Welcome! <%= userInfo.getUsername() %></h1>
			        <% } %>
				</div>



				<div class="toast" role="alert" aria-live="assertive"
					aria-atomic="true">
					<div class="toast-header">
						<strong class="me-auto">Bootstrap</strong> <small
							class="text-muted">11 mins ago</small>
						<button type="button" class="btn-close" data-bs-dismiss="toast"
							aria-label="Close"></button>
					</div>
					<div class="toast-body">Hello, world! This is a toast
						message.</div>
				</div>

				<h6 class="card-title"><h3 class="card-title">网站信息</h3><span class="badge bg-secondary">V1.1</span></h6>
		        <span class="badge text-bg-primary">2023.6.12</span>
		        
				<p class="card-text">
				<p>在线用户数量: ${onlineUserCount}</p>
				<ul>
					<c:forEach var="user" items="${onlineUserList}">
						<li>${user}</li>
					</c:forEach>
				</ul>


				<p>
					<button class="btn btn-primary" type="button"
						data-bs-toggle="collapse" data-bs-target="#collapseWidthExample"
						aria-expanded="false" aria-controls="collapseWidthExample">
						了解更多</button>
				</p>
				<div style="min-height: 400px;">
					<div class="collapse collapse-horizontal" id="collapseWidthExample">
						<div class="card card-body" style="width: 600px;">这里是游客页面的内容。
							11111111111111111111111111111111111111111111111111111111111</div>
					</div>
				</div>

				<div id="carouselExampleAutoplaying"
					class="carousel slide carousel-fade" data-bs-ride="carousel">
					<div class="carousel-inner">
						<div class="carousel-item active">
							<img src="..." class="d-block w-100" alt="...">
						</div>
						<div class="carousel-item">
							<img src="..." class="d-block w-100" alt="...">
						</div>
						<div class="carousel-item">
							<img src="..." class="d-block w-100" alt="...">
						</div>
					</div>
					<button class="carousel-control-prev" type="button"
						data-bs-target="#carouselExampleAutoplaying" data-bs-slide="prev">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Previous</span>
					</button>
					<button class="carousel-control-next" type="button"
						data-bs-target="#carouselExampleAutoplaying" data-bs-slide="next">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Next</span>
					</button>
				</div>




			</div>
		</div>



		<div class="row mt-3">
			<div class="col">
				<a href="http://www.ouc.edu.cn">中国海洋大学</a>
			</div>
		</div>

	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
		crossorigin="anonymous"></script>

</body>
</html>