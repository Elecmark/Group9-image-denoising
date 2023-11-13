package user;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletContext;

/**
 * Servlet implementation class LogoutServlet
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
       
    public LogoutServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        if (session != null) {
            String username = (String) session.getAttribute("username");
            
            ServletContext context = request.getServletContext();
            int onlineUserCount = (int) context.getAttribute("onlineUserCount");
            onlineUserCount--;
            
            context.setAttribute("onlineUserCount", onlineUserCount);
            
            session.removeAttribute("username");
        }
        
		request.getSession().invalidate();
		response.getWriter().append("User logout.");
		response.sendRedirect("http://localhost:8080/pdh-java-web/");
    }
}
