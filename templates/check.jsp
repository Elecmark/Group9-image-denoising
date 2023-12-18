<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.net.URLDecoder" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>打开文件</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css"
          rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ"
          crossorigin="anonymous">
</head>
<body>
<%
    String filePath = request.getParameter("path");
    filePath = URLDecoder.decode(filePath, "UTF-8");
    File file = new File(filePath);
    String fileName = file.getName();

    String content = "";
    if (file.exists()) {
        FileReader fileReader = new FileReader(file);
        BufferedReader bufferedReader = new BufferedReader(fileReader);
        String line;
        while ((line = bufferedReader.readLine()) != null) {
            content += line + "\n";
        }
        bufferedReader.close();
        fileReader.close();
    }
%>

<div class="edit">
    <form action="" method="post">
        <input type="hidden" name="filePath" value="<%= filePath %>">
        <input type="text" class="fileName" value="<%= fileName %>"><br>
        <textarea name="content" rows="10" cols="50"><%= content %></textarea>
        <br>
        <input type="submit" value="保存">
        <input type="reset" value="重置">
        <a href="filelist.jsp" class="btn btn-primary">返回</a>
        
    </form>
</div>

<%
String saveFilePath = request.getParameter("filePath");
String saveContent = request.getParameter("content");

if (saveFilePath != null && !saveFilePath.isEmpty()) {
    try {
        // Create a temporary file
        File tempFile = File.createTempFile("temp", null);
        
        // Write the content to the temporary file
        FileWriter fileWriter = new FileWriter(tempFile);
        fileWriter.write(saveContent);
        fileWriter.close();
        
        // Rename the temporary file to replace the original file
        File originalFile = new File(saveFilePath);
        tempFile.renameTo(originalFile);
        
        // Show a success message
        out.println("<p>保存成功！</p>");
    } catch (Exception e) {
        // Handle any exceptions that occur during file writing
        e.printStackTrace();
        
        // Show an error message
        out.println("<p>保存失败，请重试。</p>");
    }
}
%>


</body>
</html>
