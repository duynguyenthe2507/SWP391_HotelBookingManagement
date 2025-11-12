package Dao;

import Models.GuestRequest;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class GuestRequestDao {

    // Đổi "GETDATE()" -> "NOW()" nếu dùng MySQL
    private static final String NOW_FN = "GETDATE()";

    // --- Mapper: an toàn với cột tuỳ chọn isSeen/seenAt ---
    private GuestRequest mapRow(ResultSet rs) throws SQLException {
        GuestRequest g = new GuestRequest();
        g.setRequestId(rs.getInt("requestId"));
        g.setBookingId(rs.getInt("bookingId"));
        g.setUserId(rs.getInt("userId"));
        g.setRequestType(rs.getString("requestType"));
        g.setContent(rs.getString("content"));
        g.setStatus(rs.getString("status"));
        g.setReplyText(rs.getString("replyText"));

        int repliedBy = rs.getInt("repliedBy");
        g.setRepliedBy(rs.wasNull() ? null : repliedBy);

        g.setRepliedAt(rs.getTimestamp("repliedAt"));
        g.setCreatedAt(rs.getTimestamp("createdAt"));
        g.setUpdatedAt(rs.getTimestamp("updatedAt"));

        // 2 cột tùy chọn
        try {
            boolean isSeen = rs.getBoolean("isSeen"); // false nếu không tồn tại -> sẽ ném SQLException
            if (!rs.wasNull()) g.setIsSeen(isSeen);
        } catch (SQLException ignore) { /* cột chưa có */ }

        try {
            Timestamp seenAt = rs.getTimestamp("seenAt");
            if (seenAt != null) g.setSeenAt(seenAt);
        } catch (SQLException ignore) { /* cột chưa có */ }

        return g;
    }

    // --- CREATE: trả về id phát sinh ---
    public Integer create(GuestRequest r) throws SQLException {
        String sql = "INSERT INTO GuestRequest (bookingId, userId, requestType, content, status, createdAt, updatedAt) " +
                "VALUES (?,?,?,?, 'pending', " + NOW_FN + ", " + NOW_FN + ")";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getBookingId());
            ps.setInt(2, r.getUserId());
            ps.setString(3, r.getRequestType());
            ps.setString(4, r.getContent());
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return null;
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }

    // --- READ ---
    public GuestRequest findById(int id) throws SQLException {
        String sql = "SELECT * FROM GuestRequest WHERE requestId = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapRow(rs) : null;
            }
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }

    public List<GuestRequest> findByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM GuestRequest WHERE userId=? ORDER BY createdAt DESC";
        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<GuestRequest> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }
    // Lễ tân xem toàn bộ + filter theo status ("all" hoặc rỗng -> không filter)
    public List<GuestRequest> findAll(String status) throws SQLException {
        String base = "SELECT * FROM GuestRequest";
        String order = " ORDER BY createdAt DESC";
        boolean hasFilter = status != null && !status.isEmpty() && !"all".equalsIgnoreCase(status);
        String sql = hasFilter ? base + " WHERE status=? " + order : base + order;

        try (Connection con = new DBContext().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasFilter) ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                List<GuestRequest> list = new ArrayList<>();
                while (rs.next()) list.add(mapRow(rs));
                return list;
            }
        }
    }
    // --- UPDATE: đánh dấu đã xem (khi lễ tân mở chi tiết) ---
    public void markSeen(int requestId, int staffUserId) throws SQLException {
        // Nếu DB CHƯA có cột isSeen/seenAt, câu lệnh này có thể lỗi -> bắt lỗi và bỏ qua
        String sql = "UPDATE GuestRequest " +
                "SET isSeen=1, seenAt=COALESCE(seenAt, " + NOW_FN + "), updatedAt=" + NOW_FN + " " +
                "WHERE requestId=? AND (isSeen=0 OR isSeen IS NULL)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.executeUpdate();
        } catch (SQLException e) {
            // Nếu bảng chưa có cột isSeen/seenAt thì không chặn luồng chính
            // e.g., log.warn("isSeen/seenAt not present", e);
        }
    }

    // --- UPDATE: trả lời ---
    public boolean reply(int requestId, String replyText, int staffUserId) throws SQLException {
        String sql = "UPDATE GuestRequest " +
                "SET replyText=?, repliedBy=?, repliedAt=" + NOW_FN + ", " +
                "    status='replied', updatedAt=" + NOW_FN + " " +
                "WHERE requestId=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, replyText);
            ps.setInt(2, staffUserId);
            ps.setInt(3, requestId);
            int ok = ps.executeUpdate();

            // đánh dấu đã xem nếu có cột
            try { markSeen(requestId, staffUserId); } catch (Exception ignore) {}

            return ok > 0;
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }

    // --- UPDATE: hoàn tất xử lý ---
    public boolean resolve(int requestId, int staffUserId) throws SQLException {
        String sql = "UPDATE GuestRequest " +
                "SET status='resolved', " +
                "    repliedBy=COALESCE(repliedBy, ?), " +
                "    repliedAt=COALESCE(repliedAt, " + NOW_FN + "), " +
                "    updatedAt=" + NOW_FN + " " +
                "WHERE requestId=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, staffUserId);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }
    public boolean cancel(int requestId, int userId) throws SQLException {
        String sql = "UPDATE GuestRequest " +
                "SET status='cancelled', updatedAt=" + NOW_FN + " " +
                "WHERE requestId=? AND userId=? AND status='pending'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            throw new SQLException(e);
        }
    }
    public List<GuestRequest> findAllWithUserInfo(String statusFilter) throws SQLException {
        List<GuestRequest> list = new ArrayList<>();
        String sql = "SELECT gr.*, " +
                "CONCAT(u.firstName, ' ', u.middleName, ' ', u.lastName) as guestName " +
                "FROM GuestRequest gr " +
                "INNER JOIN Users u ON gr.userId = u.userId ";

        if (!"all".equalsIgnoreCase(statusFilter)) {
            sql += "WHERE gr.status = ? ";
        }
        sql += "ORDER BY gr.createdAt DESC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (!"all".equalsIgnoreCase(statusFilter)) {
                ps.setString(1, statusFilter);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GuestRequest gr = new GuestRequest();
                    gr.setRequestId(rs.getInt("requestId"));
                    gr.setBookingId(rs.getInt("bookingId"));
                    gr.setUserId(rs.getInt("userId"));
                    gr.setRequestType(rs.getString("requestType"));
                    gr.setContent(rs.getString("content"));
                    gr.setStatus(rs.getString("status"));
                    gr.setReplyText(rs.getString("replyText"));

                    // Xử lý repliedBy (có thể null)
                    int repliedById = rs.getInt("repliedBy");
                    if (!rs.wasNull()) {
                        gr.setRepliedBy(repliedById);
                    }

                    // Sử dụng Timestamp trực tiếp (không cần convert sang LocalDateTime)
                    gr.setRepliedAt(rs.getTimestamp("repliedAt"));
                    gr.setCreatedAt(rs.getTimestamp("createdAt"));
                    gr.setUpdatedAt(rs.getTimestamp("updatedAt"));

                    // Lưu tên khách (nếu bạn đã thêm field guestName vào GuestRequest model)
                    // gr.setGuestName(rs.getString("guestName"));

                    list.add(gr);
                }
            }
        }
        return list;
    }

    // Thêm method delete
    public boolean delete(int requestId) throws SQLException {
        String sql = "DELETE FROM GuestRequest WHERE requestId = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        }
    }
}