package j2ee;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import db.Conn; // 导入数据库操作 JavaBean Conn
import model.UserModel;

@WebServlet(urlPatterns = "/j2ee/Hserv")
public class Hserv extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private String username;
	private String pass;
	private String tel;
	private String age;
	private String registration_time;

	Conn cndb = new Conn();

	public void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		username = request.getParameter("username");
		pass = request.getParameter("pass");
		tel = request.getParameter("tel");
		age = request.getParameter("age");
		registration_time = request.getParameter("registration_time");

		response.setContentType("text/html; charset=GB2312");
		PrintWriter out = response.getWriter();
		request.setCharacterEncoding("gb2312");

		// 检查用户名是否已存在
		if (username == null || username.isEmpty()) {
			String encodedErrorMessage = URLEncoder.encode("请输入用户名", "UTF-8");
			response.sendRedirect("register.html?errorMessage=" + encodedErrorMessage);
		} else if (username.length() > 15) {
			String encodedUsername = URLEncoder.encode(username, "UTF-8");
			String encodedErrorMessage = URLEncoder.encode("用户名长度不符合要求", "UTF-8");
			response.sendRedirect("register.html?username=" + encodedUsername + "&errorMessage=" + encodedErrorMessage);
		} else if (checkUsernameExists(username)) {
			String encodedUsername = URLEncoder.encode(username, "UTF-8");
			String encodedErrorMessage = URLEncoder.encode("用户名已存在", "UTF-8");
			response.sendRedirect("register.html?username=" + encodedUsername + "&errorMessage=" + encodedErrorMessage);
		} else if (pass == null || pass.isEmpty() || pass.length() < 6 || pass.length() > 20) {
			String encodedUsername = URLEncoder.encode(username, "UTF-8");
			String encodedErrorMessage = URLEncoder.encode("密码长度不符合要求", "UTF-8");
			response.sendRedirect("register.html?username=" + encodedUsername + "&errorMessage=" + encodedErrorMessage);
		}
		else {
	        String sql = "INSERT INTO Staffs(username, pass, tel, age, registration_time) VALUES (?, ?, ?, ?, ?)";

	        try {
	            try {
	                cndb.connDB();
	            } catch (Exception e) {
	                e.printStackTrace();
	            }

	            PreparedStatement statement = cndb.getPreparedStatement(sql);
	            statement.setString(1, username);
	            statement.setString(2, pass);
	            statement.setString(3, (tel != null && !tel.isEmpty()) ? tel : "未知");
	            statement.setString(4, (age != null && !age.isEmpty()) ? age : "未知");
	            statement.setString(5, registration_time);
	            statement.executeUpdate();

				// 注册成功后，将用户信息保存到会话中
				HttpSession session = request.getSession();
				session.setAttribute("username", username);
				session.setAttribute("password", pass);
				session.setAttribute("tel", tel);
				session.setAttribute("age", age);
				session.setAttribute("registration_time", registration_time);


				sql = "SELECT * FROM Staffs WHERE username = ? AND pass = ?";
				statement = cndb.getPreparedStatement(sql);
				statement.setString(1, username);
				statement.setString(2, pass);
				ResultSet resultSet = statement.executeQuery();

				if (resultSet.next()) {
					String successMessage = "注册成功...";
					request.getSession().setAttribute("SUCCESS_MESSAGE", successMessage);
					String encodedErrorMessage = URLEncoder.encode("恭喜注册成功！", "UTF-8");
					response.sendRedirect("login.html?username=" + URLEncoder.encode(username, "UTF-8") + "&errorMessage=" + encodedErrorMessage);
				}

				cndb.closeDB();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	private boolean checkUsernameExists(String username) {
		// 执行查询操作，检查用户名是否已存在
		String sql = "SELECT * FROM Staffs WHERE username = ?";
		ResultSet resultSet = null;
		try {
			cndb.connDB();
			PreparedStatement statement = cndb.getPreparedStatement(sql);
			statement.setString(1, username);
			resultSet = statement.executeQuery();
			boolean exists = resultSet.next();
			cndb.closeDB();
			return exists;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (resultSet != null) {
				try {
					resultSet.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return false;
	}

	public void init() throws ServletException {
		super.init();
	}
}
