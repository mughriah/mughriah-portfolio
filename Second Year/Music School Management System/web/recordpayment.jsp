<%-- 
    Document   : addstudent
    Created on : 11 21, 23, 8:39:56 AM
    Author     : ccslearner
--%>

<%@page import="java.util.*" %>
<%@page import="Payment.SemesterBill" %>
<%@page import="Payment.SemesterBillDAO" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>

<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Record Payments</title>

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
    <h1>Record Payments</h1>
  </header>

  <form action="" method="post" class="student-form">
        <div class="form-group">
            <label for="studentID">Student ID:</label>
            <input type="text" id="studentID" name="studentID" required>
        </div>

        <input type="submit" value="Fetch Total Bill">
    </form>

    <%
    if (request.getMethod().equalsIgnoreCase("post")) {
        try {
            int inp_studentID = Integer.parseInt(request.getParameter("studentID"));

            // Create an instance of SemesterBill
            SemesterBill studentBill = new SemesterBill();
            studentBill.setStudentID(inp_studentID);

            // Fetch relevant information based on student ID
            SemesterBill bill = SemesterBillDAO.getBillDetails(studentBill);

            // Check if studentID is found
            if (bill.getBillID() != 0) {
                double fullTotal = bill.getFullTotal();

                // Display full total to the user
    %>

                    <div>
                        <p>Total Amount to be Paid: <%= fullTotal %></p>
                    </div>

                    <!-- Now ask for payment details -->
                    <form action="" method="post" class="payment-form">
                        <input type="hidden" name="studentID" value="<%= inp_studentID %>">
                        <input type="hidden" name="fullTotal" value="<%= fullTotal %>">

                        <div class="form-group">
                            <label for="paymentMethod">Payment Method:</label>
                            <input type="text" id="paymentMethod" name="paymentMethod" required>
                        </div>

                        <div class="form-group">
                            <label for="amount">Amount:</label>
                            <input type="text" id="amount" name="amount" required>
                        </div>

                        <input type="submit" value="Record Payment" class="btn">
                    </form>
    <%
                } else {
                    // Handle case where studentID is not found
    %>
                    <div>
                        <p>Student ID not found. Please enter a valid Student ID.</p>
                    </div>
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




