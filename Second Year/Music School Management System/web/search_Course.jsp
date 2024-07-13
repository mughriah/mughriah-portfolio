<%@page import="java.util.*" %>
<%@page import="course.searchCourse" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Course Profiles</title>

  <!-- Styles for the website -->
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      text-align: center;
      background-color: #FCCDFF;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
    }

    /* Styles for header */
    header {
      background-color: #B46CA8;
      padding: 15px;
      color: white;
      font-size: 24px;
      width: 100%;
    }

    /* Container for the search form and profiles */
    .container {
      max-width: 800px;
      margin: 20px auto;
    }

    /* Style for the search form */
    form {
      margin-bottom: 20px;
    }

    /* Container for course profiles */
    .profile-container {
      display: flex;
      flex-wrap: wrap;
      justify-content: space-around;
    }

    /* Style for each course profile */
    .profile {
      border: 10px solid #FFFFFF;
      border-radius: 8px;
      padding: 15px;
      margin: 10px;
      width: 200px;
      text-align: left;
    }

    /* White font color for specific text */
    .profile p {
      color: #333;
      font-size: 16px;
      margin: 5px 0;
    }

  </style>
</head>

<body>

  <!-- Header Title -->
  <header>
    <h1>Search Course Profiles</h1>
  </header>

  <!-- Container for the search form and profiles -->
  <div class="container">

    <!-- Search Form -->
    <form action="search_Course.jsp" method="post">
      <label for="units">Units: </label>
      <input type="text" id="units" name="units">
      <br>
      <input type="submit" value="Search">
    </form>

    <!-- Profile Container -->
    <div class="profile-container">
      <%
        if(request.getMethod().equalsIgnoreCase("post")){
          int c_units = Integer.parseInt(request.getParameter("units"));

          searchCourse search = new searchCourse();
          search.setUnits(c_units);
          List<String> courseProfiles = search.searchCourse();

          if(courseProfiles.isEmpty()){
      %>
            <script>
              alert("No course units found");
              location.reload();
            </script>
      <%
          } else {
            for(String course : courseProfiles){
      %>
              <div class="profile">
                <p><%= course %></p>
              </div>
      <%
            }
      %>
            <script>
              alert("Course units found"); 
            </script>
      <%
          }
        }
      %>
    </div>

  </div>

  <!-- Script to update date and time -->
  <script>
    function updateDateTime() {
      const now = new Date();
      const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: 'numeric',
        minute: 'numeric',
        second: 'numeric',
        timeZoneName: 'short'
      };
      const formattedDate = now.toLocaleDateString('en-US', options);
      document.getElementById('datetime').innerHTML = formattedDate;
    }

    // Update date and time every second
    setInterval(updateDateTime, 1000);

    // Initial call to display date and time
    updateDateTime();

    function goBack() {
      window.history.back();
    }

  </script>

</body>

</html>
