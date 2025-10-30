package Controller.Receptionist;

import Dao.InvoiceDao;
import Dao.BookingDao;
import Dao.ServiceRequestDao;
import Models.Invoice;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/receptionist/bills")
public class BillController extends HttpServlet {
    
    private final InvoiceDao invoiceDao = new InvoiceDao();
    private final BookingDao bookingDao = new BookingDao();
    private final ServiceRequestDao serviceRequestDao = new ServiceRequestDao();

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
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        try {
            switch (action) {
                case "list":
                    handleListBills(request, response);
                    break;
                case "search":
                    handleSearchBills(request, response);
                    break;
                case "detail":
                    handleBillDetail(request, response);
                    break;
                case "create":
                    handleCreateBillForm(request, response);
                    break;
                case "edit":
                    handleEditBillForm(request, response);
                    break;
                default:
                    handleListBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            request.getRequestDispatcher("/pages/receptionist/bills.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a receptionist
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null || !loggedInUser.getRole().equals("receptionist")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "create":
                    handleCreateBill(request, response);
                    break;
                case "update":
                    handleUpdateBill(request, response);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/receptionist/bills");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while processing your request.");
            doGet(request, response);
        }
    }

    private void handleListBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int size = 5;
        try {
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam));
            if (sizeParam != null) size = Math.max(1, Integer.parseInt(sizeParam));
        } catch (NumberFormatException ignore) { }

        int totalItems = invoiceDao.countAllBills();
        int totalPages = (int) Math.ceil(totalItems / (double) size);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;
        int offset = (page - 1) * size;

        List<Map<String, Object>> bills = invoiceDao.getBillsWithDetailsPaged(offset, size);
        request.setAttribute("bills", bills);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/pages/receptionist/bills.jsp").forward(request, response);
    }

    private void handleSearchBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchTerm = request.getParameter("search");
        int page = 1;
        int size = 5;
        try {
            String pageParam = request.getParameter("page");
            String sizeParam = request.getParameter("size");
            if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam));
            if (sizeParam != null) size = Math.max(1, Integer.parseInt(sizeParam));
        } catch (NumberFormatException ignore) { }

        List<Map<String, Object>> bills;
        int totalItems;
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            String term = searchTerm.trim();
            totalItems = invoiceDao.countBillsBySearch(term);
            int totalPages = (int) Math.ceil(totalItems / (double) size);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;
            int offset = (page - 1) * size;
            bills = invoiceDao.searchBillsPaged(term, offset, size);
            request.setAttribute("searchTerm", term);
            request.setAttribute("totalPages", totalPages);
        } else {
            totalItems = invoiceDao.countAllBills();
            int totalPages = (int) Math.ceil(totalItems / (double) size);
            if (totalPages == 0) totalPages = 1;
            if (page > totalPages) page = totalPages;
            int offset = (page - 1) * size;
            bills = invoiceDao.getBillsWithDetailsPaged(offset, size);
            request.setAttribute("totalPages", totalPages);
        }

        request.setAttribute("bills", bills);
        request.setAttribute("page", page);
        request.setAttribute("size", size);
        request.setAttribute("totalItems", totalItems);
        request.getRequestDispatcher("/pages/receptionist/bills.jsp").forward(request, response);
    }

    private void handleBillDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String invoiceIdParam = request.getParameter("id");
        if (invoiceIdParam == null || invoiceIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Invoice ID is required.");
            handleListBills(request, response);
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            
            // Get detailed bill information
            Map<String, Object> billInfo = invoiceDao.getDetailedBillInfo(invoiceId);
            if (billInfo == null) {
                request.setAttribute("error", "Bill not found.");
                handleListBills(request, response);
                return;
            }
            
            // Get room details
            List<Map<String, Object>> roomDetails = invoiceDao.getBillRoomDetails(invoiceId);
            
            // Get service details
            List<Map<String, Object>> serviceDetails = invoiceDao.getBillServiceDetails(invoiceId);
            
            request.setAttribute("billInfo", billInfo);
            request.setAttribute("roomDetails", roomDetails);
            request.setAttribute("serviceDetails", serviceDetails);
            request.getRequestDispatcher("/pages/receptionist/bill-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid invoice ID format.");
            handleListBills(request, response);
        }
    }

    private void handleCreateBillForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get bookings without invoices
        List<Map<String, Object>> availableBookings = invoiceDao.getBookingsWithoutInvoices();

        // For each booking, get detailed room and service information
        for (Map<String, Object> booking : availableBookings) {
            int bookingId = (Integer) booking.get("bookingId");

            // Get room details
            List<Map<String, Object>> roomDetails = invoiceDao.getBookingRoomDetails(bookingId);
            booking.put("roomDetails", roomDetails);

            // Get service details
            List<Map<String, Object>> serviceDetails = invoiceDao.getBookingServiceDetails(bookingId);
            booking.put("serviceDetails", serviceDetails);

            // Calculate room cost and service cost separately
            double roomCost = roomDetails.stream()
                .mapToDouble(room -> (Double) room.get("priceAtBooking"))
                .sum();
            double serviceCost = serviceDetails.stream()
                .mapToDouble(service -> (Double) service.get("price"))
                .sum();

            booking.put("roomCost", roomCost);
            booking.put("serviceCost", serviceCost);
        }
        request.setAttribute("availableBookings", availableBookings);
        request.getRequestDispatcher("/pages/receptionist/create-bill.jsp").forward(request, response);
    }

    private void handleEditBillForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String invoiceIdParam = request.getParameter("id");
        if (invoiceIdParam == null || invoiceIdParam.trim().isEmpty()) {
            request.setAttribute("error", "Invoice ID is required.");
            handleListBills(request, response);
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            
            // Get detailed bill information
            Map<String, Object> billInfo = invoiceDao.getDetailedBillInfo(invoiceId);
            if (billInfo == null) {
                request.setAttribute("error", "Bill not found.");
                handleListBills(request, response);
                return;
            }
            
            // Get room details
            List<Map<String, Object>> roomDetails = invoiceDao.getBillRoomDetails(invoiceId);
            
            // Get service details
            List<Map<String, Object>> serviceDetails = invoiceDao.getBillServiceDetails(invoiceId);
            
            request.setAttribute("billInfo", billInfo);
            request.setAttribute("roomDetails", roomDetails);
            request.setAttribute("serviceDetails", serviceDetails);
            request.setAttribute("editMode", true);
            request.getRequestDispatcher("/pages/receptionist/bill-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid invoice ID format.");
            handleListBills(request, response);
        }
    }

    private void handleCreateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String bookingIdParam = request.getParameter("bookingId");
        String totalRoomCostParam = request.getParameter("totalRoomCost");
        String totalServiceCostParam = request.getParameter("totalServiceCost");
        String taxAmountParam = request.getParameter("taxAmount");
        String totalAmountParam = request.getParameter("totalAmount");

        // Validate input
        if (bookingIdParam == null || totalRoomCostParam == null ||
            totalServiceCostParam == null || taxAmountParam == null || totalAmountParam == null) {
            request.setAttribute("error", "All fields are required.");
            handleCreateBillForm(request, response);
            return;
        }

        try {
            int bookingId = Integer.parseInt(bookingIdParam);
            double totalRoomCost = Double.parseDouble(totalRoomCostParam);
            double totalServiceCost = Double.parseDouble(totalServiceCostParam);
            double taxAmount = Double.parseDouble(taxAmountParam);
            double totalAmount = Double.parseDouble(totalAmountParam);

            // Create new invoice
            Invoice invoice = new Invoice();
            invoice.setBookingId(bookingId);
            invoice.setTotalRoomCost(totalRoomCost);
            invoice.setTotalServiceCost(totalServiceCost);
            invoice.setTaxAmount(taxAmount);
            invoice.setTotalAmount(totalAmount);

            boolean success = invoiceDao.insert(invoice);

            if (success) {
                request.setAttribute("success", "Bill created successfully.");
                response.sendRedirect(request.getContextPath() + "/receptionist/bills");
            } else {
                request.setAttribute("error", "Failed to create bill.");
                handleCreateBillForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in input fields.");
            handleCreateBillForm(request, response);
        }
    }

    private void handleUpdateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String invoiceIdParam = request.getParameter("invoiceId");
        String totalRoomCostParam = request.getParameter("totalRoomCost");
        String totalServiceCostParam = request.getParameter("totalServiceCost");
        String taxAmountParam = request.getParameter("taxAmount");
        String totalAmountParam = request.getParameter("totalAmount");

        // Validate input
        if (invoiceIdParam == null || totalRoomCostParam == null ||
            totalServiceCostParam == null || taxAmountParam == null || totalAmountParam == null) {
            request.setAttribute("error", "All fields are required.");
            handleEditBillForm(request, response);
            return;
        }

        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            double totalRoomCost = Double.parseDouble(totalRoomCostParam);
            double totalServiceCost = Double.parseDouble(totalServiceCostParam);
            double taxAmount = Double.parseDouble(taxAmountParam);
            double totalAmount = Double.parseDouble(totalAmountParam);

            // Get existing invoice
            Invoice invoice = invoiceDao.getById(invoiceId);
            if (invoice == null) {
                request.setAttribute("error", "Bill not found.");
                handleListBills(request, response);
                return;
            }

            // Update invoice
            invoice.setTotalRoomCost(totalRoomCost);
            invoice.setTotalServiceCost(totalServiceCost);
            invoice.setTaxAmount(taxAmount);
            invoice.setTotalAmount(totalAmount);

            boolean success = invoiceDao.update(invoice);

            if (success) {
                request.setAttribute("success", "Bill updated successfully.");
                response.sendRedirect(request.getContextPath() + "/receptionist/bills?action=detail&id=" + invoiceId);
            } else {
                request.setAttribute("error", "Failed to update bill.");
                handleEditBillForm(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format in input fields.");
            handleEditBillForm(request, response);
        }
    }
}
