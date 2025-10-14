package Utils;

import Models.Invoice;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.ByteArrayOutputStream;
import java.util.List;
import java.util.Map;

public class PdfGenerator {
    
    private static final Font TITLE_FONT = new Font(Font.FontFamily.HELVETICA, 24, Font.BOLD, BaseColor.BLACK);
    private static final Font HEADER_FONT = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, new BaseColor(223, 169, 116));
    private static final Font SUBHEADER_FONT = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD, BaseColor.BLACK);
    private static final Font NORMAL_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.NORMAL, BaseColor.BLACK);
    private static final Font BOLD_FONT = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.BLACK);
    private static final Font SMALL_FONT = new Font(Font.FontFamily.HELVETICA, 8, Font.NORMAL, BaseColor.GRAY);
    
    public static byte[] generateBillPdf(Map<String, Object> billInfo, 
                                        List<Map<String, Object>> roomDetails,
                                        List<Map<String, Object>> serviceDetails) throws Exception {
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4, 50, 50, 50, 50);
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            document.open();
            
            // Extract invoice from billInfo
            Invoice invoice = (Invoice) billInfo.get("invoice");
            if (invoice == null) {
                throw new IllegalArgumentException("Invoice information is missing");
            }
            
            // Add header
            addHeader(document);
            
            // Add invoice information
            addInvoiceInfo(document, invoice);
            
            // Add customer information
            addCustomerInfo(document, billInfo);
            
            // Add booking details
            addBookingDetails(document, billInfo);
            
            // Add room details table
            if (roomDetails != null && !roomDetails.isEmpty()) {
                addRoomDetailsTable(document, roomDetails);
            }
            
            // Add service details table
            if (serviceDetails != null && !serviceDetails.isEmpty()) {
                addServiceDetailsTable(document, serviceDetails);
            }
            
            // Add bill summary
            addBillSummary(document, invoice);
            
            // Add footer
            addFooter(document);
            
        } finally {
            document.close();
        }
        
        return baos.toByteArray();
    }
    
    private static void addHeader(Document document) throws DocumentException {
        // Company logo and header
        Paragraph header = new Paragraph();
        header.setAlignment(Element.ALIGN_CENTER);
        header.setSpacingAfter(20);
        
        Paragraph companyName = new Paragraph("36 HOTEL", TITLE_FONT);
        companyName.setAlignment(Element.ALIGN_CENTER);
        header.add(companyName);
        
        Paragraph address = new Paragraph("856 Cordia Extension Apt. 356, Lake, United State", NORMAL_FONT);
        address.setAlignment(Element.ALIGN_CENTER);
        header.add(address);
        
        Paragraph contact = new Paragraph("Phone: (12) 345 67890 | Email: info.colorlib@gmail.com", NORMAL_FONT);
        contact.setAlignment(Element.ALIGN_CENTER);
        header.add(contact);
        
        document.add(header);

        // Add line separator
        StringBuilder lineBuilder = new StringBuilder();
        for (int i = 0; i < 80; i++) {
            lineBuilder.append("_");
        }
        Paragraph separator = new Paragraph(lineBuilder.toString());
        separator.getFont().setColor(new BaseColor(223, 169, 116));
        separator.setAlignment(Element.ALIGN_CENTER);
        separator.setSpacingAfter(10);
        document.add(separator);
    }
    
    private static void addInvoiceInfo(Document document, Invoice invoice) throws DocumentException {
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingAfter(20);
        
        // Invoice title
        PdfPCell titleCell = new PdfPCell(new Phrase("INVOICE", HEADER_FONT));
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setHorizontalAlignment(Element.ALIGN_LEFT);
        table.addCell(titleCell);
        
        // Invoice details
        String invoiceDetails = "Invoice #: " + invoice.getInvoiceId() + "\n" +
                               "Date: " + invoice.getIssuedDate().toString();
        
        PdfPCell detailsCell = new PdfPCell(new Phrase(invoiceDetails, NORMAL_FONT));
        detailsCell.setBorder(Rectangle.NO_BORDER);
        detailsCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.addCell(detailsCell);
        
        document.add(table);
    }
    
    private static void addCustomerInfo(Document document, Map<String, Object> billInfo) throws DocumentException {
        Paragraph customerHeader = new Paragraph("BILL TO:", SUBHEADER_FONT);
        customerHeader.setSpacingAfter(10);
        document.add(customerHeader);
        
        String firstName = billInfo.get("firstName") != null ? (String) billInfo.get("firstName") : "";
        String middleName = billInfo.get("middleName") != null ? (String) billInfo.get("middleName") : "";
        String lastName = billInfo.get("lastName") != null ? (String) billInfo.get("lastName") : "";
        String customerName = firstName + " " + (middleName.isEmpty() ? "" : middleName + " ") + lastName;
        
        Paragraph customerInfo = new Paragraph();
        customerInfo.add(new Phrase(customerName, BOLD_FONT));
        customerInfo.add(Chunk.NEWLINE);
        String email = billInfo.get("email") != null ? (String) billInfo.get("email") : "N/A";
        customerInfo.add(new Phrase("Email: " + email, NORMAL_FONT));
        customerInfo.add(Chunk.NEWLINE);
        String phone = billInfo.get("mobilePhone") != null ? (String) billInfo.get("mobilePhone") : "N/A";
        customerInfo.add(new Phrase("Phone: " + phone, NORMAL_FONT));
        customerInfo.setSpacingAfter(15);
        
        document.add(customerInfo);
    }
    
    private static void addBookingDetails(Document document, Map<String, Object> billInfo) throws DocumentException {
        Paragraph bookingHeader = new Paragraph("BOOKING DETAILS:", SUBHEADER_FONT);
        bookingHeader.setSpacingAfter(10);
        document.add(bookingHeader);
        
        Paragraph bookingInfo = new Paragraph();
        if (billInfo.get("checkinTime") != null) {
            bookingInfo.add(new Phrase("Check-in: " + billInfo.get("checkinTime").toString(), NORMAL_FONT));
            bookingInfo.add(Chunk.NEWLINE);
        }
        if (billInfo.get("checkoutTime") != null) {
            bookingInfo.add(new Phrase("Check-out: " + billInfo.get("checkoutTime").toString(), NORMAL_FONT));
            bookingInfo.add(Chunk.NEWLINE);
        }
        if (billInfo.get("durationHours") != null) {
            bookingInfo.add(new Phrase("Duration: " + billInfo.get("durationHours") + " hours", NORMAL_FONT));
        }
        bookingInfo.setSpacingAfter(15);
        
        document.add(bookingInfo);
    }
    
    private static void addRoomDetailsTable(Document document, List<Map<String, Object>> roomDetails) throws DocumentException {
        Paragraph roomHeader = new Paragraph("ROOM DETAILS:", SUBHEADER_FONT);
        roomHeader.setSpacingAfter(10);
        document.add(roomHeader);
        
        PdfPTable table = new PdfPTable(4);
        table.setWidthPercentage(100);
        table.setSpacingAfter(15);
        
        // Set column widths
        float[] columnWidths = {3f, 2f, 1f, 2f};
        table.setWidths(columnWidths);
        
        // Add headers
        addTableHeader(table, "Room");
        addTableHeader(table, "Category");
        addTableHeader(table, "Guests");
        addTableHeader(table, "Price");
        
        // Add data rows
        for (Map<String, Object> room : roomDetails) {
            addTableCell(table, (String) room.get("roomName"));
            addTableCell(table, (String) room.get("categoryName"));
            addTableCell(table, String.valueOf(room.get("guestCount")));
            addTableCell(table, "$" + String.format("%.2f", (Double) room.get("priceAtBooking")));
        }
        
        document.add(table);
    }
    
    private static void addServiceDetailsTable(Document document, List<Map<String, Object>> serviceDetails) throws DocumentException {
        Paragraph serviceHeader = new Paragraph("ADDITIONAL SERVICES:", SUBHEADER_FONT);
        serviceHeader.setSpacingAfter(10);
        document.add(serviceHeader);
        
        PdfPTable table = new PdfPTable(3);
        table.setWidthPercentage(100);
        table.setSpacingAfter(15);
        
        // Set column widths
        float[] columnWidths = {3f, 4f, 2f};
        table.setWidths(columnWidths);
        
        // Add headers
        addTableHeader(table, "Service");
        addTableHeader(table, "Description");
        addTableHeader(table, "Price");
        
        // Add data rows
        for (Map<String, Object> service : serviceDetails) {
            addTableCell(table, (String) service.get("serviceName"));
            addTableCell(table, (String) service.get("description"));
            addTableCell(table, "$" + String.format("%.2f", (Double) service.get("price")));
        }
        
        document.add(table);
    }
    
    private static void addBillSummary(Document document, Invoice invoice) throws DocumentException {
        Paragraph summaryHeader = new Paragraph("BILL SUMMARY:", SUBHEADER_FONT);
        summaryHeader.setSpacingAfter(10);
        document.add(summaryHeader);
        
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(60);
        table.setHorizontalAlignment(Element.ALIGN_RIGHT);
        table.setSpacingAfter(20);
        
        // Add summary rows
        addSummaryRow(table, "Room Cost:", "$" + String.format("%.2f", invoice.getTotalRoomCost()));
        addSummaryRow(table, "Service Cost:", "$" + String.format("%.2f", invoice.getTotalServiceCost()));
        addSummaryRow(table, "Tax Amount:", "$" + String.format("%.2f", invoice.getTaxAmount()));
        
        // Add total row with different styling
        PdfPCell totalLabelCell = new PdfPCell(new Phrase("TOTAL AMOUNT:", BOLD_FONT));
        totalLabelCell.setBorder(Rectangle.TOP);
        totalLabelCell.setBorderWidth(2);
        totalLabelCell.setBorderColor(new BaseColor(223, 169, 116));
        totalLabelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalLabelCell.setPadding(10);
        table.addCell(totalLabelCell);
        
        PdfPCell totalValueCell = new PdfPCell(new Phrase("$" + String.format("%.2f", invoice.getTotalAmount()), BOLD_FONT));
        totalValueCell.setBorder(Rectangle.TOP);
        totalValueCell.setBorderWidth(2);
        totalValueCell.setBorderColor(new BaseColor(223, 169, 116));
        totalValueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        totalValueCell.setPadding(10);
        table.addCell(totalValueCell);
        
        document.add(table);
    }
    
    private static void addFooter(Document document) throws DocumentException {
        // Add signature section
        PdfPTable signatureTable = new PdfPTable(2);
        signatureTable.setWidthPercentage(100);
        signatureTable.setSpacingBefore(30);
        signatureTable.setSpacingAfter(20);
        
        PdfPCell customerSig = new PdfPCell(new Phrase("Customer Signature: ____________________", NORMAL_FONT));
        customerSig.setBorder(Rectangle.NO_BORDER);
        signatureTable.addCell(customerSig);

        PdfPCell receptionistSig = new PdfPCell(new Phrase("Receptionist Signature: ____________________", NORMAL_FONT));
        receptionistSig.setBorder(Rectangle.NO_BORDER);
        signatureTable.addCell(receptionistSig);
        
        document.add(signatureTable);
        
        // Add footer text
        Paragraph footer = new Paragraph();
        footer.setAlignment(Element.ALIGN_CENTER);
        footer.add(new Phrase("Thank you for choosing 36 Hotel!", NORMAL_FONT));
        footer.add(Chunk.NEWLINE);
        footer.add(new Phrase("This is a computer-generated invoice.", SMALL_FONT));
        
        document.add(footer);
    }
    
    private static void addTableHeader(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, BOLD_FONT));
        cell.setBackgroundColor(new BaseColor(248, 249, 250));
        cell.setBorderColor(new BaseColor(223, 169, 116));
        cell.setPadding(8);
        table.addCell(cell);
    }
    
    private static void addTableCell(PdfPTable table, String text) {
        PdfPCell cell = new PdfPCell(new Phrase(text, NORMAL_FONT));
        cell.setBorderColor(BaseColor.LIGHT_GRAY);
        cell.setPadding(8);
        table.addCell(cell);
    }
    
    private static void addSummaryRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, NORMAL_FONT));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        labelCell.setPadding(5);
        table.addCell(labelCell);
        
        PdfPCell valueCell = new PdfPCell(new Phrase(value, BOLD_FONT));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        valueCell.setPadding(5);
        table.addCell(valueCell);
    }
}
