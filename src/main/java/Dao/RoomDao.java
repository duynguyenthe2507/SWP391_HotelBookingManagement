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

        StringBuilder sql = new StringBuilder(
                "SELECT r.roomId, r.name as roomName, r.categoryId, r.price, r.capacity, " +
                "r.status, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                "FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE 1=1 "
        );
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
                // Parse dd/MM/yyyy sang LocalDateTime (dùng bởi BookingDao)
                LocalDateTime checkInLDT = LocalDateTime.parse(checkInDate + " 14:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                LocalDateTime checkOutLDT = LocalDateTime.parse(checkOutDate + " 12:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                
                // Sử dụng logic join và kiểm tra overlap giống BookingDao
                sql.append(" AND r.roomId NOT IN (");
                sql.append("   SELECT bd.roomId FROM BookingDetail bd ");
                sql.append("   JOIN Booking b ON bd.bookingId = b.bookingId ");
                sql.append("   WHERE b.status IN ('pending', 'confirmed') ");
                sql.append("   AND (b.checkinTime < ? AND b.checkoutTime > ?)"); // Logic Overlap
                sql.append(")");
                params.add(Timestamp.valueOf(checkOutLDT)); // EndB
                params.add(Timestamp.valueOf(checkInLDT));  // StartB

            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid date format for checkInDate or checkOutDate: " + checkInDate + " - " + checkOutDate, e);
            }
        }

        sql.append(" ORDER BY r.roomId OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((pageNumber - 1) * pageSize);
        params.add(pageSize);

        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng cho hàm đọc
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roomList.add(map(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.findAllRooms()", e);
            e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in findAllRooms", e);
             e.printStackTrace();
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
                LocalDateTime checkInLDT = LocalDateTime.parse(checkInDate + " 14:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
                LocalDateTime checkOutLDT = LocalDateTime.parse(checkOutDate + " 12:00", DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));

                sql.append(" AND r.roomId NOT IN (");
                sql.append("   SELECT bd.roomId FROM BookingDetail bd ");
                sql.append("   JOIN Booking b ON bd.bookingId = b.bookingId ");
                sql.append("   WHERE b.status IN ('pending', 'confirmed') ");
                sql.append("   AND (b.checkinTime < ? AND b.checkoutTime > ?)");
                sql.append(")");
                params.add(Timestamp.valueOf(checkOutLDT));
                params.add(Timestamp.valueOf(checkInLDT));
                
            } catch (DateTimeParseException e) {
                LOGGER.log(Level.WARNING, "Invalid date format in getTotalRoomsCount: " + checkInDate + " - " + checkOutDate, e);
            }
        }

        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.getTotalRoomsCount()", e);
            e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getTotalRoomsCount", e);
             e.printStackTrace();
        }
        return count;
    }

    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT categoryId, name, description, imgUrl, updatedAt FROM Category ORDER BY name";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql);
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
            e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getAllCategories", e);
             e.printStackTrace();
        }
        return categories;
    }

    public Room getById(int id) {
        String sql = "SELECT r.roomId, r.name as roomName, r.categoryId, r.price, r.capacity, " +
                     "r.status, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                     "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                     "FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE r.roomId=?";

        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL Error in RoomDao.getById() for ID: " + id, e);
            e.printStackTrace();
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "General Error in RoomDao.getById() for ID: " + id, e);
             e.printStackTrace();
        }
        return null;
    }

    public List<Room> getAll() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name as roomName, r.categoryId, r.price, r.capacity, " +
                     "r.status, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                     "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                     "FROM Room r JOIN Category c ON r.categoryId = c.categoryId ORDER BY r.roomId";
                     
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in getAll()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getAll", e);
             e.printStackTrace();
        }
        return list;
    }

    public boolean insert(Room r) {
        String sql = "INSERT INTO Room(name, categoryId, price, capacity, status, description, imgUrl) " +
                     "VALUES (?,?,?,?,?,?,?)";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getImgUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in insert()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in insert", e);
             e.printStackTrace();
        }
        return false;
    }

    public boolean update(Room r) {
        String sql = "UPDATE Room SET name=?, categoryId=?, price=?, capacity=?, status=?, description=?, imgUrl=? WHERE roomId=?";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getImgUrl());
            ps.setInt(8, r.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in update()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in update", e);
             e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Room WHERE roomId=?";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in delete()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in delete", e);
             e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, Object>> getRoomsWithCategoryInfo() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, r.imgUrl, " +
                     "c.name as categoryName, c.description as categoryDescription " +
                     "FROM Room r " +
                     "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                     "ORDER BY r.categoryId, r.name";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> roomInfo = new HashMap<>();
                roomInfo.put("roomId", rs.getInt("roomId"));
                roomInfo.put("name", rs.getString("name"));
                roomInfo.put("price", rs.getDouble("price"));
                roomInfo.put("capacity", rs.getInt("capacity"));
                roomInfo.put("status", rs.getString("status"));
                roomInfo.put("description", rs.getString("description"));
                roomInfo.put("imgUrl", rs.getString("imgUrl"));
                roomInfo.put("categoryName", rs.getString("categoryName"));
                roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                list.add(roomInfo);
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in getRoomsWithCategoryInfo()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getRoomsWithCategoryInfo", e);
             e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getRoomsWithCategoryInfoPaged(int offset, int limit) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, r.imgUrl, " +
                     "c.name as categoryName, c.description as categoryDescription " +
                     "FROM Room r " +
                     "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                     "ORDER BY r.categoryId, r.name " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
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
                    roomInfo.put("imgUrl", rs.getString("imgUrl"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in getRoomsWithCategoryInfoPaged()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getRoomsWithCategoryInfoPaged", e);
             e.printStackTrace();
        }
        return list;
    }

    public int countAllRooms() {
        String sql = "SELECT COUNT(*) AS total FROM Room";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in countAllRooms()", e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in countAllRooms", e);
             e.printStackTrace();
        }
        return 0;
    }

    public List<Map<String, Object>> getRoomWithCategoryInfo(int roomId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, r.imgUrl, " +
                     "c.name as categoryName, c.description as categoryDescription " +
                     "FROM Room r " +
                     "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                     "WHERE r.roomId = ?";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
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
                    roomInfo.put("imgUrl", rs.getString("imgUrl"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in getRoomWithCategoryInfo() for room ID: " + roomId, e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getRoomWithCategoryInfo", e);
             e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getRoomsByCategory(String categoryName) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.roomId, r.name, r.price, r.capacity, r.status, r.description, r.imgUrl, " +
                     "c.name as categoryName, c.description as categoryDescription " +
                     "FROM Room r " +
                     "INNER JOIN Category c ON r.categoryId = c.categoryId " +
                     "WHERE c.name = ? " +
                     "ORDER BY r.name";
        try (Connection c = new DBContext().getConnection(); // Tạo connection riêng
             PreparedStatement ps = c.prepareStatement(sql)) {
            
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
                    roomInfo.put("imgUrl", rs.getString("imgUrl"));
                    roomInfo.put("categoryName", rs.getString("categoryName"));
                    roomInfo.put("categoryDescription", rs.getString("categoryDescription"));
                    list.add(roomInfo);
                }
            }
        } catch (SQLException e) { 
            LOGGER.log(Level.SEVERE, "Error in getRoomsByCategory() for category: " + categoryName, e);
            e.printStackTrace(); 
        } catch (Exception e) {
             LOGGER.log(Level.SEVERE, "Error getting connection in getRoomsByCategory", e);
             e.printStackTrace();
        }
        return list;
    }

    public boolean updateRoomStatus(int roomId, String newStatus) {
        String sql = "UPDATE Room SET status = ?, updatedAt = GETDATE() WHERE roomId = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating room status for " + roomId, e);
            return false;
        }
    }

    public List<Room> getAvailableRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, r.name as roomName, r.description as roomDescription, r.imgUrl as roomImgUrl, r.updatedAt as roomUpdatedAt, " +
                "c.name as categoryName, c.description as categoryDescription, c.imgUrl as categoryImgUrl, c.updatedAt as categoryUpdatedAt " +
                "FROM Room r JOIN Category c ON r.categoryId = c.categoryId WHERE r.status = 'available'";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting available rooms", e);
        }
        return list;
    }
    public int createRoom(Room r) {
        final String sql = "INSERT INTO Room(name, categoryId, price, capacity, status, description, imgUrl) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement ps = this.connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getImgUrl()); // LƯU URL ẢNH CLOUDINARY


            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        LOGGER.log(Level.INFO, "createRoom OK, newId={0}", newId);
                        return newId;
                    }
                }
            }
            LOGGER.log(Level.WARNING, "createRoom executed but no key returned");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.createRoom()", e);
        }
        return -1;
    }


    // Update (bao gồm cả imgUrl)
    public void updateRoom(Room r) {
        final String sql = "UPDATE Room SET name=?, categoryId=?, price=?, capacity=?, status=?, description=?, imgUrl=? WHERE roomId=?";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getImgUrl());
            ps.setInt(8, r.getRoomId());
            int affected = ps.executeUpdate();
            LOGGER.log(Level.INFO, "updateRoom affected={0} for roomId={1}", new Object[]{affected, r.getRoomId()});
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in RoomDao.updateRoom() for roomId=" + r.getRoomId(), e);
        }
    }
    public boolean updateWithImage(Room r) {
        String sql = "UPDATE Room SET name=?, categoryId=?, price=?, capacity=?, status=?, description=?, imgUrl=? WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setInt(2, r.getCategoryId());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setString(7, r.getImgUrl());
            ps.setInt(8, r.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
