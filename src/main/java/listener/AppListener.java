package listener;

import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.ServletRequestEvent;
import javax.servlet.ServletRequestListener;
import javax.servlet.annotation.WebListener;

/**
 * 监听器
 */
@WebListener
public class AppListener implements ServletRequestListener, ServletContextListener {
	protected Logger logger;
	
	public AppListener() {
		logger = Logger.getLogger(AppListener.class.getName());
	}

	public void requestDestroyed(ServletRequestEvent sre) {

	}

	public void requestInitialized(ServletRequestEvent sre) {
		ServletContext ctx = sre.getServletContext();
		ctx.setAttribute("req_count", (Integer) (ctx.getAttribute("req_count")) + 1);
		logger.info("[User_HttpRequest_Count] " + ctx.getAttribute("req_count"));
	}

	public void contextDestroyed(ServletContextEvent sce) {
		
	}

	public void contextInitialized(ServletContextEvent sce) {
		logger.info("Web App started");
		sce.getServletContext().setAttribute("req_count", 0);
	}
}
