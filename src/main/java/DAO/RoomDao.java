package DAO;

import Models.Room;
import java.sql.*;
import java.util.*;

public class RoomDao extends DBContext {

    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        return new Room(
                rs.getInt("roomId"),
                rs.getString("name"),
                rs.getString("type"),
                rs.getDouble("price"),
                rs.getInt("capacity"),
                rs.getString("status"),
                rs.getString("description")
        );
    }

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapResultSetToRoom(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Room getRoomById(int id) {
        String sql = "SELECT * FROM Room WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToRoom(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addRoom(Room r) {
        String sql = "INSERT INTO Room(name, type, price, capacity, status, description) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getType());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateRoom(Room r) {
        String sql = "UPDATE Room SET name=?, type=?, price=?, capacity=?, status=?, description=? WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, r.getName());
            ps.setString(2, r.getType());
            ps.setDouble(3, r.getPrice());
            ps.setInt(4, r.getCapacity());
            ps.setString(5, r.getStatus());
            ps.setString(6, r.getDescription());
            ps.setInt(7, r.getRoomId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteRoom(int id) {
        String sql = "DELETE FROM Room WHERE roomId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
