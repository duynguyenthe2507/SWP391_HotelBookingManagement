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
    <style>
      body {
        background: rgb(255, 153, 0);
      }

      .form-control:focus {
        box-shadow: none;
        border-color:  rgb(255, 153, 0);
      }

      .profile-button {
        background:  rgb(255, 153, 0);
        box-shadow: none;
        border: none;
      }

      .profile-button:hover {
        background:  rgb(255, 153, 0);
      }

      .profile-button:focus {
        background:  rgb(255, 153, 0);
        box-shadow: none;
      }

      .profile-button:active {
        background:  rgb(255, 153, 0);
        box-shadow: none;
      }

      .back:hover {
        color:  rgb(255, 153, 0);
        cursor: pointer;
      }

      .labels {
        font-size: 11px;
      }

      .add-experience:hover {
        background:  rgb(255, 153, 0);
        color: #fff;
        cursor: pointer;
        border: solid 1px  rgb(255, 153, 0);
      }

      .alert {
        margin-bottom: 20px;
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
            <span class="font-weight-bold"
              >${user.firstName} ${user.lastName}</span
            >
            <span class="text-black-50">${user.email}</span>
            <span class="text-black-50">Rank: ${rankName}</span>
          </div>
        </div>
        <div class="col-md-9">
          <div class="p-3 py-5">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h4 class="text-right">Profile Settings</h4>
              <a href="home" class="btn btn-secondary">Back to Home</a>
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

            <form method="post" action="profile">
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
                  />
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
                  <label class="labels">Role</label>
                  <input
                    type="text"
                    class="form-control"
                    value="${user.role}"
                    readonly
                  />
                </div>
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
                <button class="btn btn-primary profile-button" type="submit">
                  Save Profile
                </button>
                <button class="btn btn-danger" type="button" onclick="logout()">
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
    </script>
  </body>
</html>
