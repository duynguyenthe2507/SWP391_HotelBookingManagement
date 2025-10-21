package Models; 

import java.io.Serializable;
import java.time.LocalDateTime;

public class Category implements Serializable {
    private int categoryId;
    private String name;
    private String description;
    private String imgUrl; 
    private LocalDateTime updatedAt; 

    public Category() {}

    public Category(int categoryId, String name, String description, String imgUrl, LocalDateTime updatedAt) { // <-- SỬA ĐỔI Ở ĐÂY
        this.categoryId = categoryId;
        this.name = name;
        this.description = description;
        this.imgUrl = imgUrl; 
        this.updatedAt = updatedAt;
    }

    public Category(int categoryId, String name, String description, LocalDateTime updatedAt) {
        this(categoryId, name, description, null, updatedAt); 
    }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImgUrl() { return imgUrl; } 
    public void setImgUrl(String imgUrl) { this.imgUrl = imgUrl; } 

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Category{" +
               "categoryId=" + categoryId +
               ", name='" + name + '\'' +
               ", description='" + description + '\'' +
               ", imgUrl='" + imgUrl + '\'' +
               ", updatedAt=" + updatedAt +
               '}';
    }
}