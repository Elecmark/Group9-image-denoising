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
