package file;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.FileModel;

import com.alibaba.fastjson.JSON;

//@WebServlet("/files")
public class SimpleFileListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public SimpleFileListServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 声明文件上传保存路径
		String username = (String) request.getSession().getAttribute("username");
		String filePath = getServletContext().getRealPath("/") + "/webfiles/" + username; // 拼接上传路径
		File fp = new File(filePath);
		List<File> fileList = Arrays.asList(fp.listFiles());
		List<FileModel> files = new ArrayList<FileModel>(); 
		
		fileList.forEach((item) -> {
			FileModel fileModel = new FileModel();
			fileModel.setName(item.getName());
			fileModel.setPath(item.getPath());
			fileModel.setDir(item.isDirectory());
			files.add(fileModel);
		});
		
		response.setContentType("application/json");
		response.setCharacterEncoding("utf-8");
		PrintWriter out = response.getWriter();
		out.append(JSON.toJSONString(files));
		out.flush();
		out.close();
	}

}
