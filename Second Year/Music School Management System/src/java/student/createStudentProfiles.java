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

public class createStudentProfiles {
    
    public int studentID; // unique identifier for a student
    public String firstname; // first name of the student 
    public String middleInitial; // middle initial of the student
    public String lastName; // last name of the student
    public String studentType; // type of the student (Regular, Irregular)
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
        Enumeration representing the type of the student (Regular, Irregular)
    */
    enum StudentType {
        Regular, Irregular
    }
    
    /*
        Default constructor for the studentProfiles class
        Initializes attributes with default values
    */
    public createStudentProfiles(){
        studentID = 0;
        firstname = "";
        middleInitial = "";
        lastName = "";
        studentType = "";
        birthDate = "";
        gender = "";
        schoolEmail = "";
        phoneNum = "";
        
    }
    
    /*
        This method is responsible for creating a new student profile in the database
    
        @return 1 if the profile creation is successful, 0 otherwise.
        @throws FileNotFoundException If a required file is not found.
        @throws ClassNotFoundException If a required class is not found during the execution.
    */
    
    public int createStudProf(int studentID, String studentType, String firstname, String middleInitial, String lastName, String birthDate, String gender, String schoolEmail, String phoneNum) throws FileNotFoundException, ClassNotFoundException{
         try{
            
            // establishing a database connection
            Connection cn;
            PreparedStatement ps;
    
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
            // creating a prepared statement for inserting new student profile
            ps = cn.prepareStatement("INSERT INTO MSManSys_db_app.studentProfiles (studentID, studentType, firstname, middleInitial,"
                    + "lastName, birthDate, gender, schoolEmail, phoneNum) VALUES(?,?,?,?,?,?,?,?,?)");

            // setting parameters for the prepared statement
            ps.setInt(1, studentID);
            ps.setString(2,studentType);
            ps.setString(3, firstname);
            ps.setString(4, middleInitial);
            ps.setString(5, lastName);
            ps.setString(6, birthDate);
            ps.setString(7, gender);
            ps.setString(8, schoolEmail);
            ps.setString(9, phoneNum);
                    
           
            ps.executeUpdate(); // executing the insert operation
            ps.close(); // closing the prepared statement
            cn.close(); // closing the database connection
            return 1; // returning 1 to indicate successful profile creation
            
            }catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message in case of an exception
                return 0; // returning 0 to indicate unsuccessful profile creation
            }
    }
    
    /*public static void main(String[] args){
        createStudentProfiles Createstudentprofiles = new createStudentProfiles();
        
        Createstudentprofiles.studentID = 15;
        Createstudentprofiles.studentType = "Regular";
        Createstudentprofiles.firstname = "Chloe";
        Createstudentprofiles.middleInitial = "L";
        Createstudentprofiles.lastName = "Torres";
        Createstudentprofiles.birthDate = "2002-11-10";
        Createstudentprofiles.gender = "Female";
        Createstudentprofiles.schoolEmail = "chloe.torres@example.com";
        Createstudentprofiles.phoneNum = "09985673425";
        
        try {
            Createstudentprofiles.createStudProf();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    } */
}
