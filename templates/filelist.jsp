<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.io.File"%>
<%@ page import="java.net.URLEncoder"%>

<!DOCTYPE html>
<html>
<head>
<%
String folderPath = (String) session.getAttribute("folderPath");
if (folderPath != null) {
    String[] pathSegments = folderPath.split("/");
    String currentPath = "";
}
%>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1" >
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
	crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
	
<meta charset="UTF-8">
<title>文件列表</title>
</head>
<style>
.custom-tab {
	height: 80px; /* 设置为您希望的高度 */
}

.nav-item {
	margin-left: 10px; /* 设置左侧间距为10像素 */
	margin-right: 10px; /* 设置右侧间距为10像素 */
}

.divL {
	margin-left: 50px;
}

.divR {
	margin-right: 40px; 
}

style>.custom-card {
	margin: 20px;
	padding: 20px;
	box-shadow: 0px 8px 4px rgba(0, 0, 0, 0.1);
	border-radius: 4px;
}

.table {
	border-collapse: collapse; /* 取消表格边框边距 */
	table-layout: fixed; /* 固定表格布局 */
	width: 100%; /* 表格宽度占满父容器 */
}

.table tbody tr {
	border-bottom: 1px solid #dee2e6; /* 添加行之间的边框分隔线（可选） */
}

.table-striped tbody tr:nth-of-type(odd) {
	background-color: #f9f9f9; /* 设置奇数行背景颜色为淡灰色 */
}

.table-striped tbody tr:nth-of-type(even) {
	background-color: #ffffff; /* 设置偶数行背景颜色为白色 */
}

th, td {
	word-wrap: break-word; /* 单元格内容换行 */
}

th:first-child, td:first-child {
	width: 20%;
}

th:nth-child(2), td:nth-child(2) {
	width: 15%;
}

th:nth-child(3), td:nth-child(3) {
	width: 10%;
}

th:nth-child(4), td:nth-child(4) {
	width: 10%;
}

th:nth-child(5), td:nth-child(5) {
	width: 35%;
}

th:nth-child(6), td:nth-child(6) {
	width: 3%;
	text-align: right;
}

th {
    cursor: pointer;
}
</style>


<body>


	<nav
		class="navbar bg-dark navbar-expand-lg bg-body-tertiary shadow custom-tab"
		data-bs-theme="dark">
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
					<li class="nav-item divL divR">
					  <a class="nav-link active" aria-current="page" href="index.jsp">
					    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-house" viewBox="0 0 16 16" style="vertical-align: middle; margin-bottom: 4px;">
					      <path fill-rule="evenodd" d="M8.707 1.5a1 1 0 0 0-1.414 0L.646 8.146a.5.5 0 0 0 .708.708L2 8.207V13.5A1.5 1.5 0 0 0 3.5 15h9a1.5 1.5 0 0 0 1.5-1.5V8.207l.646.647a.5.5 0 0 0 .708-.708L13 5.793V2.5a.5.5 0 0 0-.5-.5h-1a.5.5 0 0 0-.5.5v1.293L8.707 1.5ZM13 7.207l-5-5-5 5V13.5a.5.5 0 0 0 .5.5h9a.5.5 0 0 0 .5-.5V7.207Z" />
					    </svg>
					     主 页
					  </a>
					</li>


					<li class="nav-item divL divR">
					  <a id="uploadLink" class="nav-link active" aria-current="page" href="#">
					    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cloud-upload" viewBox="0 0 16 16">
					      <path fill-rule="evenodd" d="M4.406 1.342A5.53 5.53 0 0 1 8 0c2.69 0 4.923 2 5.166 4.579C14.758 4.804 16 6.137 16 7.773 16 9.569 14.502 11 12.687 11H10a.5.5 0 0 1 0-1h2.688C13.979 10 15 8.988 15 7.773c0-1.216-1.02-2.228-2.313-2.228h-.5v-.5C12.188 2.825 10.328 1 8 1a4.53 4.53 0 0 0-2.941 1.1c-.757.652-1.153 1.438-1.153 2.055v.448l-.445.049C2.064 4.805 1 5.952 1 7.318 1 8.785 2.23 10 3.781 10H6a.5.5 0 0 1 0 1H3.781C1.708 11 0 9.366 0 7.318c0-1.763 1.266-3.223 2.942-3.593.143-.863.698-1.723 1.464-2.383z"/>
					      <path fill-rule="evenodd" d="M7.646 4.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 5.707V14.5a.5.5 0 0 1-1 0V5.707L5.354 7.854a.5.5 0 1 1-.708-.708l3-3z"/>
					    </svg>
					     上 传
					  </a>
					</li>


				</ul>
				<ul class="navbar-nav ml-auto">
					<li class="nav-item dropdown">
					<a
						class="nav-link dropdown-toggle" href="#" role="button"
						data-bs-toggle="dropdown" aria-expanded="false"> <%-- 从会话中获取用户信息 --%>
						<%
			            model.UserModel userInfo = (model.UserModel) request.getSession().getAttribute("USER_INFO");
			            %> <%-- 检查用户信息是否存在 --%> <%
			            if (userInfo != null) {
			            %> <%=userInfo.getUsername()%> <%
			            }
			            %>
					</a>
						<ul class="dropdown-menu">
							<li><a href="userDetail.jsp" class="dropdown-item"
								type="button">用户详情</a></li>
							<li><hr class="dropdown-divider"></li>
							<li><a href="logout" class="dropdown-item" type="button">退出登录</a></li>
						</ul></li>
				</ul>
			</div>
		</div>
	</nav>




