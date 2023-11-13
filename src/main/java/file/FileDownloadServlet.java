package file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLDecoder;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/display")
public class FileDownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public FileDownloadServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filePath = request.getParameter("path"); // 获取文件路径

        // 对文件路径进行解码
        filePath = URLDecoder.decode(filePath, "UTF-8");

        File file = new File(filePath);
        if (file.exists()) {
            // 设置响应头信息
            response.setContentType("application/octet-stream");
            response.setContentLength((int) file.length());
            response.setHeader("Content-Disposition", "inline; filename=\"" + file.getName() + "\"");

            try (FileInputStream fileInputStream = new FileInputStream(file);
                 ServletOutputStream outputStream = response.getOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } else {
            // 处理文件不存在的情况
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
