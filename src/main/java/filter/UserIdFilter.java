package filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebFilter;

/**
 * 过滤器
 */
@WebFilter(urlPatterns = {"/index.jsp", "/fileslist.jsp", "/welcome.jsp", "/upload.html", "/userDetail.jsp"})
public class UserIdFilter implements Filter {

	public UserIdFilter() {
	}

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		
		if (httpRequest.getSession().getAttribute("USER_INFO") == null) {
			httpResponse.sendRedirect("login.html");
		} else {
			chain.doFilter(request, response);
			System.out.println(httpResponse.getStatus());
		}
	}

	public void init(FilterConfig fConfig) throws ServletException {

	}

}
