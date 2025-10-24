package Dao;

import Models.Category;
import Models.Room;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter; 
import java.time.format.DateTimeParseException; 
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RoomDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(RoomDao.class.getName());
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public RoomDao() {
        super();
    }

    private Room map(ResultSet rs) throws SQLException {
        Room room = new Room();

        room.setRoomId(rs.getInt("roomId"));
        room.setName(rs.getString("roomName")); 
        room.setCategoryId(rs.getInt("categoryId"));
        room.setPrice(rs.getDouble("price"));
        room.setCapacity(rs.getInt("capacity"));
        room.setStatus(rs.getString("status"));
        room.setDescription(rs.getString("roomDescription")); 
        room.setImgUrl(rs.getString("roomImgUrl")); 

        Timestamp updatedAtTimestamp = rs.getTimestamp("roomUpdatedAt"); 
        room.setUpdatedAt(updatedAtTimestamp != null ? updatedAtTimestamp.toLocalDateTime() : null);

        Category category = new Category();
        category.setCategoryId(rs.getInt("categoryId"));    
        category.setName(rs.getString("categoryName"));
        category.setDescription(rs.getString("categoryDescription"));
        category.setImgUrl(rs.getString("categoryImgUrl"));
        
        Timestamp categoryUpdatedAtTimestamp = rs.getTimestamp("categoryUpdatedAt");
        category.setUpdatedAt(categoryUpdatedAtTimestamp != null ? categoryUpdatedAtTimestamp.toLocalDateTime() : null);

        room.setCategory(category);

        return room;
    }

    public List<Room> findAllRooms(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice, 
                                   Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter,
                                   int pageNumber, int pageSize) {
        List<Room> roomList = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("SELECT r.roomId, r.name as roomName, r.categoryId, r.price, r.capacity, " +
                                              "r.status, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                                              "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                                              "FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND r.name LIKE ? ");
            params.add("%" + searchKeyword + "%");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND r.categoryId = ? ");
            params.add(categoryId);
        }
        if (minPrice != null && minPrice >= 0) { 
            sql.append(" AND r.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice >= 0) { 
            sql.append(" AND r.price <= ? ");
            params.add(maxPrice);
        }
        if (minCapacity != null && minCapacity > 0) {
            sql.append(" AND r.capacity >= ? ");
            params.add(minCapacity);
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND r.status = ? ");
            params.add(statusFilter);
        }

        if (checkInDate != null && !checkInDate.trim().isEmpty() &&
            checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            
            try {
                java.sql.Date sqlCheckInDate = java.sql.Date.valueOf(
                    LocalDateTime.parse(checkInDate + " 00:00:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")).toLocalDate()
                );
                java.sql.Date sqlCheckOutDate = java.sql.Date.valueOf(
                    LocalDateTime.parse(checkOutDate + " 00:00:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")).toLocalDate()
                );
                sql.append(" AND r.roomId NOT IN (SELECT b.roomId FROM Booking b WHERE ");
                sql.append(" (b.checkInDate < ? AND b.checkOutDate > ?)");
                sql.append(")");
                params.add(sqlCheckOutDate); 
                params.add(sqlCheckInDate); 
                
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid date format for checkInDate or checkOutDate: " + checkInDate + " - " + checkOutDate, e);
                
            }
        }

        sql.append(" ORDER BY r.roomId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((pageNumber - 1) * pageSize);
        params.add(pageSize);

        LOGGER.log(Level.INFO, "Executing SQL for findAllRooms: {0} with params: {1}", new Object[]{sql.toString(), params});

        try (PreparedStatement ps = this.connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roomList.add(map(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.findAllRooms() for SQL: " + sql.toString() + " with params: " + params, e);
        }
        return roomList;
    }

    public int getTotalRoomsCount(String searchKeyword, Integer categoryId, Double minPrice, Double maxPrice, 
                                  Integer minCapacity, String checkInDate, String checkOutDate, String statusFilter) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        int count = 0;

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" AND r.name LIKE ? ");
            params.add("%" + searchKeyword + "%");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND r.categoryId = ? ");
            params.add(categoryId);
        }
        if (minPrice != null && minPrice >= 0) {
            sql.append(" AND r.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null && maxPrice >= 0) {
            sql.append(" AND r.price <= ? ");
            params.add(maxPrice);
        }
        if (minCapacity != null && minCapacity > 0) {
            sql.append(" AND r.capacity >= ? ");
            params.add(minCapacity);
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            sql.append(" AND r.status = ? ");
            params.add(statusFilter);
        }
        if (checkInDate != null && !checkInDate.trim().isEmpty() &&
            checkOutDate != null && !checkOutDate.trim().isEmpty()) {
            
            try {
                java.sql.Date sqlCheckInDate = java.sql.Date.valueOf(
                    LocalDateTime.parse(checkInDate + " 00:00:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")).toLocalDate()
                );
                java.sql.Date sqlCheckOutDate = java.sql.Date.valueOf(
                    LocalDateTime.parse(checkOutDate + " 00:00:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")).toLocalDate()
                );

                sql.append(" AND r.roomId NOT IN (SELECT b.roomId FROM Booking b WHERE ");
                sql.append(" (b.checkInDate < ? AND b.checkOutDate > ?)");
                sql.append(")");
                params.add(sqlCheckOutDate);
                params.add(sqlCheckInDate);
                
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid date format for checkInDate or checkOutDate in getTotalRoomsCount: " + checkInDate + " - " + checkOutDate, e);
            }
        }
        // KẾT THÚC LOGIC LỌC THEO NGÀY
        
        LOGGER.log(Level.INFO, "Executing SQL for getTotalRoomsCount: {0} with params: {1}", new Object[]{sql.toString(), params});

        try (PreparedStatement ps = this.connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.getTotalRoomsCount() for SQL: " + sql.toString() + " with params: " + params, e);
        }
        return count;
    }
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT categoryId, name, description, imgUrl, updatedAt FROM Category ORDER BY name";
        try (PreparedStatement ps = this.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Category category = new Category();
                category.setCategoryId(rs.getInt("categoryId"));
                category.setName(rs.getString("name"));
                category.setDescription(rs.getString("description"));
                category.setImgUrl(rs.getString("imgUrl"));
                Timestamp updatedAtTimestamp = rs.getTimestamp("updatedAt");
                category.setUpdatedAt(updatedAtTimestamp != null ? updatedAtTimestamp.toLocalDateTime() : null);
                categories.add(category);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.getAllCategories()", e);
        }
        return categories;
    }

    public Room getById(int id) {
        String sql = "SELECT r.roomId, r.name as roomName, r.categoryId, r.price, r.capacity, " +
                     "r.status, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                     "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                     "FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE r.roomId=?";    
        
        LOGGER.log(Level.INFO, "Executing SQL for Room ID: {0}, SQL: {1}", new Object[]{id, sql}); 
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LOGGER.log(Level.INFO, "Room with ID {0} found. Mapping data...", id);
                    return map(rs);    
                } else {
                    LOGGER.log(Level.WARNING, "No room found with ID: {0}", id);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error in RoomDao.getById() for ID: " + id, e); 
        } catch (Exception e) { 
            LOGGER.log(Level.SEVERE, "General Error (likely in map method) in RoomDao.getById() for ID: " + id, e);
        }
        return null;    
    }

    public List<Room> getAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean insert(Room r) {
        String sql = "INSERT INTO Room(name, categoryId, price, capacity, status, description) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean update(Room r) {
        String sql = "UPDATE Room SET name=?, categoryId=?, price=?, capacity=?, status=?, description=? WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setInt(7, r.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Room WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Method to get rooms with category information for receptionist view
    public List<Map<String, Object>> getRoomsWithCategoryInfo() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, " +
                "c.name as categoryName, c.description as categoryDescription " +
                "FROM Room r " +
                "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                "ORDER BY r.categoryId, r.name";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> roomInfo = new HashMap<>();
                roomInfo.put("roomId", rs.getInt("roomId"));
                roomInfo.put("name", rs.getString("name"));
                roomInfo.put("price", rs.getDouble("price"));
                roomInfo.put("capacity", rs.getInt("capacity"));
                roomInfo.put("status", rs.getString("status"));
                roomInfo.put("description", rs.getString("description"));
                roomInfo.put("categoryName", rs.getString("categoryName"));
                roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                list.add(roomInfo);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Paginated method to get rooms with category information
    public List<Map<String, Object>> getRoomsWithCategoryInfoPaged(int offset, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, " +
                "c.name as categoryName, c.description as categoryDescription " +
                "FROM Room r " +
                "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                "ORDER BY r.categoryId, r.name " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, Math.max(0, offset));
            ps.setInt(2, Math.max(1, limit));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> roomInfo = new HashMap<>();
                    roomInfo.put("roomId", rs.getInt("roomId"));
                    roomInfo.put("name", rs.getString("name"));
                    roomInfo.put("price", rs.getDouble("price"));
                    roomInfo.put("capacity", rs.getInt("capacity"));
                    roomInfo.put("status", rs.getString("status"));
                    roomInfo.put("description", rs.getString("description"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Total count for pagination
    public int countAllRooms() {
        String sql = "SELECT COUNT(*) AS total FROM Room";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Method to get single room with category information for detail view
    public List<Map<String, Object>> getRoomWithCategoryInfo(int roomId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, " +
                "c.name as categoryName, c.description as categoryDescription " +
                "FROM Room r " +
                "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                "WHERE r.roomId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> roomInfo = new HashMap<>();
                    roomInfo.put("roomId", rs.getInt("roomId"));
                    roomInfo.put("name", rs.getString("name"));
                    roomInfo.put("price", rs.getDouble("price"));
                    roomInfo.put("capacity", rs.getInt("capacity"));
                    roomInfo.put("status", rs.getString("status"));
                    roomInfo.put("description", rs.getString("description"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // Method to get rooms by category for similar rooms
    public List<Map<String, Object>> getRoomsByCategory(String categoryName) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, " +
                "c.name as categoryName, c.description as categoryDescription " +
                "FROM Room r " +
                "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                "WHERE c.name = ? " +
                "ORDER BY r.name";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, categoryName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> roomInfo = new HashMap<>();
                    roomInfo.put("roomId", rs.getInt("roomId"));
                    roomInfo.put("name", rs.getString("name"));
                    roomInfo.put("price", rs.getDouble("price"));
                    roomInfo.put("capacity", rs.getInt("capacity"));
                    roomInfo.put("status", rs.getString("status"));
                    roomInfo.put("description", rs.getString("description"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
