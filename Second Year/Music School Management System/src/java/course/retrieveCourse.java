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
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class retrieveCourse {


/*
 * RETRIEVES course information from the database.
 *
 * @return 1 if the retrieval is successful, 0 otherwise.
 * @throws FileNotFoundException if a required file is not found.
 * @throws ClassNotFoundException if a required class is not found during execution.
 */
public List<String> RetrieveCourse() throws FileNotFoundException, ClassNotFoundException {
    List<String> courseProfiles = new ArrayList<>();
    
    try {
        // Establishing a database connection
        Connection cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");

        // Creating a prepared statement to select data from the 'course' table
        PreparedStatement ps = cn.prepareStatement("SELECT courseID, courseName, units, instructorID, tuition_cost "
                + "FROM MSManSys_db_app.course");

        // Executing the query and getting the result set
        ResultSet rs = ps.executeQuery();


        while (rs.next()) {
            // Retrieving data from the result set
            int c_ID = rs.getInt("courseID");
            String c_Name = rs.getString("courseName");
            int unit = rs.getInt("units");
            int i_id = rs.getInt("instructorID");
            double t_c = rs.getDouble("tuition_cost");

            // Creating a course profile string
            String courseProfile = "courseID: " + c_ID + " courseName: " + c_Name + " units: " 
                    + unit + " instructorID: " + i_id + " tuition_cost: " + t_c;

            // Adding the course profile to the list
            courseProfiles.add(courseProfile);
        }

        // Closing the result set and prepared statement
        rs.close();
        ps.close();
        cn.close();

    } catch (SQLException e) {
        // Printing the error message in case of an exception
        System.out.println(e.getMessage());
    }
    
    // Returning the list of course profiles
    return courseProfiles;
}
}
