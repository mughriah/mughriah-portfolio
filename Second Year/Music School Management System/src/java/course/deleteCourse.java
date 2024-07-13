package course;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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

public class deleteCourse {
    
    // fields
    public int courseID;        // primary key for course
    public int course_id;
    public int instrumentID;
    /*
    * default constructors for the course class.
    * initializes attributes with default values.
    */    
  
    public deleteCourse() {
    this.courseID = 0;
    this.course_id = 0;
    this.instrumentID = 0;
}

  /*
 * DELETES a course along with related records from different tables in the database.
 *
 * @return 1 if the update is successful, 0 otherwise.
 * @throws FileNotFoundException if a required file is not found.
 * @throws ClassNotFoundException if a required class is not found during execution.
 */ 
public int DeleteCourse(int courseID, int course_id, int instrumentID) throws FileNotFoundException, ClassNotFoundException {
    try {

        Connection cn;
        PreparedStatement ps, ps2, ps3, ps4, ps5, ps6;

        // Establishing a database connection
        cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
        
       

        // Delete from 'prerequisites'
        ps = cn.prepareStatement("DELETE FROM MSManSys_db_app.prerequisites WHERE course_id=?");
        ps.setInt(1, course_id);
        ps.executeUpdate();
        ps.close();
        

        // Delete from 'course_enrollment'
        ps2 = cn.prepareStatement("DELETE FROM MSManSys_db_app.course_enrollment WHERE course_id=?");
        ps2.setInt(1, course_id);
        ps2.executeUpdate();
        ps2.close();
      

        // Delete from 'room_assignment'
        ps3 = cn.prepareStatement("DELETE FROM MSManSys_db_app.room_assignment WHERE course_id=?");
        ps3.setInt(1, course_id);
        ps3.executeUpdate();
        ps3.close();
      
        // Delete from 'instrumentBorrow'
        ps4 = cn.prepareStatement("DELETE FROM MSManSys_db_app.instrumentBorrow WHERE instrumentID=?");
        ps4.setInt(1, instrumentID);
        ps4.executeUpdate();
        ps4.close();

        // Delete from 'instrument'
        ps5 = cn.prepareStatement("DELETE FROM MSManSys_db_app.instrument WHERE courseID=?");
        ps5.setInt(1, courseID);
        ps5.executeUpdate();
        ps5.close();
        
        // Delete from 'course'
        ps6 = cn.prepareStatement("DELETE FROM MSManSys_db_app.course WHERE courseID=?");
        ps6.setInt(1, courseID);
        ps6.executeUpdate();
        ps6.close();
        
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
