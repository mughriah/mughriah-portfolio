package Payment;

public class BillItem {
    private int itemID;
    private double itemAmount;
    private String itemDesc;

    public int getItemID()
    {
        return this.itemID;
    }
    public void setItemID(int itemID)
    {
        this.itemID = itemID;
    }

    public double getItemAmount()
    {
        return this.itemAmount;
    }

    public void setItemAmount(double itemAmount)
    {
        this.itemAmount = itemAmount;
    }

    public String getItemDesc()
    {
        return this.itemDesc;
    }

    public void setItemDesc(String itemDesc)
    {
        this.itemDesc = itemDesc;
    }
}
