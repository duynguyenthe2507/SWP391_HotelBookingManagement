package Models;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Room implements Serializable {
    private int roomId;
    private String name;
    private int categoryId;
    private Category category;
    private double price;
    private int capacity;
    private String status;
    private String description;
    private String imgUrl; // Cần có
    private LocalDateTime updatedAt; // Cần có

    public Room() {}
    public Room(int roomId, String name, int categoryId, Category category, double price, int capacity, String status, String description, String imgUrl, LocalDateTime updatedAt) {
        this.roomId = roomId;
        this.name = name;
        this.categoryId = categoryId;
        this.category = category;
        this.price = price;
        this.capacity = capacity;
        this.status = status;
        this.description = description;
        this.imgUrl = imgUrl;
        this.updatedAt = updatedAt;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public Category getCategory() { return category; }
    public void setCategory(Category category) { this.category = category; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImgUrl() { return imgUrl; }
    public void setImgUrl(String imgUrl) { this.imgUrl = imgUrl; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Room{" +
               "roomId=" + roomId +
               ", name='" + name + '\'' +
               ", categoryId=" + categoryId +
               ", category=" + (category != null ? category.getName() : "null") +
               ", price=" + price +
               ", capacity=" + capacity +
               ", status='" + status + '\'' +
               ", description='" + description + '\'' +
               ", imgUrl='" + imgUrl + '\'' +
               ", updatedAt=" + updatedAt +
               '}';
    }
}