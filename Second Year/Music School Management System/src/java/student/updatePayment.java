/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package transactions;

/**
 *
 * @author ccslearner
 */
import java.io.FileNotFoundException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class updatePayment {
   
    public int studentID;
    public int paymentRefID;
    public double amount;
    public String paymentMethod;
    public String paymentDate;
    public String with_surcharge;
    public double sur_amount;
    
    enum with_surcharge{
        Yes, No
    }
    
    enum paymentMethod{
        Cash, Cheque, Card
    }
    
    
    public updatePayment(){
       
        studentID = 0;
        paymentRefID = 0;
        amount = 0.0;
        paymentMethod = "";
        paymentDate = "";
        with_surcharge = "";
        sur_amount = 0;
        
    }
    
    public int UpdatePayment() throws FileNotFoundException, ClassNotFoundException{
        try{
            Connection cn;
            PreparedStatement ps;
            
            cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true"
                    + "&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            
            ps = cn.prepareStatement("UPDATE MSManSys_db_app.payment SET paymentDate=?, amount = amount + ? + ?"
                    + ", paymentMethod=?, with_surcharge=?, sur_amount=? WHERE paymentRefID=? AND studentID=?");
            
            ps.setString(1, paymentDate);
            ps.setDouble(2, amount);
            ps.setDouble(3, sur_amount);
            ps.setString(4, paymentMethod);
            ps.setString(5, with_surcharge);
            ps.setDouble(6, sur_amount);
            ps.setInt(7, paymentRefID);
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
    
    
    public static void main(String[] args){
        updatePayment Updatepayment = new updatePayment();
        
        Updatepayment.paymentRefID = 1;
        Updatepayment.paymentDate = "2023-11-12";
        Updatepayment.amount = 1000.00;
        Updatepayment.paymentMethod = "Bank";
        Updatepayment.with_surcharge = "Yes";
        Updatepayment.sur_amount = 50.00;
        Updatepayment.studentID = 1;
        
        try {
            Updatepayment.UpdatePayment();
        } catch (FileNotFoundException | ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        
        
    } 
    
}

