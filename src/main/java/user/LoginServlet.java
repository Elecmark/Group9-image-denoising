package user;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.Set;
import java.util.HashSet;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.UserModel;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		response.setContentType("text/html");

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		String msg;

		// 数据库连接信息
		String url = "jdbc:mysql://localhost:3306/testdb";
		String dbUsername = "root";
		String dbPassword = "214588Pdh";

		try {
			// 加载MySQL JDBC驱动程序
			Class.forName("com.mysql.cj.jdbc.Driver");

			// 建立数据库连接
			Connection connection = DriverManager.getConnection(url, dbUsername, dbPassword);

			// 创建SQL查询语句
			String sql = "SELECT * FROM Staffs WHERE username = ? AND pass = ?";

			// 创建PreparedStatement对象，并设置参数
			PreparedStatement statement = connection.prepareStatement(sql);
			statement.setString(1, username);
			statement.setString(2, password);

			// 执行查询
			ResultSet resultSet = statement.executeQuery();

			if (resultSet.next()) {
				msg = "登录成功";
				System.out.printf(System.getProperty("user.dir"));

				//头像
				String[] imageExtensions = { ".png", ".jpg", ".jpeg", ".ico" };
				String defaultAvatarPath = "/profile_picture/0123456789default.png";

				String avatarUrl = null;
				for (String extension : imageExtensions) {
					String imagePath = "C:/Users/86180/git/pdh-java-web/src/main/webapp/profile_picture/" + username + extension;
					File imageFile = new File(imagePath);
					if (imageFile.exists()) {
						avatarUrl = "/profile_picture/" + username + extension;
						break;
					}
				}

				if (avatarUrl == null) {
					avatarUrl = defaultAvatarPath;
				}

				UserModel userModel = new UserModel();
				userModel.setUsername(username);
				userModel.setPassword(password);
				userModel.setTelephone(resultSet.getString("tel")); // 根据实际数据库字段名称进行调整
				userModel.setAge(resultSet.getString("age")); // 根据实际数据库字段名称进行调整
				userModel.setRegistrationTime(resultSet.getString("registration_time"));
				userModel.setRole("user");
				userModel.setAvatarUrl(request.getContextPath() + avatarUrl);

				// 将用户模型对象存储在会话中
				request.getSession().setAttribute("USER_INFO", userModel);


				// 创建用户文件夹
				String uploadPath = "C:/Users/86180/git/pdh-java-web/src/main/webapp" + "/webfiles/" + username;
				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists()) {
					uploadDir.mkdirs(); // 如果路径不存在，则创建目录
				}
				String folderPath = uploadPath;
				request.getSession().setAttribute("folderPath", folderPath);
				// 获取当前会话
				HttpSession session = request.getSession(true);

				// 将用户名存储在会话中
				session.setAttribute("username", username);

				// 获取ServletContext对象
				ServletContext context = request.getServletContext();

				// 获取在线用户数量
				Integer onlineUserCount = (Integer) context.getAttribute("onlineUserCount");

				// 如果在线用户数量为null，则初始化为0
				if (onlineUserCount == null || onlineUserCount <= 0) {
					onlineUserCount = 0;
				}

				// 获取在线用户集合
				HashSet<String> onlineUsers = (HashSet<String>) context.getAttribute("onlineUsers");

				// 如果在线用户集合为null，则初始化一个空集合
				if (onlineUsers == null) {
					onlineUsers = new HashSet<String>();
					context.setAttribute("onlineUsers", onlineUsers);
				}

				// 用户未登录，进行登录处理

				// 将用户名添加到在线用户集合
				onlineUsers.add(username);

				// 获取在线用户数量
				onlineUserCount = (Integer) context.getAttribute("onlineUserCount");

				// 如果在线用户数量为null，则初始化为0
				if (onlineUserCount == null || onlineUserCount <= 0) {
					onlineUserCount = 0;
				}

				// 递增在线用户数量
				onlineUserCount++;

				// 将递增后的在线用户数量存储到ServletContext中
				context.setAttribute("onlineUserCount", onlineUserCount);

				request.setAttribute("LOGIN_MESSAGE", "success"); // 登录成功
				response.setHeader("Refresh", "0; URL=welcome.jsp");
			} else {
				msg = "登录失败";
				request.setAttribute("LOGIN_MESSAGE", "error"); // 登录失败
				String errorMessage = URLEncoder.encode("用户名或密码错误", "UTF-8");
				response.sendRedirect("login.html?username=" + URLEncoder.encode(username, "UTF-8") + "&errorMessage=" + errorMessage);
			}

			// 关闭连接和资源
			resultSet.close();
			statement.close();
			connection.close();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			msg = "登录失败";
			request.setAttribute("LOGIN_MESSAGE", "error"); // 登录失败
			String errorMessage = URLEncoder.encode("无法加载驱动程序", "UTF-8");
			response.sendRedirect("login.html?errorMessage=" + errorMessage);
		} catch (SQLException e) {
			e.printStackTrace();
			msg = "登录失败";
			request.setAttribute("LOGIN_MESSAGE", "error"); // 登录失败
			String errorMessage = URLEncoder.encode("数据库错误", "UTF-8");
			response.sendRedirect("login.html?errorMessage=" + errorMessage);
		}
	}
}