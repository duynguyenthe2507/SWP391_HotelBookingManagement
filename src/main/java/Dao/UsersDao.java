package Dao;

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
                rs.getTimestamp("updatedAt").toLocalDateTime(),
                rs.getString("avatar_url"));
    }

    public List<Users> getFilteredAndSorted(String sortBy, String order, String roleFilter, String statusFilter, String firstNameFilter, String lastNameFilter, String searchKeyword) {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE 1=1 ";

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql = sql + "AND (UPPER(firstName) LIKE UPPER(?) OR UPPER(middleName) LIKE UPPER(?) OR UPPER(lastName) LIKE UPPER(?)) ";
        }
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql = sql + "AND role = ? ";
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql = sql + "AND isActive = ? ";
        }
        if (firstNameFilter != null && !firstNameFilter.isEmpty()) {
            if (firstNameFilter.length() == 1) {
                sql = sql + "AND UPPER(firstName) LIKE UPPER(?) ";
            } else {
                sql = sql + "AND firstName = ? ";
            }
        }
        if (lastNameFilter != null && !lastNameFilter.isEmpty()) {
            if (lastNameFilter.length() == 1) {
                sql = sql + "AND UPPER(lastName) LIKE UPPER(?) ";
            } else {
                sql = sql + "AND lastName = ? ";
            }
        }
        // Default sort: by ID. If order missing, default ASC.
        String sortDirection = (order != null && order.equalsIgnoreCase("desc")) ? "DESC" : "ASC";
        if (sortBy == null || sortBy.isEmpty() || sortBy.equals("id")) {
            sql = sql + "ORDER BY userId " + sortDirection + " ";
        } else if (sortBy.equals("name")) {
            sql = sql + "ORDER BY firstName " + sortDirection + ", lastName " + sortDirection + " ";
        }
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int paramIndex = 1;
            // Set parameter cho search keyword
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                String searchPattern = "%" + searchKeyword.trim() + "%";
                ps.setString(paramIndex++, searchPattern); // firstName
                ps.setString(paramIndex++, searchPattern); // middleName
                ps.setString(paramIndex++, searchPattern); // lastName
            }
            if (roleFilter != null && !roleFilter.isEmpty()) {
                ps.setString(paramIndex++, roleFilter);
            }
            if (statusFilter != null && !statusFilter.isEmpty()) {
                boolean isActive;
                if (statusFilter.equals("active")) {
                    isActive = true;
                } else {
                    isActive = false;
                }
                ps.setBoolean(paramIndex++, isActive);
            }
            if (firstNameFilter != null && !firstNameFilter.isEmpty()) {
                if (firstNameFilter.length() == 1) {
                    ps.setString(paramIndex++, firstNameFilter + "%");
                } else {
                    ps.setString(paramIndex++, firstNameFilter);
                }
            }
            if (lastNameFilter != null && !lastNameFilter.isEmpty()) {
                if (lastNameFilter.length() == 1) {
                    ps.setString(paramIndex++, lastNameFilter + "%");
                } else {
                    ps.setString(paramIndex++, lastNameFilter);
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<String> getDistinctRoles() {
        return Arrays.asList("admin", "user", "receptionist");
    }

    public List<String> getDistinctStatuses() {
        List<String> statuses = new ArrayList<>();
        String sql = "SELECT DISTINCT CASE WHEN isActive = 1 THEN 'active' ELSE 'inactive' END AS status FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                statuses.add("active");
                statuses.add("inactive");
                return statuses;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return statuses;
    }

    public List<String> getDistinctFirstNames() {
        List<String> names = new ArrayList<>();
        String sql = "SELECT DISTINCT firstName FROM Users ORDER BY firstName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                names.add(rs.getString("firstName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public List<String> getDistinctLastNames() {
        List<String> names = new ArrayList<>();
        String sql = "SELECT DISTINCT lastName FROM Users ORDER BY lastName";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                names.add(rs.getString("lastName"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return names;
    }

    public List<Users> getAll() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM Users";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
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
            if (rs.next()) {
                return map(rs);
            }
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
            if (rs.next()) {
                return map(rs);
            }
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
            if (rs.next()) {
                return map(rs);
            }
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
            if (u.getBirthday() != null) {
                ps.setDate(5, Date.valueOf(u.getBirthday()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            ps.setString(6, u.getEmail());
            ps.setString(7, u.getPassword());
            ps.setString(8, u.getRole());
            if (u.getRankId() != null) {
                ps.setInt(9, u.getRankId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
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
        String sql = "UPDATE Users SET mobilePhone=?, firstName=?, middleName=?, lastName=?, birthday=?, email=?, password=?, role=?, rankId=?, isBlackList=?, isActive=?, avatar_url=? WHERE userId=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, u.getMobilePhone());
            ps.setString(2, u.getFirstName());
            ps.setString(3, u.getMiddleName());
            ps.setString(4, u.getLastName());
            if (u.getBirthday() != null) {
                ps.setDate(5, Date.valueOf(u.getBirthday()));
            } else {
                ps.setNull(5, Types.DATE);
            }
            ps.setString(6, u.getEmail());
            ps.setString(7, u.getPassword());
            ps.setString(8, u.getRole());
            if (u.getRankId() != 0) {
                ps.setInt(9, u.getRankId());
            } else {
                ps.setNull(9, Types.INTEGER);
            }
            ps.setBoolean(10, u.isBlackList());
            ps.setBoolean(11, u.isActive());
            ps.setString(12, u.getAvatarUrl());
            ps.setInt(13, u.getUserId());
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
