package listener;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

@WebListener
public class SessionListener implements HttpSessionListener, HttpSessionBindingListener, HttpSessionAttributeListener {

    public SessionListener() {
    }

    public void sessionCreated(HttpSessionEvent se)  { 
    }

    public void valueBound(HttpSessionBindingEvent event)  { 
    }

    public void sessionDestroyed(HttpSessionEvent se)  { 
    }

    public void attributeAdded(HttpSessionBindingEvent se)  { 
    }

    public void attributeRemoved(HttpSessionBindingEvent se)  { 
    	
    }

    public void attributeReplaced(HttpSessionBindingEvent se)  {
    	
    }

    public void valueUnbound(HttpSessionBindingEvent event)  { 

    }
}
