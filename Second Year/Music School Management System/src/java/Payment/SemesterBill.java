package Payment;

import java.util.ArrayList;

public class SemesterBill {
    private int billID;
    private String billDate;
    private double amount;
    private int semID;
    private int studentID;

    private ArrayList<BillItem> fees;
    private ArrayList<BillItem> courses;

    // Constructors
    public SemesterBill() {
        // Default constructor
    }

    public SemesterBill(int billID, String billDate, double amount, int semester, int studentID, ArrayList<BillItem> fees,ArrayList<BillItem> courses) {
        this.billID = billID;
        this.billDate = billDate;
        this.amount = amount;
        this.semID = semester;
        this.studentID = studentID;
        this.fees = fees;
        this.courses = courses;
    }

    // Getters and Setters

    public int getBillID() {
        return billID;
    }

    public void setBillID(int billID) {
        this.billID = billID;
    }

    public String getBillDate() {
        return billDate;
    }

    public void setBillDate(String billDate) {
        this.billDate = billDate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public int getSemester() {
        return semID;
    }

    public void setSemester(int semester) {
        this.semID = semester;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }

    public ArrayList<BillItem> getFees()
    {
        return this.fees;
    }

    public ArrayList<BillItem> getCourses()
    {
        return this.courses;
    }
    public void setFees(ArrayList<BillItem> fees)
    {
        this.fees = fees;
    }
    public void setCourses(ArrayList<BillItem> courses)
    {
        this.courses = courses;
    }

    public double getBillItemTotal(ArrayList<BillItem> billItems)
    {
        double total = 0.0;
        int x, size = billItems.size();

        for(x = 0; x < size; x++)
        {
            total += billItems.get(x).getItemAmount();
        }

        return total;
    }

    
    public double getFullTotal()
    {
        return getBillItemTotal(fees) + getBillItemTotal(courses);
    }

    // toString method for debugging or logging
    @Override
    public String toString() {
        return "SemesterBill{" +
                "billID=" + billID +
                ", billDate='" + billDate + '\'' +
                ", amount=" + amount +
                ", semester='" + semID + '\'' +
                ", studentID=" + studentID +
                '}';
    }
}
