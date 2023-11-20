<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.File" %>
<%@ page import="model.FileModel" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.net.URLEncoder"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">

<title>文件列表</title>
<style>
  /* 左侧边栏样式 */
  .sidebar {
    position: fixed;
    top: 80px; /* 调整为适合的值 */
    left: 0;
    height: calc(100% - 80px); /* 调整为适合的值 */
    width: 200px; /* 调整为适合的值 */
    padding: 20px;
    background-color: #f8f9fa;
    overflow-y: auto;
    margin-top: 20; /* 移除左侧目录的上方外边距 */
    padding-top: 2; /* 移除左侧目录的上方内边距 */
  }
  .content {
  margin-top: 1000;
    margin-left: 20px; /* 左侧边栏的宽度 */
    padding: 20px;
    width: 1500px; 
  }

  .text-editor {
  width: 400px; /* 固定宽度 */
  height: 200px; /* 固定高度 */
  border: 1px solid #ccc; /* 边框样式 */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  padding: 10px; /* 内边距 */
  resize: none; /* 禁止调整大小 */
}


        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

</style>

</head>

<body>

<nav>
  <div class="nav nav-tabs" id="nav-tab" role="tablist">
      <button class="nav-link" id="nav-disabled-tab" data-bs-toggle="tab" data-bs-target="#nav-disabled" type="button" role="tab" aria-controls="nav-disabled" aria-selected="false" disabled>蛋蛋</button>
    <button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true"  onclick="window.location.href='filelist.jsp'">文件管理器</button>

    <button class="nav-link" id="nav-contact-tab" data-bs-toggle="tab" data-bs-target="#nav-contact" type="button" role="tab" aria-controls="nav-contact" aria-selected="true" onclick="window.location.href='index.jsp'">退出系统</button>

  </div>
</nav>


<div class="d-flex align-items-start">
  <div class="nav flex-column nav-pills me-3" id="v-pills-tab" role="tablist" aria-orientation="vertical">
    <button class="nav-link active" id="v-pills-home-tab" data-bs-toggle="pill" data-bs-target="#v-pills-home" type="button" role="tab" aria-controls="v-pills-home" aria-selected="true">文件列表</button>
    <button class="nav-link" id="v-pills-profile-tab" data-bs-toggle="pill" data-bs-target="#v-pills-profile" type="button" role="tab" aria-controls="v-pills-profile" aria-selected="false">文本编辑器</button>
    <button class="nav-link" id="v-pills-disabled-tab" data-bs-toggle="pill" data-bs-target="#v-pills-disabled" type="button" role="tab" aria-controls="v-pills-disabled" aria-selected="false" disabled>Disabled</button>
    <button class="nav-link" id="v-pills-messages-tab" data-bs-toggle="pill" data-bs-target="#v-pills-messages" type="button" role="tab" aria-controls="v-pills-messages" aria-selected="false">音乐播放器</button>
    <button class="nav-link" id="v-pills-settings-tab" data-bs-toggle="pill" data-bs-target="#v-pills-settings" type="button" role="tab" aria-controls="v-pills-settings" aria-selected="false">设置</button>
  </div>
  
  
  
<div class="tab-content" id="v-pills-tabContent">
    <div class="tab-pane fade show active" id="v-pills-home" role="tabpanel" aria-labelledby="v-pills-home-tab" tabindex="0">
        <div class="content">
            <div class="row mt-3">
                <div class="col">
                    <div class="card shadow">
                        <div class="card-body">
                            <h1 class="card-title">文件列表</h1>
                            <table>
                                <tr>
                                    <th>文件名</th>
                                    <th>路径</th>                                 
                                    <th>是否为目录</th>
                                    <th>预览/编辑</th>
                                    <th> 删除</th>
                                </tr>
                               <%
    String directoryPath = "weblist/21020007074";
    File directory = new File(directoryPath);
    File[] files = directory.listFiles();

    if (files != null) {
        for (File file : files) {
            String name = file.getName();
            String path = file.getPath();
            boolean isDirectory = file.isDirectory();
%>
<tr>
    <td><%= name %></td>
    <td><%= path %></td>
    <td><%= isDirectory ? "是" : "否" %></td>
    <td><a href="DisplayServlet?path=<%= java.net.URLEncoder.encode(path, "UTF-8") %>">预览/编辑</a></td>
    <td><a href="DeleteServlet?path=<%= java.net.URLEncoder.encode(path, "UTF-8") %>">删除</a></td>
    

</tr>
<%
        }
    }
