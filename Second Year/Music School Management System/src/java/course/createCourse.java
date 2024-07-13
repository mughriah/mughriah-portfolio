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
 * 
 */

import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;

public class createCourse {
    
    // fields
    public int courseID;        // primary key for course
    public String courseName;   // name of course
    public int units;           // number of units of a course
    public int instructorID;
    public double tuition_cost;
    /*
    * default constructors for the course class.
    * initializes attributes with default values.
    */    
  
    public createCourse() {
    this.courseID = 0;
    this.courseName = "";
    this.units = 0;
    this.instructorID = 0;
    this.tuition_cost = 0;
}

/**
 * CREATES a new course in the database.
 *
 * @return 1 if the update is successful, 0 otherwise.
 * @throws FileNotFoundException If a required file is not found.
 * @throws ClassNotFoundException If a required class is not found during execution.
 */

public int CreateCourse(int courseID, String courseName, int units, int instructorID, double tuition_cost) throws FileNotFoundException, ClassNotFoundException {

    try {
        //database connection
        Connection cn;
        PreparedStatement ps;

        // Establishing a connection to the database
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

        // Preparing SQL statement for course creation
        ps = cn.prepareStatement("INSERT INTO MSManSys_db_app.course (courseID, courseName, units, instructorID, tuition_cost) VALUES(?,?,?,?,?)");

        // Setting values for the prepared statement
        ps.setInt(1, courseID);
        ps.setString(2, courseName);
        ps.setInt(3, units);
        ps.setInt(4, instructorID);
        ps.setDouble(5, tuition_cost);

        // Executing the update
        ps.executeUpdate();

        // Closing resources
        ps.close();
        cn.close();

        return 1;

    } catch (SQLException e) {
        // Handling SQL exception and printing the error message
        System.out.println(e.getMessage());

        return 0;
    }
}
}


