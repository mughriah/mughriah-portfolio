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
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class searchStudentProfiles {
    
    public int studentID; // unique identifier for a student
    
    
    /*
        Default constructor for the studentProfiles class
        Initializes attributes with default values
    */
    public searchStudentProfiles(){
        
        studentID = 0;
        
    }
    
    public void setStudentID(int studentID){
        this.studentID = studentID;
    }
    
    public List<String> searchStudProf() throws FileNotFoundException, ClassNotFoundException{
        List<String> studentProfiles = new ArrayList<>();
        try{
            
            // establishing a database connection
            Connection cn;
            PreparedStatement ps, ps2, ps3, ps4, ps5, ps6, ps7, ps8, ps10;
            ResultSet rs, rs2, rs3, rs4, rs5, rs6, rs7, rs8, rs10;
    
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
           // STUDENT PROFILES ENTITY //
           
            ps = cn.prepareStatement("SELECT studentID, studentType, firstname, middleInitial, lastName, birthDate,"
                    + "gender, schoolEmail, phoneNum FROM MSManSys_db_app.studentProfiles WHERE studentID=?");

            // setting parameters for the prepared statement
            ps.setInt(1, studentID);
            rs = ps.executeQuery();
           
            
            while(rs.next()){
                int studID= rs.getInt("studentID");
                String studType = rs.getString("studentType");
                String fname = rs.getString("firstname");
                String mi = rs.getString("middleInitial");
                String lname = rs.getString("lastName");
                String bdate = rs.getString("birthDate");
                String sex = rs.getString("gender");
                String email = rs.getString("schoolEmail");
                String num = rs.getString("phoneNum");
                
                String profile = "studentID: " + studID + " studentType: " + studType + " firstname: " + fname
                + " middleInitial: " + mi + " lastName: " + lname + " birthDate: " + bdate + " gender: " + sex + " schoolEmail: " + email + 
                " phoneNum: " + num;
                
                studentProfiles.add(profile);
            }
            
            rs.close();
            ps.close(); // closing the prepared statement
           
            // ACCOUNT ENTITY //
            
            ps2 = cn.prepareStatement("SELECT accountID, username, studentID FROM MSManSys_db_app.account WHERE studentID=?");
             
            ps2.setInt(1, studentID);
            rs2 = ps2.executeQuery();
            

            
            while(rs2.next()){
                int accID = rs2.getInt("accountID");
                String uname = rs2.getString("username");
                int studID = rs2.getInt("studentID");
                String profile2 = "accountID: " + accID + " username: " + uname + " studentID: " + studID;
               
                studentProfiles.add(profile2);
            }
           
            rs2.close();
            ps2.close();
            
            // ADDRESS ENTITY //
            
            ps3 = cn.prepareStatement("SELECT addressID, street, barangay, city, region, zipCode,"
                    + "studentID, emergencyID FROM MSManSys_db_app.address WHERE studentID=?");
             
            ps3.setInt(1, studentID);
            rs3 = ps3.executeQuery();
            
            while(rs3.next()){
                int addID = rs3.getInt("addressID");
                String st = rs3.getString("street");
                String brgy = rs3.getString("barangay");
                String ct = rs3.getString("city");
                String reg = rs3.getString("region");
                int zcode = rs3.getInt("zipCode");
                int studID = rs3.getInt("studentID");
                int emergID = rs3.getInt("emergencyID");
                
                String profile3 = "addressID: " + addID + " street: " + st + " barangay: " + brgy + " city: " + ct +
                        " region: " + reg + " zipCode: " + zcode + " studentID: " + studID + " emergencyID: " + emergID;
                
                studentProfiles.add(profile3);
            }
           
            rs3.close();
            ps3.close();
            
            // EMERG_CONTACT ENTITY //
            
            ps4 = cn.prepareStatement("SELECT emergencyID, e_firstName, e_middleInitial, e_lastName"
                    + ",e_relation, e_ConNum, studentID FROM MSManSys_db_app.emerg_contact WHERE studentID=?");
            
            ps4.setInt(1, studentID);
            rs4 = ps4.executeQuery();
            
            
            while(rs4.next()){
               int emergID = rs4.getInt("emergencyID");
               String e_fn = rs4.getString("e_firstName");
               String e_mi = rs4.getString("e_middleInitial");
               String e_ln = rs4.getString("e_lastName");
               String e_r = rs4.getString("e_relation");
               String e_cnum = rs4.getString("e_ConNum");
               int studID = rs4.getInt("studentID");
               
               String profile4 = "emergencyID: " + emergID + " e_firstName: " + e_fn + " e_middleInitial: "
               + e_mi + " e_lastName: " + e_ln + " e_relation: " + e_r + " e_ConNum: " + e_cnum + " studentID: " + studID;
                
               studentProfiles.add(profile4);
            }
            
            rs4.close();
            ps4.close();
            
            // GENERAL_ENROLLMENT ENTITY //
            
            ps5 = cn.prepareStatement("SELECT enrollmentID, first_semesterID, eStatus, studentID FROM "
                    + "MSManSys_db_app.general_enrollment WHERE studentID=?");
            
            ps5.setInt(1, studentID);
            rs5 = ps5.executeQuery();
            
            
            while(rs5.next()){
                int e_ID = rs5.getInt("enrollmentID");
                int f_semID = rs5.getInt("first_semesterID");
                String e_status = rs5.getString("eStatus");
                int studID = rs5.getInt("studentID");
                
                String profile5 = "enrollmentID: " + e_ID + " first_semesterID: " + f_semID + " eStatus: "
                + e_status + " studentID: " + studID;
                        
                studentProfiles.add(profile5);
            }
            
            rs5.close();
            ps5.close();
            
            
            // INSTRUMENT BORROW // 
            
            ps6 = cn.prepareStatement("SELECT borrowID, b_startDate, b_returnDate, b_dueDate, b_status"
                    + ", instrumentID, studentID FROM MSManSys_db_app.instrumentBorrow WHERE studentID=?");
            
            ps6.setInt(1, studentID);
            rs6 = ps6.executeQuery();
            
            
            while(rs6.next()){
                int b_id = rs6.getInt("borrowID");
                String b_sd = rs6.getString("b_startDate");
                String b_rd = rs6.getString("b_returnDate");
                String b_dd = rs6.getString("b_dueDate");
                String b_stat = rs6.getString("b_status");
                int instruID = rs6.getInt("instrumentID");
                int studID = rs6.getInt("studentID");
                
                String profile6 = "borrowID: " + b_id + " b_startDate: " + b_sd + " b_returnDate: " + b_rd
                + " b_dueDate: " + b_dd + " b_status: " + b_stat + " instrumentID: " + instruID + " studentID: " + studID;
                
                studentProfiles.add(profile6);
            }
            
            rs6.close();
            ps6.close();
            
            
            ps7 = cn.prepareStatement("SELECT paymentrefID, paymentDate, amount, paymentMethod"
                    + ", with_surcharge, sur_amount, studentID FROM MSManSys_db_app.payment WHERE studentID=?");
            
            ps7.setInt(1, studentID);
            rs7 = ps7.executeQuery();

            
            while(rs7.next()){
                int paymentID = rs7.getInt("paymentRefID");
                String paymentD = rs7.getString("paymentDate");
                float amt = rs7.getFloat("amount");
                String paymentM = rs7.getString("paymentMethod");
                String w_s = rs7.getString("with_surcharge");
                float sur_amt = rs7.getFloat("sur_amount");
                int studID = rs7.getInt("studentID");
                
                String profile7 = "paymentRefID: " + paymentID + " paymentDate: " + paymentD +
                        " amount: " + amt + " paymentMethod: " + paymentM + " with_surcharge: " + w_s +
                        " sur_amount: " + sur_amt + " studentID: " + studID;
                
                studentProfiles.add(profile7);
            }
            
            rs7.close();
            ps7.close();
            
            // RETAKER ENTITY //
            
            ps8 = cn.prepareStatement("SELECT retakerID, retakeSem, originalAttempt, attempts, reason"
                    + ", finalGrade, studentID FROM MSManSys_db_app.retaker WHERE studentID=?");
            
            ps8.setInt(1, studentID);
            rs8 = ps8.executeQuery();
            
            while(rs8.next()){
                int r_id = rs8.getInt("retakerID");
                int r_sem = rs8.getInt("retakeSem");
                int o_att = rs8.getInt("originalAttemp");
                int att = rs8.getInt("attempts");
                String r = rs8.getString("reason");
                float f_grade = rs8.getFloat("finalGrade");
                int studID = rs8.getInt("studentID");
                
                String profile8 = "retakerID: " + r_id + " retakeSem: " + r_sem + " originalAttempt: " + o_att + " attempts: "
                + att + " reason: " + r + " finalGrade: " + f_grade + " studentID: " + studID;
                
                studentProfiles.add(profile8);
            }
            
            rs8.close();
            ps8.close();
            
           
           
           // WAITLIST ENTITY //
            
           ps10 = cn.prepareStatement("SELECT waitlistID, e_Date, w_status"
                   + ", studentID, program_id FROM MSManSys_db_app.waitlist WHERE studentID=?");
           
           ps10.setInt(1, studentID);
           rs10 = ps10.executeQuery();
           
           
           while(rs10.next()){
               int w_id = rs10.getInt("waitlistID");
               String e_d = rs10.getString("e_Date");
               String w_s = rs10.getString("w_status");
               int studID = rs10.getInt("studentID");
               int progID = rs10.getInt("program_id");
               
               String profile10 = "waitlistID: " + w_id + " e_Date: " + e_d + " w_status: " 
               + w_s + " studentID: " + studID + " program_id: " + progID;
               
               studentProfiles.add(profile10);
           }
           
           rs10.close();
           ps10.close();
           
           
           
           
           
            cn.close(); // closing the database connection
            
            
            }catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message in case of an exception
               
            }
        return studentProfiles;
    }
    /*
    public static void main(String[] args){
        
        searchStudentProfiles Searchstudentprofiles = new searchStudentProfiles();
        
        Searchstudentprofiles.studentID = 10;
               
        try {
            Searchstudentprofiles.searchStudProf();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    } */
}
