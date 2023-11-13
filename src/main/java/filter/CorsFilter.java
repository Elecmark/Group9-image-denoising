package filter;

import java.io.IOException;
import java.util.logging.Logger;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

/**
 * 跨域请求拦截器
 * 
 *
 */
public class CorsFilter implements Filter {
	protected Logger log;

	public CorsFilter() {
		log = Logger.getLogger(CorsFilter.class.getName());
	}

	public void destroy() {
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		chain.doFilter(request, response);
		log.info("CorsFilter");
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		
		// 全面的跨域配置
		httpResponse.setHeader("Access-Control-Allow-Origin", "*");
		httpResponse.setHeader("Access-Control-Allow-Credentials", "true");
		httpResponse.setHeader("Access-Control-Allow-Methods", "*");
		httpResponse.setHeader("Access-Control-Max-Age", "3600");
		httpResponse.setHeader("Access-Control-Allow-Headers",
				"Authorization,Origin,X-Requested-With,Content-Type,Accept,"
						+ "content-Type,origin,x-requested-with,content-type,accept,authorization,token,id,X-Custom-Header,X-Cookie,Connection,User-Agent,Cookie,*");
		httpResponse.setHeader("Access-Control-Request-Headers",
				"Authorization,Origin, X-Requested-With,content-Type,Accept");
		httpResponse.setHeader("Access-Control-Expose-Headers", "*");
	}

	public void init(FilterConfig fConfig) throws ServletException {
	}

}
