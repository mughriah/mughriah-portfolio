/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package transaction;

/**
 *
 * @author ccslearner
 */
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

public class recordPayment {
   
    public int paymentRefID;
    public int fee_id;
    public int studentID;
    public int semID;
    public int bill_id;
    public int courseID;
    public double sur_amount;
    public String paymentDate;
    public String paymentMethod;
    public String with_surcharge;
  
    
    
    public recordPayment(){
       
        studentID = 0; 
        semID = 0;
        courseID = 0;
        bill_id = 0;
        paymentDate = "";
        fee_id = 0;
        paymentRefID = 0;
        sur_amount = 0;
        paymentMethod = "";
        with_surcharge = "";
    }
    
    public int RecordPayment() throws FileNotFoundException, ClassNotFoundException{
        try{
            Connection cn;
            PreparedStatement ps;
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
            ps = cn.prepareStatement("INSERT INTO MSManSys_db_app.payment (paymentRefID, paymentDate, bill_id, amount,paymentMethod, with_surcharge, sur_amount, studentID) VALUES "
                    + "(?,?,?,?,?,?,?,?)");
            
            ps.setInt(1, paymentRefID);
            ps.setString(2, paymentDate);
            ps.setInt(3, bill_id);
            ps.setDouble(4, calculateTotalAmount());
            ps.setString(5, paymentMethod);
            ps.setString(6, with_surcharge);
            ps.setDouble(7, sur_amount);
            ps.setInt(8, studentID);
            
            
            ps.executeUpdate();
            ps.close();
           
            cn.close();
            return 1;
        } catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message in case of an exception
                return 0; // returning 0 to indicate unsuccessful profile creation
            }
    }
    
    private double calculateTotalAmount(){
            
           try{
               Connection cn;
               PreparedStatement ps, ps2, ps3;
               ResultSet rs, rs2, rs3;
            
               cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
               ps = cn.prepareStatement("SELECT amount FROM MSManSys_db_app.base_fees WHERE semID=?");
               ps.setInt(1, semID);
               rs = ps.executeQuery();
               
               double base_fees = 0.0;
               if(rs.next()){
                   base_fees = rs.getDouble("amount");
               }
               
               rs.close();
               ps.close();
               
               ps2 = cn.prepareStatement("SELECT SUM(tuition_cost) AS total_tuition FROM MSManSys_db_app.course WHERE courseID=?");
               ps2.setInt(1, courseID);
               rs2 = ps2.executeQuery();
               
               double courseTuition = 0.0;
               if(rs2.next()){
                   courseTuition = rs2.getDouble("total_tuition");
               }
               
               rs2.close();
               ps2.close();
               
               ps3 = cn.prepareStatement("SELECT semID FROM MSManSys_db_app.semester_bill WHERE bill_id=?");
               rs3 = ps3.executeQuery();
               
               double TotalBillToPay = base_fees + courseTuition;
               
               rs3.close();
               ps3.close();
               cn.close();
               
               return TotalBillToPay;
               
               
           } catch(SQLException e) {
               System.out.println(e.getMessage());
               return 0.0;
           } 
            
    }
   
    
    public static void main(String[] args){
        recordPayment Recordpayment = new recordPayment();
        
        Recordpayment.paymentDate = "2023-11-15";
        Recordpayment.semID = 9;
        Recordpayment.bill_id = 1009;
        Recordpayment.courseID = 10007;
        Recordpayment.studentID = 9;
        Recordpayment.fee_id = 4019;
        Recordpayment.paymentRefID = 11; 
        Recordpayment.paymentMethod = "Cash";
        Recordpayment.with_surcharge = "No";
        Recordpayment.sur_amount = 0.0;
        
        try {
            Recordpayment.RecordPayment();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    } 
    
}
