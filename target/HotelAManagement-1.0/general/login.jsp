<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login</title>

    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Roboto", sans-serif;
        background: linear-gradient(135deg, #9acbd0 0%, #006a71 100%);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
      }

      .container {
        display: flex;
        width: 100%;
        max-width: 950px;
        height: 100vh;
        max-height: 700px;
        background: white;
        border-radius: 15px;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        position: relative;
      }

      /* Left Panel - Illustration */
      .left-panel {
        flex: 1;
        background: linear-gradient(135deg, #d84040 0%, #667eea 100%);
        position: relative;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
      }

      .logo {
        position: absolute;
        top: 30px;
        left: 30px;
        color: white;
        font-size: 24px;
        font-weight: bold;
        display: flex;
        align-items: center;
        gap: 15px;
        z-index: 2;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .logo:hover {
        transform: translateY(-2px);
        filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
      }

      .logo img {
        width: 60px;
        height: 60px;
        object-fit: contain;
        filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        transition: transform 0.3s ease;
      }

      .logo:hover img {
        transform: rotate(5deg) scale(1.05);
      }

      .logo span {
        font-size: 32px;
        font-weight: bold;
        letter-spacing: 2px;
        text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
      }

      /* UFO and Scene */
      .scene {
        position: relative;
        width: 100%;
        height: 100%;
      }

      .stars {
        position: absolute;
        width: 100%;
        height: 100%;
      }

      .star {
        position: absolute;
        background: white;
        border-radius: 50%;
        animation: twinkle 2s infinite alternate;
      }

      .star:nth-child(1) {
        width: 2px;
        height: 2px;
        top: 20%;
        left: 20%;
        animation-delay: 0s;
      }
      .star:nth-child(2) {
        width: 1px;
        height: 1px;
        top: 30%;
        left: 80%;
        animation-delay: 0.5s;
      }
      .star:nth-child(3) {
        width: 2px;
        height: 2px;
        top: 60%;
        left: 15%;
        animation-delay: 1s;
      }
      .star:nth-child(4) {
        width: 1px;
        height: 1px;
        top: 80%;
        left: 70%;
        animation-delay: 1.5s;
      }
      .star:nth-child(5) {
        width: 3px;
        height: 3px;
        top: 15%;
        left: 60%;
        animation-delay: 0.8s;
      }

      .ufo {
        position: absolute;
        top: 25%;
        left: 50%;
        transform: translateX(-50%);
        animation: float 3s ease-in-out infinite;
      }

      .ufo-body {
        width: 120px;
        height: 40px;
        background: linear-gradient(135deg, #a78bfa 0%, #8b5cf6 100%);
        border-radius: 50px;
        position: relative;
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
      }

      .ufo-dome {
        width: 60px;
        height: 30px;
        background: linear-gradient(135deg, #c4b5fd 0%, #a78bfa 100%);
        border-radius: 30px 30px 0 0;
        position: absolute;
        top: -15px;
        left: 50%;
        transform: translateX(-50%);
      }

      .ufo-lights {
        position: absolute;
        bottom: -5px;
        left: 50%;
        transform: translateX(-50%);
        display: flex;
        gap: 10px;
      }

      .ufo-light {
        width: 8px;
        height: 8px;
        background: #10f6f6;
        border-radius: 50%;
        animation: blink 1s infinite alternate;
      }

      .ufo-light:nth-child(2) {
        animation-delay: 0.3s;
      }
      .ufo-light:nth-child(3) {
        animation-delay: 0.6s;
      }

      .beam {
        position: absolute;
        top: 100%;
        left: 50%;
        transform: translateX(-50%);
        width: 0;
        height: 0;
        border-left: 60px solid transparent;
        border-right: 60px solid transparent;
        border-top: 100px solid rgba(16, 246, 246, 0.3);
        animation: beamPulse 2s ease-in-out infinite;
      }

      /* Houses */
      .houses {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        height: 200px;
      }

      .house {
        position: absolute;
        bottom: 0;
      }

      .house1 {
        left: 10%;
        width: 80px;
        height: 100px;
        background: #3b4cca;
        clip-path: polygon(0 100%, 0 40%, 50% 0, 100% 40%, 100% 100%);
      }

      .house2 {
        left: 25%;
        width: 60px;
        height: 80px;
        background: #4c51bf;
        clip-path: polygon(0 100%, 0 30%, 50% 0, 100% 30%, 100% 100%);
      }

      .house3 {
        right: 20%;
        width: 90px;
        height: 120px;
        background: #5a67d8;
        clip-path: polygon(0 100%, 0 35%, 50% 0, 100% 35%, 100% 100%);
      }

      /* Trees */
      .tree {
        position: absolute;
        bottom: 0;
        width: 20px;
        height: 40px;
        background: #10b981;
        border-radius: 50% 50% 50% 50% / 60% 60% 40% 40%;
      }

      .tree:nth-child(1) {
        left: 5%;
      }
      .tree:nth-child(2) {
        left: 45%;
      }
      .tree:nth-child(3) {
        right: 10%;
      }
      .tree:nth-child(4) {
        right: 35%;
      }

      /* Right Panel - Form */
      .right-panel {
        flex: 1;
        padding: 60px 50px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        background: white;
        position: relative;
      }

      .signin-header {
        margin-bottom: 40px;
        text-align: center;
      }

      .signin-title {
        font-size: 32px;
        font-weight: 700;
        color: #1a202c;
        margin-bottom: 8px;
      }

      .signin-subtitle {
        color: #718096;
        font-size: 16px;
      }

      .signin-form {
        width: 100%;
        max-width: 380px;
        margin: 0 auto;
      }
      .form-row {
        display: flex;
      }
      .form-group {
        margin-bottom: 24px;
      }

      .form-label {
        display: block;
        margin-bottom: 8px;
        color: #4a5568;
        font-weight: 500;
        font-size: 14px;
      }

      .form-input {
        width: 100%;
        padding: 14px 16px;
        border: 2px solid #e2e8f0;
        border-radius: 10px;
        font-size: 16px;
        transition: all 0.3s ease;
        outline: none;
        background: #fafafa;
      }

      .form-input:focus {
        border-color: #4c51bf;
        box-shadow: 0 0 0 3px rgba(76, 81, 191, 0.1);
        background: white;
        transform: translateY(-1px);
      }

      .forgot-password-group {
        display: flex;
        justify-content: flex-end;
        margin-bottom: 32px;
      }

      .forgot-password-link {
        color: #ffacac;
        text-decoration: none;
        font-size: 14px;
        font-weight: 500;
        transition: color 0.3s ease;
      }

      .forgot-password-link:hover {
        color: #059669;
        text-decoration: underline;
      }

      .signin-btn {
        width: 100%;
        padding: 16px;
        background: linear-gradient(135deg, #ffacac 0%, #ffbfa9 100%);
        color: white;
        border: none;
        border-radius: 10px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-bottom: 32px;
        box-shadow: 0 4px 12px rgba(16, 185, 129, 0.2);
      }

      .signin-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(16, 185, 129, 0.3);
      }

      .signin-btn:active {
        transform: translateY(0);
      }

      .signup-link-group {
        text-align: center;
        margin-bottom: 32px;
      }

      .signup-link {
        color: #718096;
        text-decoration: none;
        font-size: 14px;
      }

      .signup-link strong {
        color: #ffacac;
        font-weight: 600;
      }

      .signup-link:hover strong {
        color: #059669;
      }

      .show-password {
        display: flex;
        margin-right: 150px;
      }

      .forgot-password-link {
        text-align: center;
        margin-top: 15px;
      }

      .forgot-link {
        color: #666;
        text-decoration: none;
        font-size: 14px;
      }

      .forgot-link:hover {
        color: #667eea;
        text-decoration: underline;
      }

      .error-message {
        background: #fed7d7;
        color: #c53030;
        padding: 12px 16px;
        border-radius: 8px;
        font-size: 14px;
        margin-bottom: 24px;
        text-align: center;
        border: 1px solid #feb2b2;
        animation: shake 0.5s ease-in-out;
        box-shadow: 0 2px 4px rgba(197, 48, 48, 0.1);
      }

      @keyframes shake {
        0%,
        100% {
          transform: translateX(0);
        }
        25% {
          transform: translateX(-5px);
        }
        75% {
          transform: translateX(5px);
        }
      }

      .footer-links {
        display: flex;
        justify-content: center;
        gap: 24px;
        margin-top: 20px;
      }

      .footer-links a {
        color: #a0aec0;
        text-decoration: none;
        font-size: 12px;
        transition: color 0.3s ease;
      }

      .footer-links a:hover {
        color: #4c51bf;
      }

      .decorative-elements {
        position: absolute;
        top: 0;
        right: 0;
        width: 200px;
        height: 200px;
        background: linear-gradient(135deg, #10b981, #06d6a0);
        opacity: 0.08;
        clip-path: polygon(100% 0, 0 0, 100% 100%);
      }

      /* Animations */
      @keyframes float {
        0%,
        100% {
          transform: translateX(-50%) translateY(0px);
        }
        50% {
          transform: translateX(-50%) translateY(-10px);
        }
      }

      @keyframes twinkle {
        0% {
          opacity: 0.3;
        }
        100% {
          opacity: 1;
        }
      }

      @keyframes blink {
        0% {
          opacity: 1;
        }
        100% {
          opacity: 0.3;
        }
      }

      @keyframes beamPulse {
        0%,
        100% {
          opacity: 0.3;
        }
        50% {
          opacity: 0.6;
        }
      }

      /* Responsive */
      @media (max-width: 768px) {
        .container {
          flex-direction: column;
          height: auto;
          min-height: 100vh;
          max-height: none;
        }

        .left-panel {
          height: 250px;
          flex: none;
        }

        .right-panel {
          padding: 40px 24px;
        }

        .signin-form {
          max-width: 100%;
        }

        .signin-title {
          font-size: 28px;
        }
      }

      @media (max-width: 480px) {
        .right-panel {
          padding: 30px 20px;
        }

        .signin-title {
          font-size: 24px;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <!-- Left Panel with Illustration -->
      <div class="left-panel">
        <div class="scene">
          <div class="stars">
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
            <div class="star"></div>
          </div>

          <div class="ufo">
            <div class="ufo-dome"></div>
            <div class="ufo-body">
              <div class="ufo-lights">
                <div class="ufo-light"></div>
                <div class="ufo-light"></div>
                <div class="ufo-light"></div>
              </div>
            </div>
            <div class="beam"></div>
          </div>

          <div class="houses">
            <div class="house house1"></div>
            <div class="house house2"></div>
            <div class="house house3"></div>
            <div class="tree"></div>
            <div class="tree"></div>
            <div class="tree"></div>
            <div class="tree"></div>
          </div>
        </div>
      </div>

      <!-- Right Panel with Signin Form -->
      <div class="right-panel">
        <div class="decorative-elements"></div>

        <div class="signin-header">
          <h1 class="signin-title">Sign In</h1>
          <p class="signin-subtitle">Welcome back!</p>
        </div>

        <form action="login" method="post" class="signin-form">
          <div class="form-group">
            <label for="phone" class="form-label">Phone number</label>
            <input
              type="text"
              id="phone"
              name="phone"
              class="form-input"
              required
              placeholder="Enter your phone number"
              pattern="^\d{9,11}$"
              title="Phone number must have 9-11 numbers and must starts with 0"
              value="${phone}"
            />
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Mật khẩu</label>
            <input
              type="password"
              id="password"
              name="password"
              class="form-input"
              required
              placeholder="Enter your password"
              pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$"
              title="Password must contain at least 8 characters, including word and number"
            />
            <div class="form-check mt-2">
              <input
                type="checkbox"
                class="form-check-input"
                id="showPassword"
                onchange="togglePassword()"
              />
              <label
                class="form-check-label"
                for="showPassword"
                style="font-size: 14px; color: #666"
              >
                Show password
              </label>
            </div>
          </div>
          <div class="form-row"></div>

          <% if (request.getAttribute("error") != null) { %>
          <div class="error-message" style="display: block">
            <%= request.getAttribute("error") %>
          </div>
          <% } %>

          <button type="submit" class="signin-btn" value="Login">
            Sign In
          </button>
        </form>

        <div class="signup-link-group">
          <a
            href="${pageContext.request.contextPath}/register"
            class="signup-link"
          >
            Not a member yet? <strong>Sign up now</strong>
          </a>
        </div>

        <div class="forgot-password-link">
          <a href="forgot-password" class="forgot-link"
            >Forgot your password?</a
          >
        </div>

        <div class="footer-links">
          <a href="#">Term</a>
          <a href="#">Policy</a>
          <a href="#">Support</a>
        </div>
      </div>
    </div>

    <script>
      function togglePassword() {
        const passwordInput = document.getElementById("password");
        const showPasswordCheckbox = document.getElementById("showPassword");

        if (showPasswordCheckbox.checked) {
          passwordInput.type = "text";
        } else {
          passwordInput.type = "password";
        }
      }
    </script>
  </body>
</html>
