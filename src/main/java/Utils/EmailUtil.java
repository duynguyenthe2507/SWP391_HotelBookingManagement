package Utils;

import java.io.InputStream;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailUtil {

    private static final String SMTP_HOST;
    private static final String SMTP_PORT;
    private static final String EMAIL_USERNAME; // email gửi
    private static final String EMAIL_PASSWORD; // app password của email

    static {
        Properties props = new Properties();
        String host = "";
        String port = "";
        String username = "";
        String password = "";

        try (InputStream input = EmailUtil.class.getClassLoader().getResourceAsStream("config.properties")) {
            props.load(input);
            host = props.getProperty("smtp.host");
            port = props.getProperty("smtp.port");
            username = props.getProperty("smtp.username");
            password = props.getProperty("smtp.password");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Cannot load properties");
        }

        SMTP_HOST = host;
        SMTP_PORT = port;
        EMAIL_USERNAME = username;
        EMAIL_PASSWORD = password;
    }

    public static boolean sendOTPEmail(String toEmail, String otp) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Password Reset OTP - Hotel Booking System");

            String htmlContent = buildOTPEmailContent(otp);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private static String buildOTPEmailContent(String otp) {
        return "<!DOCTYPE html>"
                + "<html>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; line-height: 1.6; color: #black; }"
                + ".container { max-width: 600px; margin: 0 auto; padding: 20px; }"
                + ".header { background: white; color: black; padding: 20px; text-align: center; border-radius: 10px 10px 0 0; }"
                + ".content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }"
                + ".otp-box { background: white; padding: 20px; text-align: center; margin: 20px 0; }"
                + ".otp-code { font-size: 32px; font-weight: bold; color: #black; letter-spacing: 5px; }"
                + ".footer { text-align: center; margin-top: 20px; color: #666; font-size: 12px; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='container'>"
                + "<div class='header'>"
                + "<h1>Hotel Booking System</h1>"
                + "<h2>Password Reset OTP</h2>"
                + "</div>"
                + "<div class='content'>"
                + "<p>Hello,</p>"
                + "<p>You have requested to reset your password. Please use the following OTP code to continue:</p>"
                + "<div class='otp-box'>"
                + "<p>Your OTP Code:</p>"
                + "<div class='otp-code'>" + otp + "</div>"
                + "</div>"
                + "<p><strong>Important:</strong></p>"
                + "<ul>"
                + "<li>This OTP code is valid for 10 minutes</li>"
                + "<li>Do not share this code with anyone</li>"
                + "<li>If you did not request a password reset, please ignore this email</li>"
                + "</ul>"
                + "<p>Best regards</p>"
                + "</div>"
                + "<div class='footer'>"
                + "<p>This is an automated email, please do not reply.</p>"
                + "</div>"
                + "</div>"
                + "</body>"
                + "</html>";
    }

    public static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
