package Enrollment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

public class CourseEnrollmentDAO {
    private static final String JDBC_URL = "jdbc:mysql://localhost:3306/MSManSys_db_app?useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "12345678";
    
    private static final String GET_ALL_ENROLLMENTS = "SELECT * FROM course_enrollment SORT BY semID ASC";
    private static final String GET_NO_ENROLLED_SEMESTER = "SELECT c.courseID, c.courseName, COUNT(e.c_enroll_id) AS 'n_enrolled_semester' FROM course_enrollment e JOIN course c ON e.course_id = c.courseID WHERE e.semID = ? GROUP BY c.courseID, c.courseName ORDER BY c.courseID ASC"; //how many people are/were enrolled in each course during a specific semester
    private static final String GET_CURRENT_SEMESTER_ID = "SELECT semID FROM semester WHERE CURRENT_DATE() BETWEEN semStart AND semEnd";
    private static final String GET_RETAKES = "SELECT * FROM course_enrollment WHERE is_retake = 1";
    private static final String GET_ENROLLMENT_PER_COURSE = "SELECT semID, COUNT(c_enroll_id) AS 'n_enrolled' FROM course_enrollment WHERE course_id = ? GROUP BY semID ORDER BY semID ASC"; //how many people have been enrolled in a specific course each semester
    private static final String GET_ENROLLMENT_PER_DEPARTMENT = "SELECT i.departmentID, COUNT(e.c_enroll_id) AS 'n_enrolled' FROM course c JOIN course_enrollment e ON c.courseID = e.course_id JOIN instructor i ON c.instructorID = i.instructorID WHERE NOT e.status = 'Dropped' GROUP BY i.departmentID ORDER BY i.departmentID ASC";

    public static int getCurrentSemester() {
        int currentSemID = 0;

        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_CURRENT_SEMESTER_ID);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            currentSemID = resultSet.getInt("semID");
             
            resultSet.close();
            preparedStatement.close();
            connection.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return currentSemID;
    }

    public static ArrayList<CourseEnrollment> getAllEnrollments()
    {
        ArrayList<CourseEnrollment> allEnrollments = new ArrayList<CourseEnrollment>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ALL_ENROLLMENTS);
             ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    CourseEnrollment ce = new CourseEnrollment();
                    ce.setCEnroll(resultSet.getInt("c_enroll_id"));
                    ce.setStudentID(resultSet.getInt("student_id"));
                    ce.setCourseID(resultSet.getInt("course_id"));
                    ce.setGrade(resultSet.getDouble("c_grade"));
                    ce.setSem(resultSet.getInt("semID"));
                    ce.setStatus(resultSet.getString("status"));
                    int retake = resultSet.getInt("is_retake");
                    if(retake == 0)
                    {
                        ce.setRetake(false);
                    }
                    else if(retake == 1)
                    {
                        ce.setRetake(true);
                    } 
                    allEnrollments.add(ce);
                }
                resultSet.close();
                preparedStatement.close();
                connection.close();
             }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return allEnrollments;
    }

    public static ArrayList<CourseEnrollment> getRetakes()
    {
        ArrayList<CourseEnrollment> retakes = new ArrayList<CourseEnrollment>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_RETAKES);
             ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    CourseEnrollment ce = new CourseEnrollment();
                    ce.setCEnroll(resultSet.getInt("c_enroll_id"));
                    ce.setStudentID(resultSet.getInt("student_id"));
                    ce.setCourseID(resultSet.getInt("course_id"));
                    ce.setGrade(resultSet.getDouble("c_grade"));
                    ce.setSem(resultSet.getInt("semID"));
                    ce.setStatus(resultSet.getString("status"));
                    ce.setRetake(true);
                    retakes.add(ce);
                }
                resultSet.close();
                preparedStatement.close();
                connection.close();
             }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return retakes;
    }

    public static HashMap<Integer,Integer> getLifetimeEnrollmentPerDepartment()
    {
        HashMap<Integer,Integer> deptEnrollment = new HashMap<Integer,Integer>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_ENROLLMENT_PER_DEPARTMENT);
             ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    int deptID = resultSet.getInt("departmentID");
                    int enrolled = resultSet.getInt("n_enrolled");
                    deptEnrollment.put(deptID, enrolled);
                }
                resultSet.close();
                preparedStatement.close();
                connection.close();
             }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return deptEnrollment;
    }

    public static ArrayList<CourseSemesterStat> getEnrolledCoursesSemester(int semID)
    {
        ArrayList<CourseSemesterStat> semStat = new ArrayList<CourseSemesterStat>();
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD);
             PreparedStatement preparedStatement = connection.prepareStatement(GET_NO_ENROLLED_SEMESTER);) 
             {
                preparedStatement.setInt(1, semID);
                ResultSet resultSet = preparedStatement.executeQuery();

                while(resultSet.next())
                {
                    CourseSemesterStat cs = new CourseSemesterStat();
                    cs.setCourseID(resultSet.getInt("courseID"));
                    cs.setCourseName(resultSet.getString("courseName"));
                    cs.setEnrolled(resultSet.getInt("n_enrolled_semester"));
                    semStat.add(cs);
                    
                }
                resultSet.close();
                preparedStatement.close();
                connection.close();
             }
        catch (SQLException e) {
            e.printStackTrace();
        }
        return semStat;
    }



}
