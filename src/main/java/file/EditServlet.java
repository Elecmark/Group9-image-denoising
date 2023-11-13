package file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.annotation.MultipartConfig;
import java.nio.charset.StandardCharsets;
import java.io.InputStreamReader;

@WebServlet("/EditServlet")
@MultipartConfig
public class EditServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain; charset=UTF-8");

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // 指定保存文件的目录和文件名
        String username = (String) request.getSession().getAttribute("username");
        String saveDirectory = "C:/Users/86180/git/pdh-java-web/src/main/webapp" + "/webfiles/" + username;
        String fileName = title + ".txt";

        // 创建文件
        File file = new File(saveDirectory, fileName);

        // 将标题和内容写入文件
        try (FileOutputStream fos = new FileOutputStream(file);
             OutputStreamWriter writer = new OutputStreamWriter(fos, StandardCharsets.UTF_8)) {
            // 写入文件内容
            writer.write(content);
        } catch (IOException e) {
            e.printStackTrace();
            // 处理文件写入异常
            // 可以返回错误信息或进行其他处理
        }

        // 返回保存成功的消息
        String message = "文件保存成功！";
        request.setAttribute("message", message);

       

        // 读取文件内容并输出
        try (FileInputStream fis = new FileInputStream(file);
             InputStreamReader reader = new InputStreamReader(fis, StandardCharsets.UTF_8)) {
            char[] buffer = new char[1024];
            int length;
            while ((length = reader.read(buffer)) != -1) {
                response.getWriter().write(buffer, 0, length);
            }
        } catch (IOException e) {
            e.printStackTrace();
            // 处理文件读取异常
            // 可以返回错误信息或进行其他处理
        }

        response.sendRedirect("filelist.jsp"); // 重定向到成功页面
    }


}
