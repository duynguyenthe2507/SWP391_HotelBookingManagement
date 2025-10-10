<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Up</title>

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
        padding: 20px;
      }

      .container {
        display: flex;
        width: 100%;
        max-width: 1100px;
        height: auto;
        min-height: 700px;
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
        min-height: 700px;
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
        width: 48px;
        height: 48px;
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
        padding: 30px 40px;
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        background: white;
        position: relative;
        overflow-y: auto;
        max-height: 100vh;
      }

      .signup-header {
        margin-bottom: 20px;
        text-align: center;
      }

      .signup-title {
        font-size: 24px;
        font-weight: 600;
        color: #1a202c;
        margin-bottom: 8px;
      }

      .signup-subtitle {
        color: #718096;
        font-size: 14px;
      }

      .form-group {
        margin-bottom: 12px;
      }

      .form-label {
        display: block;
        margin-bottom: 5px;
        color: #4a5568;
        font-weight: 500;
        font-size: 13px;
      }

      .form-input {
        width: 100%;
        padding: 10px 12px;
        border: 2px solid #e2e8f0;
        border-radius: 6px;
        font-size: 14px;
        transition: all 0.3s ease;
        outline: none;
      }

      .form-input:focus {
        border-color: #4c51bf;
        box-shadow: 0 0 0 3px rgba(76, 81, 191, 0.1);
      }

      .form-row {
        display: flex;
        gap: 12px;
      }

      .form-row .form-group {
        flex: 1;
      }

      .form-radio-group {
        display: flex;
        gap: 20px;
        margin-top: 5px;
      }

      .form-radio-group label {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: #4a5568;
        cursor: pointer;
      }

      .form-radio-group input[type="radio"] {
        width: 16px;
        height: 16px;
        accent-color: #4c51bf;
      }

      .checkbox-group {
        display: flex;
        align-items: flex-start;
        gap: 10px;
        margin-bottom: 15px;
      }

      .checkbox {
        width: 16px;
        height: 16px;
        accent-color: #4c51bf;
        margin-top: 2px;
        flex-shrink: 0;
      }

      .checkbox-label {
        color: #4a5568;
        font-size: 12px;
        line-height: 1.4;
      }

      .checkbox-label a {
        color: #ffacac;
        text-decoration: none;
      }

      .checkbox-label a:hover {
        text-decoration: underline;
      }

      .signup-btn {
        width: 100%;
        padding: 12px;
        background: linear-gradient(135deg, #ffbfa9 0%, #ffacac 100%);
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        margin-bottom: 15px;
      }

      .signup-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(255, 172, 172, 0.3);
      }

      .signin-link {
        text-align: center;
        color: #ffacac;
        text-decoration: none;
        font-size: 13px;
        margin-bottom: 15px;
        display: block;
      }

      .signin-link:hover {
        text-decoration: underline;
        color: #ff9a9a;
      }

      .decorative-elements {
        position: absolute;
        top: 0;
        right: 0;
        width: 150px;
        height: 150px;
        background: linear-gradient(135deg, #ffbfa9, #ffacac);
        opacity: 0.1;
        clip-path: polygon(100% 0, 0 0, 100% 100%);
      }

      /* Error and Success Messages */
      .alert {
        padding: 10px 12px;
        border-radius: 6px;
        margin-bottom: 12px;
        font-size: 13px;
        text-align: center;
      }

      .alert-error {
        background-color: #fed7d7;
        color: #e53e3e;
        border: 1px solid #feb2b2;
        animation: shake 0.5s ease-in-out;
        box-shadow: 0 2px 4px rgba(229, 62, 62, 0.1);
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

      .alert-success {
        background-color: #c6f6d5;
        color: #2f855a;
        border: 1px solid #9ae6b4;
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
        body {
          padding: 10px;
        }

        .container {
          flex-direction: column;
          height: auto;
          min-height: auto;
          max-width: 100%;
        }

        .left-panel {
          height: 250px;
          flex: none;
          min-height: auto;
        }

        .right-panel {
          padding: 20px;
          max-height: none;
        }

        .form-row {
          flex-direction: column;
          gap: 0;
        }

        .logo span {
          font-size: 24px;
        }

        .signup-title {
          font-size: 20px;
        }
      }

      @media (max-width: 480px) {
        .right-panel {
          padding: 15px;
        }

        .logo {
          top: 20px;
          left: 20px;
          gap: 10px;
        }

        .logo img {
          width: 36px;
          height: 36px;
        }

        .logo span {
          font-size: 20px;
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

      <!-- Right Panel with Signup Form -->
      <div class="right-panel">
        <div class="decorative-elements"></div>

        <div class="signup-header">
          <h1 class="signup-title">Sign Up</h1>
        </div>

        <form action="register" method="post">
          <div class="form-row">
            <div class="form-group">
              <label for="firstName" class="form-label">First Name</label>
              <input
                type="text"
                id="firstName"
                name="firstName"
                class="form-input"
                required
                pattern="^[a-zA-ZÀ-ỹ\s]{2,50}$"
                title="First name 2-50 characters, just word and space"
                value="${firstName != null ? firstName : param.firstName}"
              />
            </div>
            <div class="form-group">
              <label for="middleName" class="form-label">Middle Name</label>
              <input
                type="text"
                id="middleName"
                name="middleName"
                class="form-input"
                pattern="^[a-zA-ZÀ-ỹ\s]{0,50}$"
                title="Middle name (50 characters maximum)"
                value="${middleName != null ? middleName : param.middleName}"
              />
            </div>
          </div>

          <div class="form-row">
            <div class="form-group">
              <label for="lastName" class="form-label">Last Name</label>
              <input
                type="text"
                id="lastName"
                name="lastName"
                class="form-input"
                required
                pattern="^[a-zA-ZÀ-ỹ\s]{2,50}$"
                title="Last name 2-50 characters, just word and space"
                value="${lastName != null ? lastName : param.lastName}"
              />
            </div>
            <div class="form-group">
              <label for="phone" class="form-label">Mobile Phone</label>
              <input
                type="text"
                class="form-input"
                id="phone"
                name="phone"
                placeholder="Enter phone number"
                required
                pattern="^0\d{9,10}$"
                title="Phone number must starts with 0 and have 10-11 numbers"
                value="${phone != null ? phone : param.phone}"
              />
            </div>
          </div>

          <div class="form-group">
            <label for="email" class="form-label">Email</label>
            <input
              type="email"
              id="email"
              name="email"
              class="form-input"
              required
              pattern="[a-zA-Z0-9._%25+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
              title="Email is invalid"
              value="${email != null ? email : param.email}"
            />
          </div>

          <div class="form-group">
            <label for="password" class="form-label">Password</label>
            <input
              type="password"
              id="password"
              name="password"
              class="form-input"
              required
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

          <div class="form-group">
            <label for="dob" class="form-label">Birthday</label>
            <input
              type="date"
              id="dob"
              name="dob"
              class="form-input"
              required
              value="${dob != null ? dob : param.dob}"
            />
          </div>

          <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-error" style="display: block">
            <%= request.getAttribute("error") %>
          </div>
          <% } %>

          <button type="submit" class="signup-btn">Sign Up</button>
        </form>

        <a href="${pageContext.request.contextPath}/login" class="signin-link"
          >Already a member?</a
        >
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
