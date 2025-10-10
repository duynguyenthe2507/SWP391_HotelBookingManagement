package DAL;

import Models.Users;
import Utils.DBContext;
import java.sql.*;
import java.sql.Date;
import java.util.*;

public class UsersDao extends DBContext {

    private Users map(ResultSet rs) throws SQLException {
        return new Users(
                rs.getInt("userId"),
                rs.getString("mobilePhone"),
                rs.getString("firstName"),
                rs.getString("middleName"),
                rs.getString("lastName"),
                rs.getDate("birthday") != null ? rs.getDate("birthday").toLocalDate() : null,
                rs.getString("email"),
                rs.getString("password"),
                rs.getString("role"),
                rs.getInt("rankId"),
                rs.getBoolean("isBlackList"),
                rs.getBoolean("isActive"),
                rs.getTimestamp("createdAt").toLocalDateTime(),
                rs.getTimestamp("updatedAt").toLocalDateTime());
    }

    public List<Users> getAll() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next())
                list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Users getById(int id) {
        String sql = "SELECT * FROM Users WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users getByMobilePhone(String mobilePhone) {
        String sql = "SELECT * FROM Users WHERE mobilePhone=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, mobilePhone);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Users getByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return map(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Users u) {
        String sql = "INSERT INTO Users(mobilePhone, firstName, middleName, lastName, birthday, email, password, role, rankId) VALUES (?,?,?,?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getMobilePhone());
            ps.setString(2, u.getFirstName());
            ps.setString(3, u.getMiddleName() == null ? "" : u.getMiddleName());
            ps.setString(4, u.getLastName());
            if (u.getBirthday() != null)
                ps.setDate(5, Date.valueOf(u.getBirthday()));
            else
                ps.setNull(5, Types.DATE);
            ps.setString(6, u.getEmail());
            ps.setString(7, u.getPassword());
            ps.setString(8, u.getRole());
            if (u.getRankId() != null)
                ps.setInt(9, u.getRankId());
            else
                ps.setNull(9, Types.INTEGER);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Integer getDefaultRankId() {
        String sql = "SELECT TOP 1 rankId FROM Rank WHERE minBookings = 0 ORDER BY rankId";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(Users u) {
        String sql = "UPDATE Users SET mobilePhone=?, firstName=?, middleName=?, lastName=?, birthday=?, email=?, password=?, role=?, rankId=?, isBlackList=?, isActive=? WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getMobilePhone());
            ps.setString(2, u.getFirstName());
            ps.setString(3, u.getMiddleName());
            ps.setString(4, u.getLastName());
            if (u.getBirthday() != null)
                ps.setDate(5, Date.valueOf(u.getBirthday()));
            else
                ps.setNull(5, Types.DATE);
            ps.setString(6, u.getEmail());
            ps.setString(7, u.getPassword());
            ps.setString(8, u.getRole());
            if (u.getRankId() != 0)
                ps.setInt(9, u.getRankId());
            else
                ps.setNull(9, Types.INTEGER);
            ps.setBoolean(10, u.isBlackList());
            ps.setBoolean(11, u.isActive());
            ps.setInt(12, u.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Users WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
