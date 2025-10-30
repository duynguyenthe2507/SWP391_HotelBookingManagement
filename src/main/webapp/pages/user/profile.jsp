<%-- Include Header --%>
<jsp:include page="/common/header.jsp" />
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Profile Settings</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0-alpha1/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/bootstrap.min.css"
      type="text/css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/font-awesome.min.css"
      type="text/css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
      type="text/css"
    />
    <style>
      body {
        background: #fff;
      }

      .form-control:focus {
        box-shadow: none;
        border-color: rgb(255, 153, 0);
      }

      .profile-button {
        display: inline-block;
        font-size: 13px;
        font-weight: 700;
        padding: 16px 28px 15px;
        background: #dfa974;
        color: #ffffff;
        text-transform: uppercase;
        letter-spacing: 2px;
      }
      .back:hover {
        color: rgb(255, 153, 0);
        cursor: pointer;
      }

      .labels {
        font-size: 11px;
      }

      .add-experience:hover {
        background: rgb(255, 153, 0);
        color: #fff;
        cursor: pointer;
        border: solid 1px rgb(255, 153, 0);
      }

      .alert {
        margin-bottom: 20px;
      }

      .avatar-img {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 50%;
      }
    </style>
  </head>
  <body>
    <div class="container rounded bg-white mt-5 mb-5">
      <div class="row">
        <div class="col-md-3 border-right">
          <div
            class="d-flex flex-column align-items-center text-center p-3 py-5"
          >
            <img
              src="${user.avatarUrl != null ? user.avatarUrl : pageContext.request.contextPath.concat('/img/room/avatar/default-avatar.png')}"
              alt="Avatar"
              class="avatar-img"
            />
            <span class="font-weight-bold"
              >${user.firstName} ${user.middleName} ${user.lastName}</span
            >
            <span class="text-black-50">${user.email}</span>
            <span class="text-black-50">Rank: ${rankName}</span>
          </div>
        </div>
        <div class="col-md-9">
          <div class="p-3 py-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h4 class="text-right">Profile Settings</h4>
              <a href="home" class="btn profile-button">Back to Home</a>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" style="display: block">
              <%= request.getAttribute("error") %>
            </div>
            <% } %> <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success" style="display: block">
              <%= request.getAttribute("success") %>
            </div>
            <% } %>

            <form method="post" action="profile" enctype="multipart/form-data">
              <input type="hidden" name="action" value="update" />

              <div class="row mt-2">
                <div class="col-md-4">
                  <label class="labels">First Name</label>
                  <input
                    type="text"
                    class="form-control"
                    name="firstName"
                    value="${user.firstName}"
                    required
                  />
                </div>
                <div class="col-md-4">
                  <label class="labels">Middle Name</label>
                  <input
                    type="text"
                    class="form-control"
                    name="middleName"
                    value="${user.middleName}"
                  />
                </div>
                <div class="col-md-4">
                  <label class="labels">Last Name</label>
                  <input
                    type="text"
                    class="form-control"
                    name="lastName"
                    value="${user.lastName}"
                    required
                  />
                </div>
              </div>

              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="labels">Mobile Phone</label>
                  <input
                    type="text"
                    class="form-control"
                    name="phone"
                    value="${user.mobilePhone}"
                    required
                  />
                </div>
                <div class="col-md-6">
                  <label class="labels">Email</label>
                  <input
                    type="email"
                    class="form-control"
                    name="email"
                    value="${user.email}"
                    required
                  />
                </div>
              </div>

              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="labels">Password</label>
                  <input
                    type="password"
                    class="form-control"
                    name="password"
                    value="${user.password}"
                    required
                    id="password"
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
                      >Show password</label
                    >
                  </div>
                </div>
                <div class="col-md-6">
                  <label class="labels">Birthday</label>
                  <input
                    type="date"
                    class="form-control"
                    name="dob"
                    value="${user.birthday}"
                    required
                  />
                </div>
              </div>

              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="labels">Change Your Avatar</label>
                  <input
                    type="file"
                    class="form-control"
                    name="avatar"
                    accept="image/*"
                  />
                </div>
                <div class="col-md-6">
                  <label class="labels">Role</label>
                  <input
                    type="text"
                    class="form-control"
                    value="${user.role}"
                    readonly
                  />
                </div>
              </div>

              <div class="row mt-3">
                <div class="col-md-6">
                  <label class="labels">Rank</label>
                  <input
                    type="text"
                    class="form-control"
                    value="${rankName}"
                    readonly
                  />
                </div>
              </div>

              <div class="mt-5 text-center">
                <button class="btn profile-button" type="submit">
                  Save Profile
                </button>
                <button
                  class="btn profile-button"
                  type="button"
                  onclick="logout()"
                >
                  Logout
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    <script>
      function logout() {
        if (confirm("Are you sure you want to logout?")) {
          var form = document.createElement("form");
          form.method = "post";
          form.action = "profile";

          var actionInput = document.createElement("input");
          actionInput.type = "hidden";
          actionInput.name = "action";
          actionInput.value = "logout";

          form.appendChild(actionInput);
          document.body.appendChild(form);
          form.submit();
        }
      }
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
