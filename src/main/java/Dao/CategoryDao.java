package DAL;

import Models.Category;
import Utils.DBContext;
import java.sql.*;
import java.time.LocalDateTime; // Cần import LocalDateTime
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger; 

public class CategoryDao extends DBContext {

    private static final Logger LOGGER = Logger.getLogger(CategoryDao.class.getName()); 
    public CategoryDao() {
        super(); 
    }

    private Category map(ResultSet rs) throws SQLException {
        Category category = new Category(); 

        category.setCategoryId(rs.getInt("categoryId"));
        category.setName(rs.getString("name"));
        category.setDescription(rs.getString("description"));
        category.setImgUrl(rs.getString("imgUrl")); 

        Timestamp updatedAtTimestamp = rs.getTimestamp("updatedAt");
        category.setUpdatedAt(updatedAtTimestamp != null ? updatedAtTimestamp.toLocalDateTime() : null);

        return category;
    }

    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT categoryId, name, description, imgUrl, updatedAt FROM Category ORDER BY name";
        try (PreparedStatement ps = this.connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryDao.getAll()", e);
        }
        return list;
    }

    public Category getById(int id) {
        String sql = "SELECT categoryId, name, description, imgUrl, updatedAt FROM Category WHERE categoryId=?";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) { // Sử dụng this.connection
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryDao.getById()", e);
        }
        return null;
    }

    public boolean insert(Category c) {
        String sql = "INSERT INTO Category(name, description, imgUrl) VALUES (?,?,?)";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) { 
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getImgUrl()); 
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryDao.insert()", e);
        }
        return false;
    }

    public boolean update(Category c) {
        String sql = "UPDATE Category SET name=?, description=?, imgUrl=? WHERE categoryId=?";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) { 
            ps.setString(1, c.getName());
            ps.setString(2, c.getDescription());
            ps.setString(3, c.getImgUrl()); 
            ps.setInt(4, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryDao.update()", e);
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM Category WHERE categoryId=?";
        try (PreparedStatement ps = this.connection.prepareStatement(sql)) { 
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in CategoryDao.delete()", e);
        }
        return false;
    }
}