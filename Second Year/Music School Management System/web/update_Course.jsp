<%-- 
    Document   : updatecourse
    Created on : 11 21, 23, 8:39:56 AM
    Author     : ccslearner
--%>

<%@page import="java.util.*" %>
<%@page import="course.updateCourse" %>
<%@page import="course.retrieveCourse" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Update Course</title>

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
      position: absolute;
      top: 0;
      width: 100%;
    }

    /* Bottom container with border */
    .bottom-container {
      width: 100%;
      background-color: #B46CA8;
      padding: 10px;
      position: fixed;
      bottom: 0;
    }

    /* White font color for specific text */
    .bottom-container p {
      color: white;
      font-size: 17px;
    }

    /* Adjust margin-bottom for the header */
    header h1 {
      font-size: 55px;
      margin-bottom: 30px;
    }

    /* Style for Date and Time display */
    #datetime {
      color: white;
      font-size: 18px;
    }

    .course-form {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        max-width: 800px;
        margin: 0 auto;
    }

    .form-group {
        flex-basis: calc(33.33% - 20px);
        margin-bottom: 10px;
    }

    .form-group label {
        display: block;
        margin-bottom: 1px;
    }

    .form-group input {
        width: 100%;
        padding: 5px;
        box-sizing: border-box;
    }

    .btn {
        font-size: 12px;
        border: 2px solid white;
        outline: none;
        color: white;
        padding: 10px 15px;
        background-color: #B46CA8;
        font-family: inherit;
        cursor: pointer;
        text-decoration: none;
        border-radius: 5px;
        margin-top: 5px;
        /* Adjusted margin for spacing */
    }

    .btn:hover {
        background-color: #ddd;
        color: #B46CA8;
    }
    

  </style>
</head>

<body>

  <!-- Header Title -->
  <header>
    <h1>Update Course</h1>
  </header>

  
  <form action="" method="post" class="course-form">
    <div class="form-group">
        <label for="courseID">Course ID:</label>
        <input type="text" id="courseID" name="courseID" required>
    </div>

    <div class="form-group">
        <label for="courseName">Course Name:</label>
        <input type="text" id="courseName" name="courseName">
    </div>

    <div class="form-group">
        <label for="units">Units:</label>
        <input type="text" id="units" name="units">
    </div>

    <div class="form-group">
        <label for="instructorID">Instructor ID:</label>
        <input type="text" id="instructorID" name="instructorID">
    </div>

    <div class="form-group">
        <label for="tuitionCost">Tuition Cost:</label>
        <input type="text" id="tuitionCost" name="tuitionCost">
    </div>

    <input type="submit" value="Update Course">
    
</form>
  
  <%
      if (request.getMethod().equalsIgnoreCase("post")) {

      try {
        int inp_courseID = Integer.parseInt(request.getParameter("courseID"));

        // Check if the courseID exists before updating
        retrieveCourse search = new retrieveCourse();
        List<String> courseExists = search.RetrieveCourse();
        

        if (!courseExists.isEmpty()) {
          String inp_courseName = request.getParameter("courseName");
          int inp_units = Integer.parseInt(request.getParameter("units"));
          int inp_instructorID = Integer.parseInt(request.getParameter("instructorID"));
          double inp_tuitionCost = Double.parseDouble(request.getParameter("tuitionCost"));

          updateCourse update = new updateCourse();
          int result = update.UpdateCourse(inp_courseID, inp_courseName, inp_units, inp_instructorID, inp_tuitionCost);

          if (result == 1) {
      %>
            <script>
              alert("Course updated successfully!");
              window.location.href = "course_Catalog.jsp";
            </script>
      <%
          } else {
      %>
            <script>
              alert("Failed to update course. Please try again.");
              location.reload();
            </script>
      <%
          }
        } if(courseExists.isEmpty()) {
      %>
          <script>
            alert("Course ID does not exist. Please enter a valid Course ID.");
            location.reload();
          </script>
      <%
        }

      } catch (NumberFormatException e) {
        e.printStackTrace();
      }
    }
      
  %>

  <!-- Bottom container with border -->
  <div class="bottom-container">
    <p style="font-size: 17px;">CCINFOM - DB Application Group 5</p>
    <!-- Date and Time display -->
    <div id="datetime"></div>
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
  </script>

</body>

</html>
