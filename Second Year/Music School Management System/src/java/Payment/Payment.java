package Payment;

public class Payment {

    private int paymentRefID;
    private String paymentDate;
    private double amount;
    private String paymentMethod;
    private String withSurcharge;
    private double surchargeAmount;
    private int studentID;
    private int semID;


    // Getters and setters for the attributes

    public int getPaymentRefID() {
        return paymentRefID;
    }

    public void setPaymentRefID(int paymentRefID) {
        this.paymentRefID = paymentRefID;
    }

    public String getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(String paymentDate) {
        this.paymentDate = paymentDate;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getWithSurcharge() {
        return withSurcharge;
    }

    public void setWithSurcharge(String withSurcharge) {
        this.withSurcharge = withSurcharge;
    }

    public double getSurchargeAmount() {
        return surchargeAmount;
    }

    public void setSurchargeAmount(double surchargeAmount) {
        this.surchargeAmount = surchargeAmount;
    }

    public int getStudentID() {
        return studentID;
    }

    public void setStudentID(int studentID) {
        this.studentID = studentID;
    }
    
     public int getSemester() {
        return semID;
    }

    public void setSemester(int sem) {
        this.semID = sem;
    }
}
