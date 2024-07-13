
<%@page import="course.retrieveCourse"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Retrieve Course Profiles</title>

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
        z-index: 1; /* Set z-index to ensure it stays on top */
    }

    /* Adjust margin-top for the profile container */
    .profile-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: space-around;
        max-width: 800px;
        margin: 50px auto; /* Adjusted margin to create space below the header */
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
        <h1>Retrieve Course Profiles</h1>
    </header>

    <!-- Container for course profiles -->
    <div class="profile-container">
        <!-- Java code to retrieve and display course profiles -->
        <% 
            course.retrieveCourse RetrieveCourse = new course.retrieveCourse();
            List<String> courseProfiles = RetrieveCourse.RetrieveCourse();

            if (courseProfiles.isEmpty()) {
                out.println("<p>No course profiles found.</p>");
            } else {
                for (String profile : courseProfiles) {
        %>
                <!-- Style each course profile -->
                <div class="profile">
                    <p><%= profile %></p>
                </div>
        <%
                }
            }
        %>
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