<div id="upload_txt_Card" style="display: none; justify-content: space-between;">
<div class="card shadow" style="margin: 50px; margin-right: 50%" id="uploadCard">
  <div class="card-body">
    <h2 class="card-title">上传文件</h2>
    <form action="upload" method="post" enctype="multipart/form-data">
      <div class="mb-3">
        <label class="form-label">请选择文件</label>
        <input class="form-control" type="file" name="filePart" multiple>
      </div>
      <!-- 添加隐藏字段来传递当前路径 -->
      <input type="hidden" name="path" id="currentPath" value="">
      <input class="btn btn-primary" type="submit" value="上 传">
      <input class="btn btn-secondary" type="reset" value="重 置">
    </form>
  </div>
</div>

<div class="card shadow" style="margin: 50px; margin-right: 50%" id="uploadCard">
  <div class="card-body">



   <form action="EditServlet" method="post" enctype="multipart/form-data">
        <label for="title">标题:</label>
        <input type="text" name="title" id="title" required><br><br>

        <label for="content">内容:</label><br>
        <textarea name="content" id="content" rows="10" cols="50" required></textarea><br><br>


           <input class="btn btn-primary" type="submit" value="上 传">
    <input class="btn btn-secondary" type="reset" value="重 置">
    </form>
  </div>
