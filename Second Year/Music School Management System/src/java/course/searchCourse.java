package course;

import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class searchCourse {

    // Fields
    public int courseID;        // Primary key for course
    public int units;           // Number of units of a course
    public String courseName;   // Name of course
    public int instructorID;
    public double tuition_cost;

    // Method to set the course ID
    public void setCourseID(int courseID) {
        this.courseID = courseID;
    }

    // Method to set the units
    public void setUnits(int units) {
        this.units = units;
    }

    // Default constructor
    public searchCourse() {
        this.courseID = 0;
        this.units = 0;
        this.courseName = "";
        this.instructorID = 0;
        this.tuition_cost = 0;
    }

    // Method to search for a course
    public List<String> searchCourse() throws FileNotFoundException, ClassNotFoundException {
        List<String> courseDetails = new ArrayList<>();

        try {
            Connection cn;
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

            PreparedStatement ps;
            ps = cn.prepareStatement("SELECT courseID, courseName, units, instructorID, tuition_cost "
                    + "FROM MSManSys_db_app.course WHERE units=?");

            ps.setInt(1, units);

            ResultSet rs;
            rs = ps.executeQuery();

   

            while (rs.next()) {
                int course_ID = rs.getInt("courseID");
                String course_Name = rs.getString("courseName");
                int c_units = rs.getInt("units");
                int instructID = rs.getInt("instructorID");
                double t_cost = rs.getDouble("tuition_cost");

                System.out.println("\n" + "courseID:" + course_ID + " courseName:" + course_Name
                        + " units:" + c_units + " instructorID:" + instructID
                        + " tuition_cost:" + t_cost + "\n");

                String courseDetail = "courseID: " + course_ID + "\n"
                        + " courseName: " + course_Name + "\n"
                        + " units: " + c_units + "\n"
                        + " instructorID: " + instructID + "\n"
                        + " tuition_cost: " + t_cost + "\n";

                courseDetails.add(courseDetail);
            }

            rs.close();
            ps.close();
            cn.close();

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return courseDetails;
    }
}
