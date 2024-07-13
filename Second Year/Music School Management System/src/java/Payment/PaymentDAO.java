package Payment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

/**
 *
 * @author Dana
 */
public class PaymentDAO {

    // JDBC connection parameters
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "12345678";

    // SQL statements
    private static final String SELECT_PAYMENTS = "SELECT p.*, b.semID FROM payment p JOIN semester_bill b ON p.bill_id = b.bill_id ORDER BY b.semID DESC";
    private static final String FILTER_BY_SEMESTER = "SELECT * FROM payment p JOIN semester_bill b ON p.bill_id = b.bill_id WHERE b.semID = ?";
    private static final String FILTER_BY_STUDENT_ID = "SELECT * FROM payment WHERE studentID = ?";
    private static final String FILTER_BY_STUDENT_ID_AND_SEMESTER = "SELECT * FROM payment WHERE studentID = ? AND semID = ?";
    private static final String GET_ALL_SEMESTERS = "SELECT * FROM semester ORDER BY semStart ASC";
    //private static final String GET_ALL_SEMESTER_NAMES = "SELECT semesterName FROM semesters";

   /* public static ArrayList<String> getAllSemesterNames() {
        ArrayList<String> semesters = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_SEMESTER_NAMES);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                String semesterName = resultSet.getString("semesterName");
                semesters.add(semesterName);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return semesters;
    }
    public static ArrayList<String> getAllDepartmentNames() {
        ArrayList<String> departmentNames = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_DEPARTMENT_NAMES);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                departmentNames.add(resultSet.getString("departmentName"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return departmentNames;
    } */

    public static ArrayList<Integer> getAllSemesters() {
        ArrayList<Integer> semesters = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_SEMESTERS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                int semID = resultSet.getInt("semID");
                semesters.add(semID);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return semesters;
    }

    public static ArrayList<Payment> getAllPayments() {
        ArrayList<Payment> payments = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_PAYMENTS);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Payment payment = new Payment();
                payment.setPaymentRefID(resultSet.getInt("paymentRefID"));
                payment.setPaymentDate(resultSet.getString("paymentDate"));
                payment.setAmount(resultSet.getDouble("amount"));
                payment.setPaymentMethod(resultSet.getString("paymentMethod"));
                payment.setWithSurcharge(resultSet.getString("with_surcharge"));
                payment.setSurchargeAmount(resultSet.getDouble("sur_amount"));
                payment.setStudentID(resultSet.getInt("studentID"));
                payment.setSemester(resultSet.getInt("semID"));
                payments.add(payment);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

    // Method to get payments filtered by semester
    public static ArrayList<Payment> getPaymentsBySemester(String semester) {
        ArrayList<Payment> payments = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(FILTER_BY_SEMESTER)) {

            preparedStatement.setString(1, semester);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    Payment payment = new Payment();
                    // Populate payment object
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }


    // Method to get payments filtered by student ID
    public static ArrayList<Payment> getPaymentsByStudentId(int studentId) {
        ArrayList<Payment> payments = new ArrayList<>();

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(FILTER_BY_STUDENT_ID)) {

            preparedStatement.setInt(1, studentId);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    Payment payment = new Payment();
                    // Populate payment object
                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }
    
    // Method to get filtered payment history based on multiple parameters
    public static ArrayList<Payment> getFilteredPaymentHistory(String selectedSemester, int studentId, String selectedPaymentMonthYear) {
        ArrayList<Payment> payments = new ArrayList<>();

        // Construct the SQL query based on the provided filters
        String sql = "SELECT * FROM payment WHERE 1=1";
        List<Object> params = new ArrayList<>();

        if (selectedSemester != null && !selectedSemester.isEmpty()) {
            sql += " AND semester = ?";
            params.add(selectedSemester);
        }

        if (studentId > 0) {
            sql += " AND studentID = ?";
            params.add(studentId);
        }

        if (selectedPaymentMonthYear != null && !selectedPaymentMonthYear.isEmpty()) {
            // Assuming the date is stored in 'paymentDate' column as 'yyyy-MM-dd'
            sql += " AND DATE_FORMAT(paymentDate, '%Y-%m') = ?";
            params.add(selectedPaymentMonthYear);
        }

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            // Set parameters
            int paramIndex = 1;
            for (Object param : params) {
                preparedStatement.setObject(paramIndex++, param);
            }

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    Payment payment = new Payment();
                    payment.setPaymentRefID(resultSet.getInt("paymentRefID"));
                    payment.setPaymentDate(resultSet.getString("paymentDate"));
                    payment.setAmount(resultSet.getDouble("amount"));
                    payment.setPaymentMethod(resultSet.getString("paymentMethod"));
                    payment.setWithSurcharge(resultSet.getString("with_surcharge"));
                    payment.setSurchargeAmount(resultSet.getDouble("sur_amount"));
                    payment.setStudentID(resultSet.getInt("studentID"));

                    payments.add(payment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return payments;
    }

}