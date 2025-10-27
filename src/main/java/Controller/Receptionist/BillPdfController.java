package Controller.Receptionist;

import Dao.InvoiceDao;
import Models.Users;
import Utils.PdfGenerator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.Map;

@WebServlet("/receptionist/bills/export-pdf")
public class BillPdfController extends HttpServlet {
    
    private final InvoiceDao invoiceDao = new InvoiceDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Check if user is logged in and is a receptionist
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("loggedInUser");
        
        if (loggedInUser == null || !loggedInUser.getRole().equals("receptionist")) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Access denied");
            return;
        }
        
        String invoiceIdParam = request.getParameter("id");
        if (invoiceIdParam == null || invoiceIdParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invoice ID is required");
            return;
        }
        
        try {
            int invoiceId = Integer.parseInt(invoiceIdParam);
            
            // Get detailed bill information
            Map<String, Object> billInfo = invoiceDao.getDetailedBillInfo(invoiceId);
            if (billInfo == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill not found");
                return;
            }
            
            // Get room details
            List<Map<String, Object>> roomDetails = invoiceDao.getBillRoomDetails(invoiceId);
            
            // Get service details
            List<Map<String, Object>> serviceDetails = invoiceDao.getBillServiceDetails(invoiceId);
            
            // Generate PDF using PdfGenerator utility
            byte[] pdfBytes = PdfGenerator.generateBillPdf(billInfo, roomDetails, serviceDetails);
            
            // Set response headers for PDF download
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=\"Invoice_" + invoiceId + ".pdf\"");
            response.setContentLength(pdfBytes.length);
            
            // Write PDF to response
            try (OutputStream out = response.getOutputStream()) {
                out.write(pdfBytes);
                out.flush();
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid invoice ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error generating PDF: " + e.getMessage());
        }
    }


}
