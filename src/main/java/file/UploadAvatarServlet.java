package file;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

import model.UserModel;

@WebServlet(urlPatterns = { "/uploadAvatar" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 20, // 20MB
                 maxRequestSize = 1024 * 1024 * 50) // 50MB
public class UploadAvatarServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uploadPath = "C:/Users/86180/git/pdh-java-web/src/main/webapp/profile_picture";
        UserModel userModel = (UserModel) request.getSession().getAttribute("USER_INFO");
        // 删除当前头像文件
        String currentAvatarUrl = userModel.getAvatarUrl();
        String currentFileName = currentAvatarUrl.substring(currentAvatarUrl.lastIndexOf("/") + 1);
        String deletePath = uploadPath + File.separator + currentFileName;
        File currentFile = new File(deletePath);
        if (!currentFileName.equals("0123456789default.png")) {
            currentFile.delete();
        }

        Part filePart = request.getPart("file");
        String fileName = filePart.getSubmittedFileName();
        String extension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();

        if (extension.equals("png") || extension.equals("jpg") || extension.equals("jpeg") || extension.equals("ico")) {
            String username = (String) request.getSession().getAttribute("username");
            String newFileName = username + "." + extension;

            // 将文件保存到指定路径
            File uploadDirectory = new File(uploadPath);
            uploadDirectory.mkdirs(); // 创建目录，如果不存在的话
            File file = new File(uploadDirectory, newFileName);

            try (InputStream input = filePart.getInputStream();
                 OutputStream output = new FileOutputStream(file)) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = input.read(buffer)) != -1) {
                    output.write(buffer, 0, bytesRead);
                }
            }

            // 更新userModel中的avatarUrl属性
            String avatarUrl = request.getContextPath() + "/profile_picture/" + newFileName;
            userModel.setAvatarUrl(avatarUrl);

            // 将更新后的userModel保存到session
            request.getSession().setAttribute("USER_INFO", userModel);

            // 刷新当前页面显示新头像
            response.sendRedirect(request.getRequestURI());
        } else {
            // 文件格式不正确
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "请选择正确的图像格式");
        }
    }
}
