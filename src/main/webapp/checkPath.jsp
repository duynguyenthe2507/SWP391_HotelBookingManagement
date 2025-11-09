<%@ page import="java.io.File" %>
<html>
<body>
<h2>Đường dẫn thư mục 'work' của Tomcat:</h2>
<pre>
<%
    // SỬA LỖI:
    // Thay vì gọi getServletContext()
    // Hãy dùng biến ngầm định "application" (chính là ServletContext)

    File workDir = (File) application.getAttribute("jakarta.servlet.context.tempdir");

    // In đường dẫn
    if (workDir != null) {
        out.println(workDir.getAbsolutePath());
    } else {
        out.println("Không thể tìm thấy thư mục 'work' (tempdir).");
    }
%>
</pre>
</body>
</html>