</div>
</div>









	<div class="card shadow" style="margin: 50px;" id="filelistCard">
		<div class="content">
			<nav class="navbar navbar-expand-lg bg-body-tertiary">
				<div class="container-fluid">
					<div class="collapse navbar-collapse" id="navbarSupportedContent">
						<ul id="breadcrumbNav" class="navbar-nav me-auto mb-2 mb-lg-0">
						</ul>
						<div class="d-flex">
							<input class="form-control me-1" type="text" id="folderName"
								placeholder="请输入文件夹名字" aria-label="New Folder">
							<button id="createFolderButton" class="btn btn-outline-secondary"
								style="width: 150px;" onclick="createFolder()">创建文件夹</button>
						</div>
					</div>
				</div>
			</nav>
			<table class="table table-striped" id="fileTable">
			    <thead>
			        <tr>
			            <th onclick="sortTable(0)">
			                文件名
			                <span class="sort-icon">&uarr;&darr;</span>
			            </th>
			            <th onclick="sortTable(1)">
			                修改时间
			                <span class="sort-icon">&uarr;&darr;</span>
			            </th>
			            <th onclick="sortTable(2)">
			                大小
			                <span class="sort-icon">&uarr;&darr;</span>
			            </th>
			            <th onclick="sortTable(3)">
			                类型
			                <span class="sort-icon">&uarr;&darr;</span>
			            </th>
			            <th onclick="sortTable(4)">
			                路径
			                <span class="sort-icon">&uarr;&darr;</span>
			            </th>
			        </tr>
			    </thead>
				<tbody>
					<%-- 获取指定路径文件夹中的文件列表 --%>
					<%
							String requestedPath = request.getParameter("path");
							if (requestedPath != null) {
								folderPath = requestedPath;
							}

							File folder = new File(folderPath);
							File[] files = folder.listFiles();

							// 获取搜索关键字
							String searchQuery = request.getParameter("searchQuery");

							if (files != null) {
								for (File file : files) {
									String fileName = file.getName();
									long lastModified = file.lastModified();
									long fileSize = file.length();
									String fileType = file.isDirectory() ? "文件夹" : "文件";

									// 过滤文件名，实现搜索功能
									if (searchQuery != null && !searchQuery.isEmpty()
									&& !fileName.toLowerCase().contains(searchQuery.toLowerCase())) {
								continue;
									}

									String fileSizeFormatted;
									if (fileSize == 0) {
								fileSizeFormatted = "— —";
									} else {
								String[] units = { "bytes", "KB", "MB", "GB" };
								int unitIndex = 0;
								double fileSizeDisplay = fileSize;

								while (fileSizeDisplay >= 1024 && unitIndex < units.length - 1) {
									fileSizeDisplay /= 1024;
									unitIndex++;
								}

								// Check if fileSizeDisplay is greater than or equal to 1000 for GB unit
								if (unitIndex == units.length - 1 && fileSizeDisplay >= 1000) {
									fileSizeDisplay /= 1024;
									unitIndex++;
								}

								fileSizeFormatted = String.format("%.2f", fileSizeDisplay) + " " + units[unitIndex];
									}
							%>
					<!-- 文件列表行的代码 -->

					<tr>
						<%
						String[] imageExtensions = {".jpg", ".jpeg", ".png", ".gif", ".ico"}; // 常见的图片后缀名
						
						// 判断文件名后缀是否为图片后缀
						boolean isImage = false;
						for (String extension : imageExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isImage = true;
						        break;
						    }
						}
						
						String[] musicExtensions = {".mp3", ".wav", ".ogg"};
						
						boolean isMusic = false;
						for (String extension : musicExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isMusic = true;
						        break;
						    }
						}
						
						String[] videoExtensions = {".mp4", ".avi", ".mkv", ".mov"};

						boolean isVideo = false;
						for (String extension : videoExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isVideo = true;
						        break;
						    }
						}
						
						String[] zipExtensions = {".zip", ".rar", ".7z"}; 

						boolean isZip = false;
						for (String extension : zipExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isZip = true;
						        break;
						    }
						}
						
						String[] wordExtensions = {".doc", ".docx"}; 

						boolean isWord = false;
						for (String extension : wordExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isWord = true;
						        break;
						    }
						}
						
						String[] pptExtensions = {".ppt", ".pptx"}; 

						boolean isPpt = false;
						for (String extension : pptExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isPpt = true;
						        break;
						    }
						}
						
						String[] excelExtensions = {".xls", ".xlsx"}; 

						boolean isExcel = false;
						for (String extension : excelExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isExcel = true;
						        break;
						    }
						}
						
						String[] pdfExtensions = {".pdf"}; 

						boolean isPdf = false;
						for (String extension : pdfExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isPdf = true;
						        break;
						    }
						}
						
						String[] textExtensions = {".txt"};

						boolean isTxt = false;
						for (String extension : textExtensions) {
						    if (fileName.toLowerCase().endsWith(extension)) {
						        isTxt = true;
						        break;
						    }
						}
						%>
						
						
						<% if (fileType.equals("文件夹")) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
						        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-folder2-open" viewBox="0 0 16 16">
								  <path d="M1 3.5A1.5 1.5 0 0 1 2.5 2h2.764c.958 0 1.76.56 2.311 1.184C7.985 3.648 8.48 4 9 4h4.5A1.5 1.5 0 0 1 15 5.5v.64c.57.265.94.876.856 1.546l-.64 5.124A2.5 2.5 0 0 1 12.733 15H3.266a2.5 2.5 0 0 1-2.481-2.19l-.64-5.124A1.5 1.5 0 0 1 1 6.14V3.5zM2 6h12v-.5a.5.5 0 0 0-.5-.5H9c-.964 0-1.71-.629-2.174-1.154C6.374 3.334 5.82 3 5.264 3H2.5a.5.5 0 0 0-.5.5V6zm-.367 1a.5.5 0 0 0-.496.562l.64 5.124A1.5 1.5 0 0 0 3.266 14h9.468a1.5 1.5 0 0 0 1.489-1.314l.64-5.124A.5.5 0 0 0 14.367 7H1.633z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% } else if (isImage) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
						        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-image" viewBox="0 0 16 16">
						            <path d="M6.502 7a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z"/>
						            <path d="M14 14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5V14zM4 1a1 1 0 0 0-1 1v10l2.224-2.224a.5.5 0 0 1 .61-.075L8 11l2.157-3.02a.5.5 0 0 1 .76-.063L13 10V4.5h-2A1.5 1.5 0 0 1 9.5 3V1H4z"/>
						        </svg>
						        <%=fileName%>
						    </td>
