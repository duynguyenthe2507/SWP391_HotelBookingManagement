package Services;

import Utils.EmailUtil;

public class EmailService {

    public boolean sendOTPEmail(String toEmail, String otp) {
        try {
            return EmailUtil.sendOTPEmail(toEmail, otp);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendSubscriptionEmail(String toEmail) {
        try {
            String subject = "Thank you for subscribing to 36 Hotel!";
            String htmlContent = "<h1>Welcome to 36 Hotel!</h1>"
                    + "<p>You have successfully subscribed to our newsletter.</p>"
                    + "<p>You will be the first to know about our latest updates and exclusive offers.</p>"
                    + "<p>Best regards,<br>36 Hotel Team</p>";

            return EmailUtil.sendEmail(toEmail, subject, htmlContent);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}