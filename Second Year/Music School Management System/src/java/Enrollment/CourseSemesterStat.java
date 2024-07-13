package Enrollment;

public class CourseSemesterStat {
    private int courseID;
    private String courseName;
    private int noEnrolled;

    public void setCourseID(int course_ID)
    {
        this.courseID = course_ID;
    }

    public int getCourseID()
    {
        return this.courseID;
    }

    public void setCourseName(String courseName)
    {
        this.courseName = courseName;
    }

    public String getCourseName()
    {
        return this.courseName;
    }

    public void setEnrolled(int enrolled)
    {
        this.noEnrolled = enrolled;
    }

    public int getEnrolled()
    {
        return this.noEnrolled;
    }
}
