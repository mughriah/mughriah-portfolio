package Enrollment;

public class CourseEnrollment {
    private int cEnrollID;
    private int studentID;
    private int courseID;
    private double cGrade;
    private int semID;
    private String status;
    private boolean is_retake;

    public void setCEnroll(int c_enroll_id)
    {
        this.cEnrollID = c_enroll_id;
    }

    public int getCEnroll()
    {
        return this.cEnrollID;
    }

    public void setStudentID(int student_id)
    {
        this.studentID = student_id;
    }

    public int getStudentID()
    {
        return this.studentID;
    }

    public void setCourseID(int course_id)
    {
        this.courseID = course_id;
    }

    public int getCourseID()
    {
        return this.courseID;
    }

    public void setGrade(double grade)
    {
        this.cGrade = grade;
    }

    public double getGrade()
    {
        return this.cGrade;
    }

    public void setSem(int semID)
    {
        this.semID = semID;
    }

    public int getSem()
    {
        return this.semID;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }

    public String getStatus()
    {
        return this.status;
    }

    public void setRetake(boolean is_retake)
    {
        this.is_retake = is_retake;
    }

    public boolean getRetake()
    {
        return this.is_retake;
    }
}
