<%-- 
    Document   : addstudent
    Created on : 11 21, 23, 8:39:56 AM
    Author     : ccslearner
--%>

<%@page import="java.util.*" %>
<%@page import="student.deleteStudentProfiles" %>
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
        margin-bottom: 3px;
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
    <h1>Delete Student Profiles</h1>
  </header>

  
  <form action="" method="post">
      
    <div class="form-group">
        <br><br><label for="studentID">Student ID:</label>
        <input type="text" id="studentID" name="studentID"required>
    </div>

    <div class="form-group">
        <label for="ge_id">General Enrollment ID:</label>
        <input type="text" id="ge_id" name="ge_id">
    </div>
      
      <div class="form-group">
        <label for="enrollmentID">Enrollment ID:</label>
        <input type="text" id="enrollmentID" name="enrollmentID">
    </div>
      
      <div class="form-group">
        <label for="gstudent_id">Student ID:</label>
        <input type="text" id="student_id" name="student_id">
    </div>
      
     
   <input type="submit" value="Delete Profile"> 
    
    
</form>
  
  <%
      if(request.getMethod().equalsIgnoreCase("post")){
          
          try{
              int inp_studentID = Integer.parseInt(request.getParameter("studentID"));
               
              int inp_ge_id = Integer.parseInt(request.getParameter("ge_id"));
              int inp_enrollmentID = Integer.parseInt(request.getParameter("enrollmentID"));
              int inp_student_id = Integer.parseInt(request.getParameter("student_id"));
            
              
              deleteStudentProfiles delete = new deleteStudentProfiles();
              int result = delete.deleteStudProf(inp_studentID, inp_ge_id, inp_enrollmentID, inp_student_id);
              
       
               if(result == 1){ 
                  %>
                  <script>
                  alert("Student profile deleted successfully!");
                  window.location.href="studentProfiles.jsp";
                 </script>
                 <%
             } else{ 
                %>
                <script>
                  alert("Failed to delete student profile. Please try again.");
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
