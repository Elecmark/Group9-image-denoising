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
<title>Error Page</title>
<style>
/* 居中样式 */
html, body {
	height: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}
/* 文本颜色样式 */
h3 {
	color: red;
	margin: 20px;
}
</style>
</head>
<body>

	<div class="card shadow">
		<h3>抱歉，发生了一些错误</h3>

		<div class="d-flex justify-content-center">
			<div class="spinner-grow text-danger"
				style="width: 3rem; height: 3rem; margin: 50px" role="status">
				<span class="visually-hidden">Loading...</span>
			</div>
		</div>
	</div>


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
		crossorigin="anonymous"></script>
		
	<script>
		setTimeout(function() {
			window.location.href = "index.jsp";
		}, 1000); // 1秒后跳转
	</script>
</body>
</html>