<% } else if (isMusic) { %>
    <td onclick="window.location.href='/pdh-java-web/musicPlayer.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-music" viewBox="0 0 16 16">
            <path d="M11 6.64a1 1 0 0 0-1.243-.97l-1 .25A1 1 0 0 0 8 6.89v4.306A2.572 2.572 0 0 0 7 11c-.5 0-.974.134-1.338.377-.36.24-.662.628-.662 1.123s.301.883.662 1.123c.364.243.839.377 1.338.377.5 0 .974-.134 1.338-.377.36-.24.662-.628.662-1.123V8.89l2-.5V6.64z"/>
            <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/>
        </svg>
        <%=fileName%>
    </td>
<% } else if (isVideo) { %>
    <td onclick="playVideo('<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>');">
        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-play" viewBox="0 0 16 16">
            <path d="M6 6.883v4.234a.5.5 0 0 0 .757.429l3.528-2.117a.5.5 0 0 0 0-.858L6.757 6.454a.5.5 0 0 0-.757.43z"/>
            <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/>
        </svg>
        <%=fileName%>
    </td>
						<% }else if (isZip) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
					     	   <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-zip" viewBox="0 0 16 16">
								  <path d="M5 7.5a1 1 0 0 1 1-1h1a1 1 0 0 1 1 1v.938l.4 1.599a1 1 0 0 1-.416 1.074l-.93.62a1 1 0 0 1-1.11 0l-.929-.62a1 1 0 0 1-.415-1.074L5 8.438V7.5zm2 0H6v.938a1 1 0 0 1-.03.243l-.4 1.598.93.62.929-.62-.4-1.598A1 1 0 0 1 7 8.438V7.5z"/>
								  <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1h-2v1h-1v1h1v1h-1v1h1v1H6V5H5V4h1V3H5V2h1V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% }else if (isWord) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
					     	   <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-word" viewBox="0 0 16 16">
								  <path d="M5.485 6.879a.5.5 0 1 0-.97.242l1.5 6a.5.5 0 0 0 .967.01L8 9.402l1.018 3.73a.5.5 0 0 0 .967-.01l1.5-6a.5.5 0 0 0-.97-.242l-1.036 4.144-.997-3.655a.5.5 0 0 0-.964 0l-.997 3.655L5.485 6.88z"/>
								  <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% }else if (isPpt) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
								<svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-ppt" viewBox="0 0 16 16">
								  <path d="M7 5.5a1 1 0 0 0-1 1V13a.5.5 0 0 0 1 0v-2h1.188a2.75 2.75 0 0 0 0-5.5H7zM8.188 10H7V6.5h1.188a1.75 1.75 0 1 1 0 3.5z"/>
								  <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% }else if (isExcel) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
					     	    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-excel" viewBox="0 0 16 16">
								  <path d="M5.884 6.68a.5.5 0 1 0-.768.64L7.349 10l-2.233 2.68a.5.5 0 0 0 .768.64L8 10.781l2.116 2.54a.5.5 0 0 0 .768-.641L8.651 10l2.233-2.68a.5.5 0 0 0-.768-.64L8 9.219l-2.116-2.54z"/>
								  <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% }else if (isPdf) { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
					     	    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-pdf" viewBox="0 0 16 16">
								  <path d="M14 14V4.5L9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2zM9.5 3A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5v2z"/>
								  <path d="M4.603 14.087a.81.81 0 0 1-.438-.42c-.195-.388-.13-.776.08-1.102.198-.307.526-.568.897-.787a7.68 7.68 0 0 1 1.482-.645 19.697 19.697 0 0 0 1.062-2.227 7.269 7.269 0 0 1-.43-1.295c-.086-.4-.119-.796-.046-1.136.075-.354.274-.672.65-.823.192-.077.4-.12.602-.077a.7.7 0 0 1 .477.365c.088.164.12.356.127.538.007.188-.012.396-.047.614-.084.51-.27 1.134-.52 1.794a10.954 10.954 0 0 0 .98 1.686 5.753 5.753 0 0 1 1.334.05c.364.066.734.195.96.465.12.144.193.32.2.518.007.192-.047.382-.138.563a1.04 1.04 0 0 1-.354.416.856.856 0 0 1-.51.138c-.331-.014-.654-.196-.933-.417a5.712 5.712 0 0 1-.911-.95 11.651 11.651 0 0 0-1.997.406 11.307 11.307 0 0 1-1.02 1.51c-.292.35-.609.656-.927.787a.793.793 0 0 1-.58.029zm1.379-1.901c-.166.076-.32.156-.459.238-.328.194-.541.383-.647.547-.094.145-.096.25-.04.361.01.022.02.036.026.044a.266.266 0 0 0 .035-.012c.137-.056.355-.235.635-.572a8.18 8.18 0 0 0 .45-.606zm1.64-1.33a12.71 12.71 0 0 1 1.01-.193 11.744 11.744 0 0 1-.51-.858 20.801 20.801 0 0 1-.5 1.05zm2.446.45c.15.163.296.3.435.41.24.19.407.253.498.256a.107.107 0 0 0 .07-.015.307.307 0 0 0 .094-.125.436.436 0 0 0 .059-.2.095.095 0 0 0-.026-.063c-.052-.062-.2-.152-.518-.209a3.876 3.876 0 0 0-.612-.053zM8.078 7.8a6.7 6.7 0 0 0 .2-.828c.031-.188.043-.343.038-.465a.613.613 0 0 0-.032-.198.517.517 0 0 0-.145.04c-.087.035-.158.106-.196.283-.04.192-.03.469.046.822.024.111.054.227.09.346z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% }else if (isTxt) { %>
						    <td onclick="window.location.href='/pdh-java-web/check.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
					     	    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-font" viewBox="0 0 16 16">
								  <path d="M10.943 6H5.057L5 8h.5c.18-1.096.356-1.192 1.694-1.235l.293-.01v5.09c0 .47-.1.582-.898.655v.5H9.41v-.5c-.803-.073-.903-.184-.903-.654V6.755l.298.01c1.338.043 1.514.14 1.694 1.235h.5l-.057-2z"/>
								  <path d="M14 4.5V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2a2 2 0 0 1 2-2h5.5L14 4.5zm-3 0A1.5 1.5 0 0 1 9.5 3V1H4a1 1 0 0 0-1 1v12a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V4.5h-2z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% } else { %>
						    <td onclick="window.location.href='/pdh-java-web/filelist.jsp?path=<%=URLEncoder.encode(file.getAbsolutePath().replace("\\", "/"), "UTF-8")%>'">
						        <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-file-earmark-text" viewBox="0 0 16 16">
								  <path d="M5.5 7a.5.5 0 0 0 0 1h5a.5.5 0 0 0 0-1h-5zM5 9.5a.5.5 0 0 1 .5-.5h5a.5.5 0 0 1 0 1h-5a.5.5 0 0 1-.5-.5zm0 2a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 0 1h-2a.5.5 0 0 1-.5-.5z"/>
								  <path d="M9.5 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.5L9.5 0zm0 1v2A1.5 1.5 0 0 0 11 4.5h2V14a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h5.5z"/>
								</svg>
						        <%=fileName%>
						    </td>
						<% } %>


						<td><%=new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(lastModified))%></td>
						
						<td><%=fileSizeFormatted%></td>
						
						<%
						String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1);
						%>
						
						<td>
						  <% if (fileExtension.isEmpty() || fileType.equals("文件夹")) { %>
						    <%= fileType %>
						  <% } else { %>
						    <%= fileExtension %> <%= fileType %>
						  <% } %>
						</td>
	
						<%
						String filePath = file.getAbsolutePath();
						String displayedPath = filePath.substring(filePath.indexOf(userInfo.getUsername()));
						%>
	
						<td><%= displayedPath %></td>
						
						<td>

						<button type="button" class="btn btn-outline-primary" onclick="downloadFile('<%= file.getAbsolutePath() %>')">
						    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-cloud-download-fill" viewBox="0 0 16 16">
						        <path fill-rule="evenodd" d="M8 0a5.53 5.53 0 0 0-3.594 1.342c-.766.66-1.321 1.52-1.464 2.383C1.266 4.095 0 5.555 0 7.318 0 9.366 1.708 11 3.781 11H7.5V5.5a.5.5 0 0 1 1 0V11h4.188C14.502 11 16 9.57 16 7.773c0-1.636-1.242-2.969-2.834-3.194C12.923 1.999 10.69 0 8 0zm-.354 15.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 14.293V11h-1v3.293l-2.146-2.147a.5.5 0 0 0-.708.708l3 3z"/>
						    </svg>
						</button>

						<button type="button" class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#deleteCard" onclick="setDeleteInfo(this)">
						  	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash3-fill" viewBox="0 0 16 16">
							  <path d="M11 1.5v1h3.5a.5.5 0 0 1 0 1h-.538l-.853 10.66A2 2 0 0 1 11.115 16h-6.23a2 2 0 0 1-1.994-1.84L2.038 3.5H1.5a.5.5 0 0 1 0-1H5v-1A1.5 1.5 0 0 1 6.5 0h3A1.5 1.5 0 0 1 11 1.5Zm-5 0v1h4v-1a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 0-.5.5ZM4.5 5.029l.5 8.5a.5.5 0 1 0 .998-.06l-.5-8.5a.5.5 0 1 0-.998.06Zm6.53-.528a.5.5 0 0 0-.528.47l-.5 8.5a.5.5 0 0 0 .998.058l.5-8.5a.5.5 0 0 0-.47-.528ZM8 4.5a.5.5 0 0 0-.5.5v8.5a.5.5 0 0 0 1 0V5a.5.5 0 0 0-.5-.5Z"/>
							</svg>
						</button>
						
						
						
						<div class="modal fade" id="deleteCard" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
						  <div class="modal-dialog">
						    <div class="modal-content">
						      <div class="modal-header">
						        <h1 class="modal-title fs-5" id="exampleModalLabel">是否确认删除文件</h1>
						        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
						      </div>
						      <div class="modal-body text-center">
						        <p>确定删除 "<span id="deleteFileName"></span>"?</p>
						      </div>
						      <div class="modal-footer">
						        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
						        <a id="confirmDeleteButton" class="btn btn-outline-danger">删除</a>
						      </div>
						    </div>
						  </div>
						</div>


							
						</td>
					</tr>
							<%
							}
							}
							%>
				</tbody>
			</table>
		</div>
	</div>

