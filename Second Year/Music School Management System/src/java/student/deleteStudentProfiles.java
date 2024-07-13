/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student;

import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 *
 * @author ccslearner
 */
public class deleteStudentProfiles {
    
    public int studentID; // unique identifier for a student
    public int enrollmentID;
    public int ge_id;
    public int student_id;
    /*
        Default constructor for the studentProfiles class
        Initializes attributes with default values
    */
    public deleteStudentProfiles(){
        studentID = 0;
        enrollmentID = 0;
        ge_id = 0;
        student_id = 0;
    }
    /*
        This method is responsible for deleting a student profile and associated records from various tables in the database
        
        @return 1 if the deletion is successful, 0 otherwise.
        @throws FileNotFoundException If a required file is not found.
        @throws ClassNotFoundException If a required class is not found during the execution.
    */
    
    public int deleteStudProf(int studentID, int ge_id, int enrollmentID, int student_id) throws FileNotFoundException, ClassNotFoundException{
         try{
            // establishing a database connection
            Connection cn;
            PreparedStatement ps, ps2, ps3, ps4, ps5, ps6, ps7,ps8, ps10, ps11;
            
    
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
            // deleting associated records from the 'account' table
            ps = cn.prepareStatement("DELETE FROM MSManSys_db_app.account WHERE studentID=?");
            ps.setInt(1, studentID);
            ps.executeUpdate();
            ps.close();
            
            // deleting associated records from the 'address' table
            ps2 = cn.prepareStatement("DELETE FROM MSManSys_db_app.address WHERE studentID=?");
            ps2.setInt(1, studentID);
            ps2.executeUpdate();
            ps2.close();
            
            // deleting associated records from the 'emerg_contact" table
            ps3 = cn.prepareStatement("DELETE FROM MSManSys_db_app.emerg_contact WHERE studentID=?");
            ps3.setInt(1, studentID);
            ps3.executeUpdate();
            ps3.close();
            
            // deleting associated records from the 'college_degree" table
            ps3 = cn.prepareStatement("DELETE FROM MSManSys_db_app.college_degree WHERE ge_id=?");
            ps3.setInt(1, ge_id);
            ps3.executeUpdate();
            ps3.close();
            
            // deleting associated records from the 'general_enrollment' table
            ps4 = cn.prepareStatement("DELETE FROM MSManSys_db_app.general_enrollment WHERE studentID=?");
            ps4.setInt(1, studentID);
            ps4.executeUpdate();
            ps4.close();
            
            // deleting associated records from 'instrumentBorrow' table
            ps5 = cn.prepareStatement("DELETE FROM MSManSys_db_app.instrumentBorrow WHERE studentID=?");
            ps5.setInt(1, studentID);
            ps5.executeUpdate();
            ps5.close();
            
            // deleting associated records from 'payment' table
            ps6 = cn.prepareStatement("DELETE FROM MSManSys_db_app.payment WHERE studentID=?");
            ps6.setInt(1, studentID);
            ps6.executeUpdate();
            ps6.close();
            
            // deleting associated records from 'retaker' table
            ps7 = cn.prepareStatement("DELETE FROM MSManSys_db_app.retaker WHERE studentID=?");
            ps7.setInt(1, studentID);
            ps7.executeUpdate();
            ps7.close();
                
            
            ps8 = cn.prepareStatement("DELETE FROM MSManSys_db_app.course_enrollment WHERE student_id=?");
            ps8.setInt(1, student_id);
            ps8.executeUpdate();
            ps8.close();
            
           
            
            // deleting associated records from 'waitlist' table
            ps10 = cn.prepareStatement("DELETE FROM MSManSys_db_app.waitlist WHERE studentID=?");
            ps10.setInt(1, studentID);
            ps10.executeUpdate();
            ps10.close();
            
            // deleting the records from the 'studentProfiles' table
            ps11 = cn.prepareStatement("DELETE FROM MSManSys_db_app.studentProfiles WHERE studentID=?");
            ps11.setInt(1, studentID);
            ps11.executeUpdate();
            ps11.close();
            
            
               
            cn.close(); // closing the database connection
            return 1; // returning 1 to indicate successful deletion
            
            }catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message incase of am exception
                return 0; // returning 0 to indicate unsuccessful deletion
            }
    }
    
    /*
    
     public static void main(String[] args){
        deleteStudentProfiles Deletestudentprofiles = new deleteStudentProfiles();
        
        Deletestudentprofiles.studentID = 11;
        Deletestudentprofiles.enrollmentID = 10011;
        Deletestudentprofiles.ge_id = Deletestudentprofiles.enrollmentID;
        Deletestudentprofiles.student_id = Deletestudentprofiles.studentID;
     
        try {
            Deletestudentprofiles.deleteStudProf();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    } */
}
