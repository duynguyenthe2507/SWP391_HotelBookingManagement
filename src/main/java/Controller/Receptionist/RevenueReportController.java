package Controller.Receptionist;

import Dao.InvoiceDao;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@WebServlet("/receptionist/revenue-report")
public class RevenueReportController extends HttpServlet {
    
    private final InvoiceDao invoiceDao = new InvoiceDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a receptionist
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null || !loggedInUser.getRole().equals("receptionist")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String period = request.getParameter("period");
            if (period == null) period = "month"; // Default to month view
            
            String yearParam = request.getParameter("year");
            String monthParam = request.getParameter("month");
            String startDateParam = request.getParameter("startDate");
            String endDateParam = request.getParameter("endDate");
            
            int currentYear = LocalDate.now().getYear();
            int selectedYear = currentYear;
            if (yearParam != null && !yearParam.trim().isEmpty()) {
                try {
                    selectedYear = Integer.parseInt(yearParam);
                } catch (NumberFormatException e) {
                    selectedYear = currentYear;
                }
            }
            
            // Get total summary
            Map<String, Object> summary = invoiceDao.getTotalRevenueSummary();
            request.setAttribute("summary", summary);
            
            List<Map<String, Object>> revenueData = null;
            List<Map<String, Object>> revenueDetails = null;
            
            switch (period) {
                case "day":
                    // Get revenue by date range
                    Date startDate;
                    Date endDate;
                    
                    if (startDateParam != null && !startDateParam.trim().isEmpty() &&
                        endDateParam != null && !endDateParam.trim().isEmpty()) {
                        try {
                            startDate = Date.valueOf(startDateParam);
                            endDate = Date.valueOf(endDateParam);
                        } catch (IllegalArgumentException e) {
                            // Default to last 30 days
                            endDate = Date.valueOf(LocalDate.now());
                            startDate = Date.valueOf(LocalDate.now().minusDays(30));
                        }
                    } else {
                        // Default to last 30 days
                        endDate = Date.valueOf(LocalDate.now());
                        startDate = Date.valueOf(LocalDate.now().minusDays(30));
                    }
                    
                    revenueData = invoiceDao.getRevenueByDateRange(startDate, endDate);
                    revenueDetails = invoiceDao.getRevenueDetailsByDateRange(startDate, endDate);
                    request.setAttribute("startDate", startDate);
                    request.setAttribute("endDate", endDate);
                    request.setAttribute("periodType", "day");
                    break;
                    
                case "month":
                    // Get revenue by month for selected year
                    revenueData = invoiceDao.getRevenueByMonth(selectedYear);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("periodType", "month");
                    break;
                    
                case "year":
                    // Get revenue by year
                    revenueData = invoiceDao.getRevenueByYear();
                    request.setAttribute("periodType", "year");
                    break;
                    
                default:
                    revenueData = invoiceDao.getRevenueByMonth(selectedYear);
                    request.setAttribute("selectedYear", selectedYear);
                    request.setAttribute("periodType", "month");
                    break;
            }
            
            request.setAttribute("revenueData", revenueData);
            request.setAttribute("revenueDetails", revenueDetails);
            request.setAttribute("period", period);
            request.setAttribute("currentYear", currentYear);
            
            request.getRequestDispatcher("/pages/receptionist/revenue-report.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while loading revenue report: " + e.getMessage());
            request.getRequestDispatcher("/pages/receptionist/revenue-report.jsp").forward(request, response);
        }
    }
}

