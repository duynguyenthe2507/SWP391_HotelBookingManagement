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
}
