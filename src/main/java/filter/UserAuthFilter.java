package filter;

import java.io.IOException;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.ServletResponse;
import model.UserModel;

public class UserAuthFilter implements Filter {
	protected Logger log;

	public UserAuthFilter() {
		log = Logger.getLogger(UserAuthFilter.class.getName());
	}

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		log.info("UserAuthFilter Request");
		HttpServletRequest httpRequest = (HttpServletRequest) request;
		UserModel userModel = (UserModel) httpRequest.getSession().getAttribute("USER_INFO");
		String role = userModel.getRole();
		
		if (!role.equals("admin")) {
			httpRequest.getRequestDispatcher("../unauth.html").forward(request, response);
		}
		
		chain.doFilter(request, response);
		
		log.info("UserAuthFilter Response");
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}

}
