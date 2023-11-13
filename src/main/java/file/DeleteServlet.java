package file;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Comparator;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String deleteFile = request.getParameter("path");

        try {
            if (deleteFile != null) {
                String decodedPath = URLDecoder.decode(deleteFile, "UTF-8");
                Path filePath = Paths.get(decodedPath);

                // 如果是文件夹，则遍历文件夹中的所有内容并逐个删除
                if (Files.isDirectory(filePath)) {
                    Files.walk(filePath)
                            .sorted(Comparator.reverseOrder())
                            .map(Path::toFile)
                            .forEach(File::delete);
                } else {
                    Files.delete(filePath);
                }

                // 移除最后一个斜杠后面的内容，并将反斜杠替换为正斜杠
                String parentPath = filePath.getParent().toString().replace("\\", "/");

                response.sendRedirect(request.getContextPath() + "/filelist?path=" + URLEncoder.encode(parentPath, "UTF-8"));
            } else {
                response.sendRedirect("/pdh-java-web/error.jsp"); // 文件不存在，重定向到错误页面
            }
        } catch (IOException e) {
            e.printStackTrace();
            response.sendRedirect("/pdh-java-web/error.jsp"); // 处理文件删除失败，重定向到错误页面
        }
    }
}
