<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Reset Password</title>
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

      .password-requirements {
        background-color: #f8f9fa;
        padding: 15px;
        border-radius: 8px;
        margin-bottom: 20px;
        font-size: 12px;
        color: #666;
      }

      .password-requirements ul {
        margin: 0;
        padding-left: 20px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="header">
        <h1 class="title">Reset Password</h1>
        <p class="subtitle">Enter your new password</p>
      </div>

      <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %> <% if (request.getAttribute("success") != null) { %>
      <div class="alert alert-success">
        <%= request.getAttribute("success") %>
      </div>
      <% } %>

      <div class="password-requirements">
        <strong>Password Requirements:</strong>
        <ul>
          <li>At least 8 characters long</li>
          <li>Must contain letters and numbers</li>
        </ul>
      </div>

      <form method="post" action="reset-password">
        <div class="form-group">
          <label for="newPassword" class="form-label">New Password</label>
          <div style="position: relative">
            <input
              type="password"
              id="newPassword"
              name="newPassword"
              class="form-input"
              required
              placeholder="Enter new password"
              pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$"
              title="Password must contain at least 8 characters, including letters and numbers"
            />
            <button
              type="button"
              onclick="togglePassword('newPassword', 'toggleNewPassword')"
              style="
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                color: #666;
                font-size: 14px;
              "
              id="toggleNewPassword"
            >
              Show
            </button>
          </div>
        </div>

        <div class="form-group">
          <label for="confirmPassword" class="form-label"
            >Confirm Password</label
          >
          <div style="position: relative">
            <input
              type="password"
              id="confirmPassword"
              name="confirmPassword"
              class="form-input"
              required
              placeholder="Confirm new password"
            />
            <button
              type="button"
              onclick="togglePassword('confirmPassword', 'toggleConfirmPassword')"
              style="
                position: absolute;
                right: 10px;
                top: 50%;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                color: #666;
                font-size: 14px;
              "
              id="toggleConfirmPassword"
            >
              Show
            </button>
          </div>
        </div>

        <button type="submit" class="btn">Reset Password</button>
      </form>

      <div class="back-link">
        <a href="forgot-password">Back to Forgot Password</a>
      </div>
    </div>

    <script>
      function togglePassword(inputId, buttonId) {
        const passwordInput = document.getElementById(inputId);
        const toggleButton = document.getElementById(buttonId);

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          toggleButton.textContent = "Hide";
        } else {
          passwordInput.type = "password";
          toggleButton.textContent = "Show";
        }
      }
    </script>
  </body>
</html>
