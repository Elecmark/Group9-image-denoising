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
<title>在线文件管理器</title>
</head>

<style>
body {
  overflow: hidden;
}

.custom-tab {
	width: 550px; /* 设置为您希望的宽度 */
}

.divL {
	margin-left: 50px; /* 设置右侧间隔为10像素 */
}

.divL2 {
	margin-left: 500px; /* 设置左侧间隔为10像素 */
}

.divR {
	margin-right: 200px; /* 设置左侧间隔为10像素 */
}

.btn-icon {
	background: none; /* 移除背景颜色 */
	border: none; /* 移除边框 */
	padding: 0; /* 移除内边距 */
	cursor: pointer; /* 添加鼠标指针样式 */
	outline: none; /* 添加此行代码以移除点击后的边框 */
}

.btn:focus {
	outline: none;
}

.btn-icon:hover svg {
	fill: #0a58ca; /* 设置鼠标悬停时图标的颜色 */
}

.btn-icon:active svg {
	fill: #0d6efd; /* 设置图标被点击时的颜色 */
}

.dropdown-menu {
  width: 0px; /* 设置下拉菜单的宽度为 200px */
}


.navbar .navbarSupportedContent {
  position: relative;
}

.navbar .user-container {
  position: relative;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0 auto; /* 将导航栏的内容居中 */
  display: table; /* 设置元素为表格布局，以便使用 margin: 0 auto 居中元素 */
}

.navbar .git-link {
  position: relative;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0 auto; /* 将导航栏的内容居中 */
  display: table; /* 设置元素为表格布局，以便使用 margin: 0 auto 居中元素 */
}

.navbar .ouc-link {
  position: relative;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0 auto; /* 将导航栏的内容居中 */
  display: table; /* 设置元素为表格布局，以便使用 margin: 0 auto 居中元素 */
}

.navbar .chatgpt-link {
  position: relative;
  bottom: 0;
  right: 0;
  left: 0;
  margin: 0 auto; /* 将导航栏的内容居中 */
  display: table; /* 设置元素为表格布局，以便使用 margin: 0 auto 居中元素 */
}

.invisible-button {
  opacity: 0; /* 设置透明度为 0，使按钮完全透明 */
  pointer-events: none; /* 禁用按钮的点击事件 */
  cursor: default; /* 将鼠标光标设置为默认样式，表示不可点击 */
  background: none; /* 设置按钮的背景为透明 */
  border: none; /* 移除按钮的边框 */
  padding: 0; /* 移除按钮的内边距 */
}
</style>

