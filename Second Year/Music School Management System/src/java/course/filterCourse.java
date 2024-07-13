package course;

import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class filterCourse {
    
    // field
    public int units;           // number of units of a course
 
    /*
     * Default constructor for the course class.
     * Initializes attributes with default values.
     */    
    public filterCourse() {
        this.units = 0;
    }

    public void setUnits(int units){
        this.units = units;
    }
    
    /*
     * Filters courses based on units and retrieves filtered course information from the database.
     *
     * @return List<String> containing formatted course details.
     * @throws FileNotFoundException if a required file is not found.
     * @throws ClassNotFoundException if a required class is not found during execution.
     */
   
    public List<String> filterCourses() throws FileNotFoundException, ClassNotFoundException {
        List<String> courseDetails = new ArrayList<>();

        try {
            // Establishing a database connection
            Connection cn;
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

            // Creating a prepared statement to filter data from the 'course' table based on units
            PreparedStatement ps;
            ps = cn.prepareStatement("SELECT courseID, courseName, units, instructorID, tuition_cost "
                    + "FROM MSManSys_db_app.course WHERE units=?");

            // Setting the parameter for the prepared statement
            ps.setInt(1, units);

            // Executing the query and getting the result set
            try (ResultSet rs = ps.executeQuery()) {
                // Printing filtered course entity information
                while (rs.next()) {
                    // Retrieving data from the result set
                    int course_ID = rs.getInt("courseID");
                    String course_Name = rs.getString("courseName");
                    int c_units = rs.getInt("units");
                    int instructID = rs.getInt("instructorID");
                    int t_cost = rs.getInt("tuition_cost");

                    // Formatting course details
                    String courseDetail = "courseID: " + course_ID + "\n"
                            + " courseName: " + course_Name + "\n"
                            + " units: " + c_units + "\n"
                            + " instructorID: " + instructID + "\n"
                            + " tuition_cost: " + t_cost + "\n";

                    // Adding formatted course details to the list
                    courseDetails.add(courseDetail);
                }
            }

            // Closing the prepared statement
            ps.close();

            // Closing the database connection
            cn.close();

        } catch (SQLException e) {
            // Printing the error message in case of an exception
            System.out.println(e.getMessage());
        }

        // Returning the list of formatted course details
        return courseDetails;
    }
}
