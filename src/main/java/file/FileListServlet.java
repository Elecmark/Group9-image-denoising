package file;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.FileModel;

@WebServlet("/filelist")
public class FileListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public FileListServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String folderPath = "C:/Users/86180/git/pdh-java-web/src/main/webapp" + "/webfiles/" + username;
        String requestedPath = request.getParameter("path");

        if (requestedPath != null) {
            folderPath = requestedPath;
        }

        // 设置folderPath为请求的属性
        request.setAttribute("folderPath", folderPath);

        File folder = new File(folderPath);
        List<FileModel> fileList = new ArrayList<>();

        List<FileModel> breadcrumbList = generateBreadcrumbList(requestedPath);
        String currentPath = folderPath;

        request.setAttribute("breadcrumbList", breadcrumbList);
        request.setAttribute("fileList", fileList);
        request.setAttribute("currentPath", currentPath);

        request.getRequestDispatcher("/filelist.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = (String) request.getSession().getAttribute("username");
        String folderPath = "C:/Users/86180/git/pdh-java-web/src/main/webapp" + "/webfiles/" + username;
        String requestedPath = request.getParameter("path");

        if (requestedPath != null) {
            folderPath = URLDecoder.decode(requestedPath, "UTF-8");
        }

        // 设置folderPath为请求的属性
        request.setAttribute("folderPath", folderPath);

        String newFolderName = request.getParameter("newFolderName");
        if (newFolderName != null && !newFolderName.isEmpty()) {
            String newFolderPath = folderPath + "/" + newFolderName;
            File newFolder = new File(newFolderPath);

            if (!newFolder.exists() && newFolder.mkdir()) {
                System.out.println("文件夹创建成功：" + newFolderPath);

                // 文件夹创建成功后重定向到当前页面
                response.sendRedirect(request.getContextPath() + "/filelist?path=" + URLEncoder.encode(folderPath, "UTF-8"));
                return;
            } else {
                System.out.println("文件夹创建失败：" + newFolderPath);

                // 文件夹创建失败后重定向到错误页面
                response.sendRedirect(request.getContextPath() + "/error.jsp");
                return;
            }
        }

        // 重新获取文件列表、面包屑导航等信息
        File folder = new File(folderPath);
        List<FileModel> fileList = new ArrayList<>();

        List<FileModel> breadcrumbList = generateBreadcrumbList(requestedPath);
        String currentPath = folderPath;

        request.setAttribute("breadcrumbList", breadcrumbList);
        request.setAttribute("fileList", fileList);
        request.setAttribute("currentPath", currentPath);

        request.getRequestDispatcher("/filelist.jsp").forward(request, response);
    }


    
    private List<FileModel> generateBreadcrumbList(String requestedPath) {
        List<FileModel> breadcrumbList = new ArrayList<>();
        String[] paths = requestedPath.split("/");

        String currentPath = "";
        for (String path : paths) {
            if (!path.isEmpty()) {
                currentPath += "/" + path;

                FileModel breadcrumb = new FileModel();
                breadcrumb.setName(path);
                breadcrumb.setPath(currentPath);
                breadcrumbList.add(breadcrumb);
            }
        }

        return breadcrumbList;
    }
}
