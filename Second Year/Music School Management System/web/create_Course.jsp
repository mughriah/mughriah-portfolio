<%-- 
    Document   : create_Course
    Created on : 11 21, 23, 3:28:57 PM
    Author     : ccslearner
--%>
<%@page import="java.util.*"%>
<%@page import="course.createCourse"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Course</title>
  <style>
    body {
      background-color: #FCCDFF;
      text-align: center;
      margin: 0;
      padding: 0;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      font-family: Arial, sans-serif;
    }

    h1 {
      color: #FFFFFF;
      background-color: #B46CA8;
      padding: 30px;
      border-radius: 0px 0px 0 0;
      width: 100%;
      box-sizing: border-box;
      margin: 0;
      font-size: 35px;
    }

    h2 {
      color: #FFFFFF;
      background-color: #B46CA8;
      padding: 20px;
      border-radius: 0 0 0px 0px;
      margin: 0;
      margin-top: auto;
      width: 100%;
      box-sizing: border-box;
      font-size: 16px;
    }

    .bottom-container {
  width: 100%;
  background-color: #B46CA8;
  padding: 10px;
  position: relative; /* Change fixed to relative */
  bottom: 0;
  color: white;
  font-size: 17px;
}


    form {
  background-color: #FCCDFF;
  padding: 30px; /* Increased padding for the form */
  border-radius: 15px; /* Increased border-radius for rounded corners */
  margin-top: 40px; /* Adjusted margin to create space above the form */
  width: 60%; /* Adjusted width of the form */
  box-sizing: border-box;
}


    .form-group {
      display: flex;
      flex-direction: row; /* Updated to display in a row */
      justify-content: space-between; /* Added to space out labels and inputs */
      align-items: center;
      margin-bottom: 25px; /* Adjusted margin to create more space between details */
      margin-top: 45px; /* Added margin to create space above the first form group */
    }

    label {
      color: #B46CA8;
      font-weight: bold;
      font-size: 20px;
      margin-bottom: 5px;
      width: 30%; /* Set a width for labels */
      text-align: right; /* Align labels to the right */
    }

    input[type="text"] {
      background-color: #FFFFFF;
      padding: 8px;
      border: 1px solid #B46CA8;
      border-radius: 5px;
      margin-bottom: 10px;
      width: 50%;
      box-sizing: border-box;
    }

    input[type="submit"] {
  background-color: #B46CA8;
  color: #FFFFFF;
  padding: 15px 20px; /* Increased padding to make the button bigger */
  border: 2px solid #FFFFFF; /* Added white border */
  border-radius: 5px;
  cursor: pointer;
  font-size: 16px; /* Adjusted font size */
  margin-top: 50px; /* Adjusted margin to create space above the button */
}


    input[type="submit"]:hover {
      background-color: #874B7D;
    }
  </style>
</head>

<body>
  <h1>Create Course</h1>

  <!-- Form to input course details -->
  <form method="post" action="">
    <div class="form-group">
      <label for="courseID">Course ID:</label>
      <input type="text" id="courseID" name="courseID" required>
    </div>

    <div class="form-group">
      <label for="courseName">Course Name:</label>
      <input type="text" id="courseName" name="courseName" required>
    </div>

    <div class="form-group">
      <label for="units">Units:</label>
      <input type="text" id="units" name="units" required>
    </div>

    <div class="form-group">
      <label for="instructorID">Instructor ID:</label>
      <input type="text" id="instructorID" name="instructorID" required>
    </div>

    <div class="form-group">
      <label for="tuition_cost">Tuition Cost:</label>
      <input type="text" id="tuition_cost" name="tuition_cost" required>
    </div>

    <input type="submit" value="Create Course">
  </form>

	<% 
            // Handle form submission
            if (request.getMethod().equalsIgnoreCase("post")) {

               try{
                // Set values from form parameters
                int c_courseID = Integer.parseInt(request.getParameter("courseID"));
                String c_courseName = request.getParameter("courseName");
                int c_units = Integer.parseInt(request.getParameter("units"));
                int c_instructorID = Integer.parseInt(request.getParameter("instructorID"));
                double c_tuition_cost = Double.parseDouble(request.getParameter("tuition_cost"));
                
                createCourse course = new createCourse();
		int result = course.CreateCourse(c_courseID, c_courseName, c_units, c_instructorID, c_tuition_cost); 
			if(result == 1){ 
                  %>
                  <script>
                  alert("Course created successfully!");
                  
                 </script>
                 <%
             } else{ 
                %>
                <script>
                  alert("Failed to create course. Please try again.");
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
