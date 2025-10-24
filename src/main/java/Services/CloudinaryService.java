package Services;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

public class CloudinaryService {
    private Cloudinary cloudinary;

    public CloudinaryService() {
        Properties props = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            props.load(input);
            // Cấu hình Cloudinary từ file properties
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                    "cloud_name", props.getProperty("cloudinary.cloud_name"),
                    "api_key", props.getProperty("cloudinary.api_key"),
                    "api_secret", props.getProperty("cloudinary.api_secret"),
                    "secure", true
            ));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public String uploadFile(Part filePart) {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        try {
            // Chuyển InputStream của file thành byte array
            byte[] fileBytes = filePart.getInputStream().readAllBytes();

            // Tải lên và nhận kết quả
            Map uploadResult = cloudinary.uploader().upload(fileBytes, ObjectUtils.emptyMap());

            // Lấy URL an toàn của ảnh từ kết quả
            return (String) uploadResult.get("secure_url");
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

}
