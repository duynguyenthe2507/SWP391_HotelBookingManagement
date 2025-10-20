package Dao;

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
}
