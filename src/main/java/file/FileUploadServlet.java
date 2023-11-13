package file;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.PrintWriter;
import java.util.Iterator;
import java.net.URLDecoder;

@WebServlet(urlPatterns = { "/upload" })
@MultipartConfig // 声明这个类是用来处理(文件)流
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String encodedPath = request.getParameter("path"); // 获取完整URL中的参数部分，如：webfiles/21020007074/A
        String decodedPath = URLDecoder.decode(encodedPath, "UTF-8"); // 解码路径
        String uploadPath = getServletContext().getRealPath("") + File.separator + decodedPath.substring(decodedPath.indexOf("=") + 1);

        Iterator<Part> parts = request.getParts().iterator();

        while(parts.hasNext()) {
            Part p = parts.next();
            if (p.getContentType() == null) {
                System.out.println(request.getParameter(p.getName()));
            } else {
                String fileName = p.getSubmittedFileName();
                File uploadDirectory = new File(uploadPath);
                uploadDirectory.mkdirs(); // 创建目录，如果不存在的话
                p.write(uploadDirectory.getPath() + File.separator + fileName);
            }
        }

        response.setContentType("text/html");
        response.setCharacterEncoding("utf-8");
        PrintWriter writer = response.getWriter();
        writer.println("<h1>" + username + ", 您的文件上传成功</h1>");

        // 重定向回之前的页面
        response.sendRedirect(encodedPath);


        
		// 也可以重定向到其他的页面或站点
		// 重定向到http://kernel.org
		//resp.setStatus(HttpServletResponse.SC_MOVED_TEMPORARILY);
		//resp.setHeader("Location", "http://kernel.org");
		// 重定向到index.html
	}
}