<script>
    function openFile(filePath) {
        var url = '/pdh-java-web/check.jsp?path=' + encodeURIComponent(filePath);
        window.location.href = url;
    }
</script>
<script>

  $(document).ready(function() {
	    // 初始化Bootstrap模态框组件
	    var deleteModal = new bootstrap.Modal(document.getElementById('deleteCard'));
	  });
	
  // 获取当前路径并设置隐藏字段的值
  var currentPath = window.location.href;
  document.getElementById("currentPath").value = currentPath;
  // 获取上传按钮和上传面板的引用
  const uploadLink = document.getElementById('uploadLink');
  const uploadCard = document.getElementById('upload_txt_Card');

//点击上传按钮时的事件处理函数
  uploadLink.addEventListener('click', function(event) {
    event.preventDefault(); // 阻止默认的跳转行为
    // 切换上传面板的显示状态
    upload_txt_Card.style.display = upload_txt_Card.style.display === 'none' ? 'block' : 'none';
  });

	
	
  // 获取当前路径
  var currentPath = "<%= folderPath %>";
  
  // 获取导航栏元素
  var breadcrumbNav = document.getElementById("breadcrumbNav");
  
  // 清空导航栏
  breadcrumbNav.innerHTML = "";
  
  // 切割当前路径
  var pathSegments = currentPath.split("/");
  
  // 逐个添加导航链接
  var i;
	for (i = 0; i < pathSegments.length - 1; i++) {
	  if (pathSegments[i - 2] === "webapp" && pathSegments[i - 1] === "webfiles") {
	    break;
	  }
	}

  for (i; i < pathSegments.length; i++) {
    // 获取路径段
    var pathSegment = pathSegments[i];
    
    // 拼接路径段到当前路径
    var path = pathSegments.slice(0, i + 1).join("/");
    
    // 创建导航链接元素
    var link = document.createElement("a");
    link.href = "/pdh-java-web/filelist.jsp?path=" + encodeURIComponent(path);
    link.textContent = pathSegment;
    
    // 创建导航项元素
    var listItem = document.createElement("li");
    listItem.className = "breadcrumb-item";
    listItem.appendChild(link);
    
    // 添加导航项到导航栏
    breadcrumbNav.appendChild(listItem);
  }

  
  
  
  
  
  
  function playMusic(filePath) {
	  var url = "/pdh-java-web/play?playPath=" + encodeURIComponent(filePath);

	    // 发送 AJAX 请求到后端
	    var xhr = new XMLHttpRequest();
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4 && xhr.status === 200) {
	            // 创建音频元素并设置源
	            var audioPlayer = document.createElement("audio");
	            audioPlayer.controls = true;
	            audioPlayer.src = URL.createObjectURL(xhr.response);
	            document.body.appendChild(audioPlayer);
	        }
	    };
	    xhr.open("GET", url, true);
	    xhr.responseType = "blob"; // 设置响应类型为 blob
	    xhr.send();
	}

	function playVideo(filePath) {
		var url = "/pdh-java-web/play?playPath=" + encodeURIComponent(filePath);

	    // 发送 AJAX 请求到后端
	    var xhr = new XMLHttpRequest();
	    xhr.onreadystatechange = function() {
	        if (xhr.readyState === 4 && xhr.status === 200) {
	            // 创建视频元素并设置源
	            var videoPlayer = document.createElement("video");
	            videoPlayer.controls = true;
	            videoPlayer.src = URL.createObjectURL(xhr.response);
	            document.body.appendChild(videoPlayer);
	        }
	    };
	    xhr.open("GET", url, true);
	    xhr.responseType = "blob"; // 设置响应类型为 blob
	    xhr.send();
	}

	
	
	
  
  
  function createFolder() {
	    var folderName = document.getElementById("folderName").value.trim();

	    // 检查文件夹名称是否有效
	    if (folderName === "") {
	        alert("请输入有效的文件夹名称。");
	        return;
	    }

	    // 执行创建文件夹的操作
	    var newFolderPath = currentPath + "/" + folderName;

	    // 发送请求到服务器创建文件夹
	    var xhttp = new XMLHttpRequest();
	    xhttp.onreadystatechange = function() {
	        if (this.readyState == 4) {
	            if (this.status == 200) {
	                console.log("文件夹创建成功：" + newFolderPath);
	                // 刷新文件列表
	                getFileList();
	            } else {
	                console.log("文件夹创建失败：" + newFolderPath);
	                // 处理创建失败的情况
	            }
	        }
	    };
	    xhttp.open("POST", "filelist", true);
	    xhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	    xhttp.send("path=" + encodeURIComponent(currentPath) + "&newFolderName=" + encodeURIComponent(folderName));
	}

	function getFileList() {
	    // 发送请求到服务器获取文件列表
	    var xhttp = new XMLHttpRequest();
	    xhttp.onreadystatechange = function() {
	        if (this.readyState == 4 && this.status == 200) {
	            // 刷新文件列表
	            location.reload();
	        }
	    };
	    xhttp.open("GET", "filelist?path=" + encodeURIComponent(currentPath), true);
	    xhttp.send();
	}



  
  
  
  
  
  
  
  

  
  
  
	function downloadFile(filePath) {
	    var encodedPath = encodeURIComponent(filePath.replace(/\\/g, "/"));
	    window.location.href = "/display?path=" + encodedPath;
	}
  
  function setDeleteInfo(button) {
	  // 获取所在行的文件信息
	  var row = button.closest('tr');
	  var fileName = row.cells[0].textContent;
	  var filePath = "C:/Users/86180/git/pdh-java-web/src/main/webapp" + "/webfiles/" + row.cells[4].textContent;

	  // 设置模态框中的文件名和文件路径
	  var deleteFileName = document.getElementById('deleteFileName');
	  deleteFileName.textContent = fileName;

	  // 修改确认按钮的href属性
	  var deleteButton = document.getElementById('confirmDeleteButton');
	  deleteButton.href = 'DeleteServlet?path=' + encodeURIComponent(filePath);
	}

  
  var direction = "desc"; // 默认排序顺序为倒序

  function sortTable(columnIndex) {
      var table = document.getElementById("fileTable");
      var rows = table.rows;
      var switching = true;
      var shouldSwitch, i;

      while (switching) {
          switching = false;
          for (i = 1; i < (rows.length - 1); i++) {
              shouldSwitch = false;
              var x = rows[i].getElementsByTagName("TD")[columnIndex];
              var y = rows[i + 1].getElementsByTagName("TD")[columnIndex];
              var xValue = x.innerHTML.toLowerCase();
              var yValue = y.innerHTML.toLowerCase();

              // 根据当前排序顺序和单元格值比较
              if (direction === "asc") {
                  if (xValue > yValue) {
                      shouldSwitch = true;
                      break;
                  }
              } else if (direction === "desc") {
                  if (xValue < yValue) {
                      shouldSwitch = true;
                      break;
                  }
              }
          }
          if (shouldSwitch) {
              rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
              switching = true;
          }
      }

      // 切换排序顺序
      if (direction === "asc") {
          direction = "desc";
      } else if (direction === "desc") {
          direction = "asc";
      }
  }

  window.onload = function() {
      sortTable(3);
  };

</script>

</body>
</html>