<body>
	<nav class="navbar bg-dark navbar-expand-lg bg-body-tertiary shadow">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">在线文件管理器</a>
			<button class="navbar-toggler" type="button"
				  data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				  aria-controls="navbarSupportedContent" aria-expanded="false"
				  aria-label="Toggle navigation">
			  <span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<ul
						class="nav nav-pills nav-fill gap-20 p-1 small bg-primary rounded-5 shadow-sm"
						id="pillNav2" role="tablist"
						style="--bs-nav-link-color: var(--bs-white); --bs-nav-pills-link-active-color: var(--bs-primary); --bs-nav-pills-link-active-bg: var(--bs-white); margin: 10px;">
						<li class="nav-item" role="presentation">
							<button class="nav-link active rounded-5 custom-tab"
								id="home-tab2" data-bs-toggle="tab" type="button" role="tab"
								aria-selected="true" onclick="homePage()">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
									fill="currentColor" class="bi bi-house" viewBox="0 0 16 16">
						  <path fill-rule="evenodd"
										d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207l-5-5-5 5V13.5a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5V7.207Z" />
						</svg>
								主&nbsp;页&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link rounded-5 custom-tab" id="file-tab2"
								data-bs-toggle="tab" type="button" role="tab"
								aria-selected="false"
								onclick="window.location.href = 'index.jsp'">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
									fill="currentColor" class="bi bi-folder2-open"
									viewBox="0 0 16 16">
							    <path
										d="M1 3.5A1.5 1.5 0 0 1 2.5 2h2.764c.958 0 1.76.56 2.311 1.184C7.985 3.648 8.48 4 9 4h4.5A1.5 1.5 0 0 1 15 5.5v.64c.57.265.94.876.856 1.546l-.64 5.124A2.5 2.5 0 0 1 12.733 15H3.266a2.5 2.5 0 0 1-2.481-2.19l-.64-5.124A1.5 1.5 0 0 1 1 6.14V3.5zM2 6h12v-.5a.5.5 0 0 0-.5-.5H9c-.964 0-1.71-.629-2.174-1.154C6.374 3.334 5.82 3 5.264 3H2.5a.5.5 0 0 0-.5.5V6zm-.367 1a.5.5 0 0 0-.496.562l.64 5.124A1.5 1.5 0 0 0 3.266 14h9.468a1.5 1.5 0 0 0 1.489-1.314l.64-5.124A.5.5 0 0 0 14.367 7H1.633z" />
							  </svg>
								文&nbsp;件&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link rounded-5 custom-tab" id="about-tab2"
								data-bs-toggle="tab" type="button" role="tab"
								aria-selected="false" onclick="aboutPage()">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
									fill="currentColor" class="bi bi-exclamation-circle"
									viewBox="0 0 16 16">
						  <path
										d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z" />
						  <path
										d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z" />
						</svg>
								关&nbsp;于&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</button>
						</li>
						<li class="nav-item" role="presentation">
							<button class="nav-link rounded-5 custom-tab" id="about-tab2"
								data-bs-toggle="tab" type="button" role="tab"
								aria-selected="false" onclick="payPage()">
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
									fill="currentColor" class="bi bi-alipay" viewBox="0 0 16 16">
						  <path
										d="M2.541 0H13.5a2.551 2.551 0 0 1 2.54 2.563v8.297c-.006 0-.531-.046-2.978-.813-.412-.14-.916-.327-1.479-.536-.303-.113-.624-.232-.957-.353a12.98 12.98 0 0 0 1.325-3.373H8.822V4.649h3.831v-.634h-3.83V2.121H7.26c-.274 0-.274.273-.274.273v1.621H3.11v.634h3.875v1.136h-3.2v.634H9.99c-.227.789-.532 1.53-.894 2.202-2.013-.67-4.161-1.212-5.51-.878-.864.214-1.42.597-1.746.998-1.499 1.84-.424 4.633 2.741 4.633 1.872 0 3.675-1.053 5.072-2.787 2.08 1.008 6.37 2.738 6.387 2.745v.105A2.551 2.551 0 0 1 13.5 16H2.541A2.552 2.552 0 0 1 0 13.437V2.563A2.552 2.552 0 0 1 2.541 0Z" />
						  <path
										d="M2.309 9.27c-1.22 1.073-.49 3.034 1.978 3.034 1.434 0 2.868-.925 3.994-2.406-1.602-.789-2.959-1.353-4.425-1.207-.397.04-1.14.217-1.547.58Z" />
						</svg>
								赞&nbsp;助&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</button>
						</li>
					</ul>
				</ul>

				<button class="invisible-button divR"></button>


				<div class="chatgpt-link divL2">
					<a href="https://chat.openai.com/"
						target="_blank" class="nav-link btn-icon" title="ChatGPT"> 
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#0d6efd" class="bi bi-chat-dots-fill" viewBox="0 0 16 16">
						  <path d="M16 8c0 3.866-3.582 7-8 7a9.06 9.06 0 0 1-2.347-.306c-.584.296-1.925.864-4.181 1.234-.2.032-.352-.176-.273-.362.354-.836.674-1.95.77-2.966C.744 11.37 0 9.76 0 8c0-3.866 3.582-7 8-7s8 3.134 8 7zM5 8a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm4 0a1 1 0 1 0-2 0 1 1 0 0 0 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
						</svg>
					</a>
				</div>

				<button class="invisible-button"></button>

				<div class="ouc-link divL">
					<a href="http://id.ouc.edu.cn:8071/sso/login?service=http%3A%2F%2Fmy.ouc.edu.cn%2Fuser%2FsimpleSSOLogin"
						target="_blank" class="nav-link btn-icon" title="OUC信息门户"> 
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#0d6efd" class="bi bi-mortarboard-fill" viewBox="0 0 16 16">
						  <path d="M8.211 2.047a.5.5 0 0 0-.422 0l-7.5 3.5a.5.5 0 0 0 .025.917l7.5 3a.5.5 0 0 0 .372 0L14 7.14V13a1 1 0 0 0-1 1v2h3v-2a1 1 0 0 0-1-1V6.739l.686-.275a.5.5 0 0 0 .025-.917l-7.5-3.5Z"/>
						  <path d="M4.176 9.032a.5.5 0 0 0-.656.327l-.5 1.7a.5.5 0 0 0 .294.605l4.5 1.8a.5.5 0 0 0 .372 0l4.5-1.8a.5.5 0 0 0 .294-.605l-.5-1.7a.5.5 0 0 0-.656-.327L8 10.466 4.176 9.032Z"/>
						</svg>
					</a>
				</div>

				<button class="invisible-button"></button>

				<div class="git-link divL">
					<a href="http://119.167.221.16:60000/210200070741/pdh-java-web.git"
						target="_blank" class="nav-link btn-icon" title="gitLab"> 
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#0d6efd" class="bi bi-github" viewBox="0 0 16 16">
			      		  <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z" />
				    	</svg>
					</a>
				</div>

				<button class="invisible-button"></button>

				<div class="user-container ml-auto divL">
					<div class="btn-group">
						<button type="button"
							class="btn btn-outline-primary dropdown-toggle"
							data-bs-toggle="dropdown" aria-expanded="false">
							<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16"
								fill="currentColor" class="bi bi-person-circle"
								viewBox="0 0 16 16">
                            <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z" />
                            <path fill-rule="evenodd"
									d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z" />
                        </svg>
                         用 户 
						</button>

						<ul class="dropdown-menu dropdown-menu-end">
									<li><a href="login.html" class="dropdown-item"
										type="button">登录</a></li>
										<li><hr class="dropdown-divider"></li>
									<li><a href="register.html" class="dropdown-item"
										type="button">注册</a></li>
						</ul>
					</div>
				</div>
				
			</div>
		</div>
	</nav>

	<!-- 添加一个用于插入其他页面内容的div -->
	<div id="pageContent"></div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
		integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
		crossorigin="anonymous"></script>


