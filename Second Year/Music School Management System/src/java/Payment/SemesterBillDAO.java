package Payment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class SemesterBillDAO {

    // JDBC connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "12345678";

    // SQL statements
    private static final String SELECT_BILLS = "SELECT b.*, CONCAT(p.lastName,', ',p.firstname) AS 'studentName',s.semStart,s.semEnd FROM semester_bill b JOIN studentProfiles p ON b.studentID = p.studentID " +
            "JOIN semester s ON b.semID = s.semID " +
            "ORDER BY s.semStart ASC ";
    private static final String GET_ALL_SEMESTERS = "SELECT semID FROM semester";
    private static final String GET_SEMESTER_FEES = "SELECT *" + 
            " FROM base_fees" + 
            " WHERE semID = ?";
    private static final String GET_STUDENT_SEMESTER_TUITION = "SELECT c.courseID, c.tuition_cost, c.courseName " +
            "FROM course c JOIN course_enrollment e " +
            "ON c.courseID = e.course_id " +
            "WHERE e.semID = ? AND student_id = ?";
    private static final String FILTERED_SEMESTER_BILL_HISTORY = "SELECT * FROM semester_bill WHERE semester = ? AND studentID = ? AND DATE_FORMAT(billDate, '%Y-%m') = ?";

    public static ArrayList<Integer> getAllSemesters() {
        ArrayList<Integer> semesters = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_SEMESTERS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                int semID = resultSet.getInt("semID");
                semesters.add(semID);
            }
            resultSet.close();
            preparedStatement.close();
            connection.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return semesters;
    }

    public static ArrayList<SemesterBill> getAllBills() {
        ArrayList<SemesterBill> bills = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_BILLS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                SemesterBill bill = new SemesterBill();
                bill.setBillID(resultSet.getInt("bill_id"));
                bill.setSemester(resultSet.getInt("semID"));
                bill.setStudentID(resultSet.getInt("studentID"));

                bills.add(bill);
            }
            resultSet.close();
            preparedStatement.close();
            connection.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bills;
    }

    public static ArrayList<BillItem> getSemesterFees(int semID)
    {
        ArrayList<BillItem> fees = new ArrayList<BillItem>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_SEMESTER_FEES);) 
             {
                preparedStatement.setInt(1, semID);
                try(ResultSet resultSet = preparedStatement.executeQuery())
                {
                    while (resultSet.next()) {
                        BillItem item = new BillItem();
                        item.setItemID(resultSet.getInt("fee_id"));
                        item.setItemAmount(resultSet.getDouble("amount"));
                        item.setItemDesc(resultSet.getString("fee_desc"));
                        fees.add(item);
                    }
                    resultSet.close();
                    preparedStatement.close();
                }
                
                connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fees;
    }

    public static ArrayList<BillItem> getSemesterCourses(int semID,int studentID)
    {
        ArrayList<BillItem> courses = new ArrayList<BillItem>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_STUDENT_SEMESTER_TUITION);) 
             {
                preparedStatement.setInt(1, semID);
                preparedStatement.setInt(2,studentID);
                try(ResultSet resultSet = preparedStatement.executeQuery())
                {
                    while (resultSet.next()) {
                        BillItem item = new BillItem();
                        item.setItemID(resultSet.getInt("courseID"));
                        item.setItemAmount(resultSet.getDouble("tuition_cost"));
                        item.setItemDesc(resultSet.getString("courseName"));
                    }
                }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return courses;
    }

    public static SemesterBill getBillDetails(SemesterBill bill)
    {
        SemesterBill updatedBill = bill;
        updatedBill.setFees(getSemesterFees(updatedBill.getSemester()));
        updatedBill.setCourses(getSemesterCourses(updatedBill.getSemester(), updatedBill.getStudentID()));
        return updatedBill;
    }
}