%>

   </table>
                            
                            
                            
                        
	<form action="EditServlet" method="post" enctype="multipart/form-data">

    <h2 class="card-title"></h2>
    <label for="title">标题:</label>
    <input type="text" name="title" id="title" required><br><br>

    <label for="content">内容:</label><br>
    <textarea name="content" id="content" rows="10" cols="50" required></textarea><br><br>

    <input type="hidden" name="action" id="action" value=""><!-- 用于记录当前操作 -->

    <input class="btn btn-primary" type="submit" value="保存">
    <input class="btn btn-secondary" type="reset" value="重 置">
</form>

<script>
    // 获取URL参数
    function getUrlParameter(name) {
        name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
        var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
        var results = regex.exec(location.search);
        return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g, ' '));
    }

    // 根据URL参数确定操作
    function determineAction() {
        var path = getUrlParameter('path');
        if (path) {
            // 存在'path'参数表示预览/编辑操作
            document.getElementById('action').value = 'preview';
            fetchEditServletContent(path);
        } else {
            // 其他情况，如新增文件或编辑其他文件
            document.getElementById('action').value = 'edit';
            fetchDisplayServletContent(); // 从DisplayServlet中获取内容
        }
    }

    // 从EditServlet中获取内容并设置到文本框中
    function fetchEditServletContent(path) {
        fetch('EditServlet?path=' + encodeURIComponent(path))
            .then(response => response.text())
            .then(content => {
                document.getElementById('content').value = content;
            })
            .catch(error => {
                console.error('错误:', error);
            });
    }

    // 从DisplayServlet中获取内容并设置到文本框中
    function fetchDisplayServletContent() {
        fetch('DisplayServlet')
            .then(response => response.text())
            .then(content => {
                document.getElementById('content').value = content;
            })
            .catch(error => {
                console.error('错误:', error);
            });
    }

    determineAction();
</script>




        
        

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


    
    
    
    
    <div class="tab-pane fade" id="v-pills-profile" role="tabpanel" aria-labelledby="v-pills-profile-tab" tabindex="0">
 <div class="content">
    
    <div class="row mt-3">
			<div class="col">
				<div class="card shadow">
					<div class="card-body">
						<h2 class="card-title">上传文件</h2>
						<!-- enctype：编码类型; multipart/form-data：表单数据有多部分构成，既有文本数据又有文件等二进制数据 -->
						<form action="upload" method="post" enctype="multipart/form-data">
							<div class="mb-3">
								<label class="form-label">请选择文件</label> <input
									class="form-control" type="file" name="filePart" multiple>
							</div>
							<div class="mb-3">
								<label class="form-label">上传者</label> <input
									class="form-control" type="text" name="userPart">
							</div>
							<input class="btn btn-primary" type="submit" value="上 传">
							<input class="btn btn-secondary" type="reset" value="重 置">
						</form>

					
				</div>
			</div>
		</div>
	</div>
	
  </div>
  				</div>
			</div>
		</div>
	</div>
    
    
    
    </div>
    <div class="tab-pane fade" id="v-pills-disabled" role="tabpanel" aria-labelledby="v-pills-disabled-tab" tabindex="0">应该</div>
    <div class="tab-pane fade" id="v-pills-messages" role="tabpanel" aria-labelledby="v-pills-messages-tab" tabindex="0">在这里</div>
    <div class="tab-pane fade" id="v-pills-settings" role="tabpanel" aria-labelledby="v-pills-settings-tab" tabindex="0">显示</div>
  </div>

 



 

    
  
	
	
	
		
	
</body>
    <div id="pageContent"></div>
 

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"
  integrity="sha384-ENjdO4Dr2bkBIFxQpeoTz1HIcje39Wm4jDKdf19U8gI4ddQ3GYNS7NTKfAdVQSZe"
  crossorigin="anonymous"></script>
  <script>
 window.onload = function() {
            var deleteSuccess = '<%= request.getParameter("deleteSuccess") %>';
            if (deleteSuccess === 'true') {
                alert('文件删除成功');
            }
        }

</script>
</body>
</html>
