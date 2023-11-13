package hello;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// 该Servlet在Web.xml中配置
//@WebServlet(description = "Hello Servlet", urlPatterns = { "/hello" })
public class HelloServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Logger logger;
	
	public HelloServlet() {
		super();
		logger = Logger.getGlobal();
	}
	
	public void init(ServletConfig config) {
		logger.info(config.getInitParameter("siteName"));
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String msg = request.getParameter("msg");
		if (msg == null) {
			msg = "你好！";
		}
		
		HttpSession session = request.getSession();
		System.out.println(session.getId());
		
		Cookie cookie01 = new Cookie("USER_ID", "12345");
		cookie01.setMaxAge(5);
		response.addCookie(cookie01);
		
		//session.invalidate(); // LOGOUT
		session.setMaxInactiveInterval(10);
		
		// 取得ServletContext
		// 1 
		//this.getServletContext();
		
		
		
		response.setContentType("text/html");
		response.setCharacterEncoding("utf-8");
		response.getWriter().append(msg);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
	
		
	
	
	
	
	
	

}
