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
    background-image: url('images/爱心UI.png');
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

  <div class="row">
    <div class="col left-align">
		<h1 class="display-4">Welcome!<br>OO在线文件管理器</h1>
    </div>
  </div>
  <div class="row">
    <div class="col-md-6 offset-md-1">

      <h6 class="card-title"><h3 class="card-title">网站信息</h3><span class="badge bg-secondary">V1.1</span></h6>
      <span class="badge text-bg-primary">2023.6.12</span>
      <p class="card-text custom-margin">想使用更多功能请注册/登录</p>
      <p class="custom-margin">
        <button class="btn btn-primary" type="button"
          data-bs-toggle="collapse" data-bs-target="#collapseWidthExample"
          aria-expanded="false" aria-controls="collapseWidthExample">
          了解更多
        </button>
      </p>
      <div style="min-height: 400px;">
        <div class="collapse collapse-horizontal"
          id="collapseWidthExample">
          <div class="card card-body" style="width: 360px; opacity: 0.8;">
          
          </div>
        </div>
      </div>
    </div>
  </div>
</div>



</body>
</html>
