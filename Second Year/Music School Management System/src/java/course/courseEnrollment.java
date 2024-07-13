/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package course;

/**
 *
 * @author ccslearner
 *
 */
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class courseEnrollment {

    // fields
    public int c_enroll_id; // primary key for course enrollment
    public int student_id; // student ID
    public int course_id; // course ID
    public double c_grade; // grade
    public int semID; // semester ID
    public String status; // enrollment status as enum
    public int is_retake; // flag for retake

    // ENUM
    enum status {
        Ongoing, Dropped, Failed, Cancelled, Completed
    }

    /*
    * default constructors for the course enrollment class.
    * initializes attributes with default values.
     */
    public courseEnrollment() {
        this.c_enroll_id = 0;
        this.student_id = 0;
        this.course_id = 0;
        this.c_grade = 0.0;
        this.semID = 0;
        this.status = "";
        this.is_retake = 0;
    }

    /**
     * ENROLLS a student in a course.
     *
     * @return 1 if the enrollment is successful, 0 otherwise.
     */
    public int enrollStudent(int c_enroll_id, int student_id, int course_id, double c_grade, int semID, String status, int is_retake) {

    try {
        // Establishing a connection to the database
        Connection cn;
        PreparedStatement ps;
              
                cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

        // Preparing SQL statement for course enrollment
        ps = cn.prepareStatement("INSERT INTO MSManSys_db_app.course_enrollment (c_enroll_id, student_id, course_id, c_grade, semID, status, is_retake) VALUES (?, ?, ?, ?, ?, ?, ?)");

        // Setting values for the prepared statement
        ps.setInt(1, c_enroll_id);
        ps.setInt(2, student_id);
        ps.setInt(3, course_id);
        ps.setDouble(4, c_grade);
        ps.setInt(5, semID);
        ps.setString(6, status);
        ps.setInt(7, is_retake);

        // Executing the update
        ps.executeUpdate();

        // Closing resources
        ps.close();
        cn.close();
        return 1;

    } catch (SQLException e) {
        // Handling SQL exception and printing the error message
        System.out.println(e.getMessage());
        e.printStackTrace();
    }

    return 0;
}
}
