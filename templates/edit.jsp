<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

<style>
.text-editor {
  width: 400px; /* 固定宽度 */
  height: 200px; /* 固定高度 */
  border: 1px solid #ccc; /* 边框样式 */
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); /* 阴影效果 */
  padding: 10px; /* 内边距 */
  resize: none; /* 禁止调整大小 */
}
</style>

</head>
<body>
 <h1>Web文本编辑器</h1>

    <form action="EditServlet" method="post" enctype="multipart/form-data">
        <label for="title">标题:</label>
        <input type="text" name="title" id="title" required><br><br>

        <label for="content">内容:</label><br>
        <textarea name="content" id="content" rows="10" cols="50" required></textarea><br><br>

        <label for="file">上传文件:</label>
        <input type="file" name="file" id="file"><br><br>

        <input type="submit" value="保存">
    </form>

</body>
</html>
