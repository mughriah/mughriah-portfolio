/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package student;

/**
 *
 * @author ccslearner
 */


import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class updateStudentProfiles {
    
    public int studentID; // unique identifier for a student
    public String firstname; // first name of the student 
    public String middleInitial; // middle initial of the student
    public String lastName; // last name of the student
    public String birthDate; // birthdate of the student
    public String gender; // gender of the student
    public String schoolEmail; // school email address of the student
    public String phoneNum; // phone number of the student
   
    
    /*
        Enumeration representing the gender of the student (Male, Female)
    */
    enum gender {
        Male, Female
    }
    
    
    
    /*
        Default constructor for the studentProfiles class
        Initializes attributes with default values
    */
    public updateStudentProfiles(){
        studentID = 0;
        firstname = "";
        middleInitial = "";
        lastName = "";
        birthDate = "";
        gender = "";
        schoolEmail = "";
        phoneNum = "";
        
    }
    
    /*
        Updates the student's profile in the database with a new student type
    
        @return 1 if the update is successful, 0 otherwise.
        @throws FileNotFoundException If a required file is not found.
        @throws ClassNotFoundException If a required class is not found during the execution.
    */
    
    public int updateStudProf(int studentID, String firstname, String middleInitial,String lastName, String birthDate, String gender, String schoolEmail, String phoneNum) throws FileNotFoundException, ClassNotFoundException{
        
        
        try{
            // establishing a database connection
            Connection cn;
            PreparedStatement ps;
    
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
            // updating the student's profile in the database
            ps = cn.prepareStatement("UPDATE MSManSys_db_app.studentProfiles SET firstname=?"
                    + ", middleInitial=?, lastName=?, birthDate=?, gender=?, schoolEmail=?, phoneNum=?"
        + "WHERE studentID=?");

            
            ps.setString(1, firstname);
            ps.setString(2, middleInitial);
            ps.setString(3, lastName);
            ps.setString(4, birthDate);
            ps.setString(5, gender);
            ps.setString(6, schoolEmail);
            ps.setString(7, phoneNum);
            ps.setInt(8, studentID);
                    
           
            ps.executeUpdate(); // executing the update operation
            ps.close(); // closing the prepared statement
            cn.close(); // closing the database connection
            
            return 1; // returning 1 to indicate successful update
            
            }catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message in case of operation
                return 0; // returning 0 to indicate unsuccessful update
            }
      
    }
    
    /*
    public static void main(String[] args){
        updateStudentProfiles Updatestudentprofiles = new updateStudentProfiles();
        
        Updatestudentprofiles.studentID = 10;
        //Updatestudentprofiles.studentType = "Irregular";
        Updatestudentprofiles.firstname = "Chloe";
        Updatestudentprofiles.middleInitial = "L";
        Updatestudentprofiles.lastName = "Torres";
        Updatestudentprofiles.birthDate = "2002-11-10";
        Updatestudentprofiles.gender = "Female";
        Updatestudentprofiles.schoolEmail = "chloe.torres@example.com";
        Updatestudentprofiles.phoneNum = "09985673425";
        
        try {
            Updatestudentprofiles.updateStudProf();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    }*/
}
