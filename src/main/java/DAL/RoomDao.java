package DAL;

import Models.Room;
import Utils.DBContext;
import java.sql.*;
import java.util.*;

public class RoomDao extends DBContext {

    private Room map(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("roomId"),
                rs.getString("name"),
                rs.getInt("categoryId"),
                rs.getDouble("price"),
                rs.getInt("capacity"),
                rs.getString("status"),
                rs.getString("description"),
                rs.getTimestamp("updatedAt").toLocalDateTime()
        );
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

    public Room getById(int id) {
        String sql = "SELECT * FROM Room WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
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
