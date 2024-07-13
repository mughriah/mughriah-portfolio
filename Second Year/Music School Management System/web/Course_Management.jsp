<%-- 
    Document   : Course_Management
    Created on : 11 22, 23, 6:10:37 AM
    Author     : ccslearner
--%>
<%@page import="java.util.*"%>
<%@page import="course.courseByStudent"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Course Management</title>

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

    /* Style for main content container */
    .content-container {
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    /* Style for forms */
    form {
      background-color: #fff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      margin-bottom: 20px;
      max-width: 400px; /* Added max-width for responsiveness */
      width: 100%; /* Make forms take full width on smaller screens */
    }

    label {
      display: block;
      margin-bottom: 8px;
      color: #555;
    }

    input {
      width: 100%;
      padding: 8px;
      margin-bottom: 16px;
      box-sizing: border-box;
      border: 1px solid #ccc;
      border-radius: 4px;
    }

    button {
      font-size: 18px;
      border: 2px solid white;
      outline: none;
      color: white;
      padding: 10px 20px;
      background-color: #B46CA8;
      font-family: inherit;
      cursor: pointer;
      text-decoration: none;
      border-radius: 5px;
    }

    button:hover {
      background-color: #ddd;
      color: #B46CA8;
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
    .bottom-container p,
    #datetime {
      color: white;
      font-size: 17px;
    }
  </style>
</head>

<body>

  <!-- Header Title -->
  <header>
    <h2>Course Management</h2>
  </header>

  <!-- Main content container -->
  <div class="content-container">

    <!-- Form to search courses by student ID -->
    <form action="SearchCoursesByStudentServlet" method="post">
      <label for="studentID">Enter Student ID:</label>
      <input type="text" id="studentID" name="studentID" required>
      <button type="submit">Student ID</button>
    </form>

    <!-- Form to add a course for a student -->
    <form action="AddCourseForStudentServlet" method="post">
      <label for="addCourseID">Enter Course ID to Add:</label>
      <input type="text" id="addCourseID" name="addCourseID" required>
      <button type="submit">Add Course</button>
    </form>

    <!-- Form to update a course for a student -->
    <form action="UpdateCourseForStudentServlet" method="post">
      <label for="updateCEnrollID">Enter Course Enrollment ID to Update:</label>
      <input type="text" id="updateCEnrollID" name="updateCEnrollID" required>
      <label for="newCourseID">Enter New Course ID:</label>
      <input type="text" id="newCourseID" name="newCourseID" required>
      <button type="submit">Update Course</button>
    </form>

    <!-- Form to delete a course for a student -->
    <form action="DeleteCourseForStudentServlet" method="post">
      <label for="deleteCEnrollID">Enter Course Enrollment ID to Delete:</label>
      <input type="text" id="deleteCEnrollID" name="deleteCEnrollID" required>
      <button type="submit">Delete Course</button>
    </form>

  </div>

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
