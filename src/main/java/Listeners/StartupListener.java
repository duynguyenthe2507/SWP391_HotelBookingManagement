package Listeners;

import Services.BookingCleanupService;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class StartupListener implements ServletContextListener {
    
    private static final Logger LOGGER = Logger.getLogger(StartupListener.class.getName());
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("🚀 Application starting...");
        
        // Khởi động cleanup service
        BookingCleanupService.getInstance().start();
        
        LOGGER.info("✅ Application started successfully");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("🛑 Application shutting down...");
        
        // Dừng cleanup service
        BookingCleanupService.getInstance().stop();
        
        LOGGER.info("✅ Application stopped");
    }
}