<script>
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
	  }, 1);
	}

	function filePage() {
	  // 清空页面内容
	  var pageContent = document.getElementById("pageContent");
	  pageContent.innerHTML = "";

	  // 使用AJAX或其他方式异步加载其他页面的内容
	  // 将内容插入到相应位置
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	      var content = this.responseText;
	      pageContent.innerHTML = content;
	      pageContent.style.opacity = 0; // 设置为完全透明
	      setTimeout(function() {
	        fadeIn(pageContent); // 延迟执行渐入动画
	      }, 100);
	    }
	  };
	  xhttp.open("GET", "upload.html", true);
	  xhttp.send();
	}

	function homePage() {
	  // 清空页面内容
	  var pageContent = document.getElementById("pageContent");
	  pageContent.innerHTML = "";

	  // 异步加载并插入主页的内容
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	      var content = this.responseText;
	      pageContent.innerHTML = content;
	      pageContent.style.opacity = 0; // 设置为完全透明
	      setTimeout(function() {
	        fadeIn(pageContent); // 延迟执行渐入动画
	      }, 100);
	    }
	  };
	  xhttp.open("GET", "visitorpage.jsp", true);
	  xhttp.send();
	}

	function aboutPage() {
	  // 清空页面内容
	  var pageContent = document.getElementById("pageContent");
	  pageContent.innerHTML = "";

	  // 异步加载并插入关于页面的内容
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	      var content = this.responseText;
	      pageContent.innerHTML = content;
	      pageContent.style.opacity = 0; // 设置为完全透明
	      setTimeout(function() {
	        fadeIn(pageContent); // 延迟执行渐入动画
	      }, 100);
	    }
	  };
	  xhttp.open("GET", "aboutpage.jsp", true);
	  xhttp.send();
	}

	function payPage() {
	  // 清空页面内容
	  var pageContent = document.getElementById("pageContent");
	  pageContent.innerHTML = "";

	  // 异步加载并插入支付页面的内容
	  var xhttp = new XMLHttpRequest();
	  xhttp.onreadystatechange = function() {
	    if (this.readyState == 4 && this.status == 200) {
	      var content = this.responseText;
	      pageContent.innerHTML = content;
	      pageContent.style.opacity = 0; // 设置为完全透明
	      setTimeout(function() {
	        fadeIn(pageContent); // 延迟执行渐入动画
	      }, 100);
	    }
	  };
	  xhttp.open("GET", "paypage.jsp", true);
	  xhttp.send();
	}

	// 在页面加载完成后触发homePage()函数
	window.onload = homePage;

</script>
</body>
</html>