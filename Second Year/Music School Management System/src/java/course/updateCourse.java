package course;

import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class updateCourse {
    
    // Fields
    public int courseID;        // Primary key for course
    public String courseName;   // Name of course
    public int units;           // Number of units of a course
    public int instructorID;
    public double tuition_cost;
    
    /*
    * Default constructor for the course class.
    * Initializes attributes with default values.
    */    
    public updateCourse() {
        this.courseID = 0;
        this.courseName = "";
        this.units = 0;
        this.instructorID = 0;
        this.tuition_cost = 0.0;
    }

    /*
     * Updates the course in the database with new course details.
     *
     * @return 1 if the update is successful, 0 otherwise.
     * @throws FileNotFoundException if a required file is not found.
     * @throws ClassNotFoundException if a required class is not found during execution.
     */
    public int UpdateCourse(int courseID, String courseName, int units, int instructorID, double tuition_cost) throws FileNotFoundException, ClassNotFoundException {
        try {
            // Establishing a database connection
            Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

            // Creating a prepared statement to update the 'course' table
            PreparedStatement ps = cn.prepareStatement("UPDATE MSManSys_db_app.course SET courseName=?, units=?, instructorID=?, tuition_cost=? "
                    + "WHERE courseID=?");

            // Setting parameters for the prepared statement
            ps.setString(1, courseName);
            ps.setInt(2, units);
            ps.setInt(3, instructorID);
            ps.setDouble(4, tuition_cost);
            ps.setInt(5, courseID);

            // Executing the update operation
            ps.executeUpdate();

            // Closing the prepared statement
            ps.close();

            // Closing the database connection
            cn.close();

            // Returning 1 to indicate successful update
            return 1;

        } catch (SQLException e) {
            // Printing the error message in case of an exception
            System.out.println(e.getMessage());

            // Returning 0 to indicate an unsuccessful update
            return 0;
        }
    }
}
