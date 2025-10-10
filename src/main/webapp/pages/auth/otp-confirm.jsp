<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>OTP Confirmation</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
      }

      .container {
        background: white;
        padding: 40px;
        border-radius: 10px;
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
        width: 100%;
        max-width: 400px;
      }

      .header {
        text-align: center;
        margin-bottom: 30px;
      }

      .title {
        color: #333;
        font-size: 28px;
        font-weight: 600;
        margin-bottom: 10px;
      }

      .subtitle {
        color: #666;
        font-size: 14px;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-label {
        display: block;
        margin-bottom: 8px;
        color: #333;
        font-weight: 500;
        font-size: 14px;
      }

      .form-input {
        width: 100%;
        padding: 12px 15px;
        border: 2px solid #e1e5e9;
        border-radius: 8px;
        font-size: 16px;
        transition: border-color 0.3s ease;
        text-align: center;
        letter-spacing: 2px;
      }

      .form-input:focus {
        outline: none;
        border-color: #667eea;
      }

      .btn {
        width: 100%;
        padding: 12px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: transform 0.2s ease;
      }

      .btn:hover {
        transform: translateY(-2px);
      }

      .back-link {
        text-align: center;
        margin-top: 20px;
      }

      .back-link a {
        color: #667eea;
        text-decoration: none;
        font-size: 14px;
      }

      .back-link a:hover {
        text-decoration: underline;
      }

      .alert {
        padding: 12px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 14px;
      }

      .alert-danger {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }

      .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }

      .otp-info {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        text-align: center;
        font-size: 14px;
        color: #666;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h1 class="title">OTP Confirmation</h1>
        <p class="subtitle">Enter the 6-digit code sent to your email</p>
      </div>

      <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %> <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">
        <%= request.getAttribute("success") %>
      </div>
      <% } %>

      <div class="otp-info">
        <strong>Note:</strong> Please check your email for the OTP code.
      </div>

      <form method="post" action="otp-confirm">
        <div class="form-group">
          <label for="otp" class="form-label">Enter OTP Code</label>
          <input
            type="text"
            id="otp"
            name="otp"
            class="form-input"
            required
            placeholder="000000"
            maxlength="6"
            pattern="[0-9]{6}"
            title="Please enter 6 digits"
          />
        </div>

        <button type="submit" class="btn">Verify OTP</button>
      </form>

      <div class="back-link">
        <a href="forgot-password">Back to Forgot Password</a>
      </div>
    </div>
  </body>
</html>
