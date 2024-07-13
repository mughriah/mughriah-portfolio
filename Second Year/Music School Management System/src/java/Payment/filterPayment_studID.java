/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Payment;

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

public class filterPayment_studID {
    public int studentID;
    
    public filterPayment_studID(){
        studentID = 0;           
    
    }
    
    public void setStudentID(int studentID){
        this.studentID = studentID;
    }
    
     public List<String> filterPayment() throws FileNotFoundException, ClassNotFoundException{
        List<String> paymentDetails = new ArrayList<>();
        try{
            
            // establishing a database connection
            Connection cn;
            PreparedStatement ps;
            ResultSet rs;
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
           
            ps = cn.prepareStatement("SELECT paymentRefID, paymentDate, bill_id, amount, paymentMethod, studentID FROM MSManSys_db_app.payment WHERE studentID=?");


            // setting parameters for the prepared statement
            ps.setInt(1, studentID);
            
            rs  = ps.executeQuery();
            
           
            
            while(rs.next()){
                int paymentID = rs.getInt("paymentRefID");
                String paymentD = rs.getString("paymentDate");
                int b_id = rs.getInt("bill_id");
                double amt = rs.getDouble("amount");
                String paymentM = rs.getString("paymentMethod");
                int studID = rs.getInt("studentID");

                
               String payment = "paymentID: " + paymentID + "paymentDate: " + paymentD + "bill_id: " + b_id
                       + "amount: " + amt + "paymentMethod: " + paymentM + "studentID: " + studID;
               
               
                paymentDetails.add(payment);
               
            }
            rs.close();
            ps.close(); // closing the prepared statement
            cn.close(); // closing the database connection
            
            
            }catch(SQLException e){
                System.out.println(e.getMessage()); // printing the error message in case of an exception
                
                
            }
        return paymentDetails;
    }
}
