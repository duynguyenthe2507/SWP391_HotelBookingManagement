package Utils;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());
    public Connection connection;
    private boolean isConnectionManagedExternally = false;

    // Constructor mặc định: Tạo kết nối mới
    public DBContext() {
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            Properties props = new Properties();
            if (input == null) {
                LOGGER.log(Level.SEVERE, "!!! CRITICAL: config.properties not found in classpath. Cannot connect to database. !!!");
                throw new RuntimeException("CRITICAL: config.properties not found in classpath.");
            }
            props.load(input);

            String url = props.getProperty("db.url");
            String user = props.getProperty("db.username");
            String pass = props.getProperty("db.password");

            if (url == null || user == null || pass == null || url.trim().isEmpty()) {
                 LOGGER.log(Level.SEVERE, "!!! CRITICAL: Database connection properties (url, username, password) are missing or empty in config.properties. !!!");
                 throw new RuntimeException("CRITICAL: Database connection properties missing in config.properties.");
            }

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
            isConnectionManagedExternally = false;
            // LOGGER.log(Level.INFO, "New database connection established successfully from config.properties.");

        } catch (ClassNotFoundException ex) {
             LOGGER.log(Level.SEVERE, "!!! CRITICAL: SQL Server JDBC Driver not found. Ensure the driver JAR is in the classpath. !!!", ex);
             throw new RuntimeException("CRITICAL: SQL Server JDBC Driver not found.", ex);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "!!! CRITICAL: Failed to establish database connection. Check URL, username, password, and DB status. !!!", ex);
            LOGGER.log(Level.SEVERE, "SQL Error Code: {0}", ex.getErrorCode());
            LOGGER.log(Level.SEVERE, "SQL State: {0}", ex.getSQLState());
            throw new RuntimeException("CRITICAL: Failed to establish database connection.", ex);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "!!! CRITICAL: An unexpected error occurred during DBContext initialization. !!!", ex);
            throw new RuntimeException("CRITICAL: Unexpected error during DBContext initialization.", ex);
        }
    }

    // Constructor nhận kết nối đã tồn tại (cho transaction)
    public DBContext(Connection existingConnection) {
        if (existingConnection == null) {
            LOGGER.log(Level.SEVERE, "!!! Attempted to initialize DBContext with a NULL existing connection. !!!");
            throw new IllegalArgumentException("Existing connection cannot be null when passed to DBContext constructor.");
        }
        this.connection = existingConnection;
        this.isConnectionManagedExternally = true;
        // LOGGER.log(Level.INFO, "DBContext initialized with an existing external connection.");
    }

    public Connection getConnection() {
        return connection;
    }

    public boolean isConnected() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error checking connection status", ex);
            return false;
        }
    }

    public boolean isConnectionManagedExternally() {
        return this.isConnectionManagedExternally;
    }

    public void closeConnection() {
        if (!isConnectionManagedExternally && connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                }
            } catch (SQLException ex) {
                LOGGER.log(Level.SEVERE, "Error closing internally managed database connection", ex);
            }
        }
    }

    public static void main(String[] args) {
        DBContext db = null;
        try {
            db = new DBContext();
            System.out.println(db.isConnected() ? "Kết nối thành công!" : "Thất bại!");
        } catch (RuntimeException e) {
            System.err.println("Lỗi kết nối database: " + e.getMessage());
        } finally {
            if (db != null) {
                db.closeConnection();
                 System.out.println("Đã đóng kết nối.");
            }
        }
    }
}

