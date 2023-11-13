<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.nio.file.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>播放</title>
</head>
<body>
    <audio id="audioPlayer" controls></audio>
    <video id="videoPlayer" controls></video>

    <script>
        // 从 URL 参数中获取要播放的文件路径
        var filePath = decodeURIComponent('<%= request.getParameter("filePath") %>');

        // 发送 AJAX 请求到后端，获取音乐或视频数据
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // 根据文件类型选择播放函数
                var contentType = xhr.getResponseHeader("Content-Type");
                if (contentType.startsWith("audio/")) {
                    playAudio(xhr.response);
                } else if (contentType.startsWith("video/")) {
                    playVideo(xhr.response);
                }
            }
        };
        xhr.open("GET", "/pdh-java-web/play?filePath=" + encodeURIComponent(filePath), true);
        xhr.responseType = "blob"; // 设置响应类型为 blob
        xhr.send();
        
        function playAudio(data) {
            var audioPlayer = document.getElementById("audioPlayer");
            audioPlayer.src = URL.createObjectURL(data);
        }

        function playVideo(data) {
            var videoPlayer = document.getElementById("videoPlayer");
            videoPlayer.src = URL.createObjectURL(data);
        }
    </script>
</body>
</html>
