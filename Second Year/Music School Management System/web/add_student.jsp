<%-- 
    Document   : addstudent
    Created on : 11 21, 23, 8:39:56 AM
    Author     : ccslearner
--%>

<%@page import="java.util.*" %>
<%@page import="student.createStudentProfiles" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Student Profiles</title>

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

    .student-form {
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
    <h1>Create Student Profiles</h1>
  </header>

  
  <form action="" method="post" class="student-form">
    <div class="form-group">
        <label for="studentID">Student ID:</label>
        <input type="text" id="studentID" name="studentID" required>
    </div>

    <div class="form-group">
        <label for="studentType">Student Type:</label>
        <input type="text" id="studentType" name="studentType" required>
    </div>

    <div class="form-group">
        <label for="firstname">First Name:</label>
        <input type="text" id="firstname" name="firstname" required>
    </div>

    <div class="form-group">
        <label for="middleInitial">Middle Initial:</label>
        <input type="text" id="middleInitial" name="middleInitial" required>
    </div>

    <div class="form-group">
        <label for="lastName">Last Name:</label>
        <input type="text" id="lastName" name="lastName" required>
    </div>

    <div class="form-group">
        <label for="birthDate">Birth Date (YYYY-MM-DD):</label>
        <input type="text" id="birthDate" name="birthDate" required>
    </div>

    <div class="form-group">
        <label for="gender">Gender (Male/Female):</label>
        <input type="text" id="gender" name="gender" required>
    </div>

    <div class="form-group">
        <label for="schoolEmail">School Email:</label>
        <input type="text" id="schoolEmail" name="schoolEmail" required>
    </div>

    <div class="form-group">
        <label for="phoneNum">Phone Number:</label>
        <input type="text" id="phoneNum" name="phoneNum" required>
    </div>

      
    <input type="submit" value="Create Profile">
    
</form>
  
  <%
      if(request.getMethod().equalsIgnoreCase("post")){
          
          try{
              int inp_studentID = Integer.parseInt(request.getParameter("studentID"));
              String inp_studentType = request.getParameter("studentType");
              String inp_firstname = request.getParameter("firstname");
              String inp_middleInitial = request.getParameter("middleInitial");
              String inp_lastName = request.getParameter("lastName");
              String inp_birthDate = request.getParameter("birthDate");
              String inp_gender = request.getParameter("gender");
              String inp_schoolEmail = request.getParameter("schoolEmail");
              String inp_phoneNum = request.getParameter("phoneNum");
              
              createStudentProfiles create = new createStudentProfiles();
              int result = create.createStudProf(inp_studentID, inp_studentType, inp_firstname, inp_middleInitial, inp_lastName, inp_birthDate, inp_gender, inp_schoolEmail, inp_phoneNum);
              
       
               if(result == 1){ 
                  %>
                  <script>
                  alert("Student profile created successfully!");
                  window.location.href="student_Profiles.jsp";
                 </script>
                 <%
             } else{ 
                %>
                <script>
                  alert("Failed to create student profile. Please try again.");
                  location.reload();
                 </script>
                 <%
              }
              
                
          }catch(NumberFormatException e){
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




