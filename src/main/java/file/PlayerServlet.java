package file;

import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = { "/play" })
public class PlayerServlet extends HttpServlet {

	// 获取文件扩展名
	private String getFileExtension(String filePath) {
		int dotIndex = filePath.lastIndexOf(".");
		if (dotIndex > 0 && dotIndex < filePath.length() - 1) {
			return filePath.substring(dotIndex + 1).toLowerCase();
		}
		return "";
	}

	// 判断是否为音频文件
	private boolean isAudioFile(String fileExtension) {
		String[] audioExtensions = {".mp3", ".wav", ".ogg"};
		for (String extension : audioExtensions) {
			if (extension.equals(fileExtension)) {
				return true;
			}
		}
		return false;
	}

	// 判断是否为视频文件
	private boolean isVideoFile(String fileExtension) {
		String[] videoExtensions = {".mp4", ".avi", ".mkv", ".mov"};
		for (String extension : videoExtensions) {
			if (extension.equals(fileExtension)) {
				return true;
			}
		}
		return false;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 获取请求中的文件路径（绝对路径）
		String filePath = URLDecoder.decode(request.getParameter("filePath"), "UTF-8");

		// 获取文件扩展名
		String fileExtension = getFileExtension(filePath);

		// 读取文件并发送到浏览器
		try (FileInputStream fis = new FileInputStream(filePath)) {
			// 设置响应头，指定文件类型
			String contentType;
			if (isAudioFile(fileExtension)) {
				contentType = "audio/" + fileExtension;
			} else if (isVideoFile(fileExtension)) {
				contentType = "video/" + fileExtension;
			} else {
				// 文件类型不支持
				response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE);
				return;
			}
			response.setContentType(contentType);
			response.setHeader("Content-Disposition", "inline");

			// 将文件的输入流复制到响应的输出流
			byte[] buffer = new byte[4096];
			int bytesRead;
			while ((bytesRead = fis.read(buffer)) != -1) {
				response.getOutputStream().write(buffer, 0, bytesRead);
			}
		}
	}
}
