public class UB_Outlet_CTRL {

public String SelectOutlet {get; set;}

    public User getOwnerName() {
        User usr = [Select Id, Name from User where Id=:UserInfo.getUserId() ];
        return usr;   
    }
     
    public List<SelectOption> getOutletName() {
        List<SelectOption> lstOutlet = new List<SelectOption>();
        List<Account> lstAccount = [ Select Id, Name, UB_KAM__c from Account where UB_KAM__c=:UserInfo.getUserId() order by Name ];
        
        for(Account acc:lstAccount ) {
            lstOutlet.add(new SelectOption(acc.Id, acc.Name));
        }             
        return lstOutlet;
    }
    
    public List<Account> getOutletTable() {
        List<Account> lstAcc = [ Select Id, Name, UB_KAM__c, Total_Number_Of_Orders__c, Current_Order_Amount__c, Total_Expenditure_In_Events__c, Current_Number_Of_Events__c, 
                Total_Number_Of_Promotions__c, Cost_Incurred_In_Promotions__c, Yearly_Target_for_Branding_Activity__c, Yearly_Target_for_Branding_Activity_Valu__c, 
                Yearly_Target_for_Promotional_Event__c, Yearly_Target_Promotional_Event_Value__c, Yearly_Revenue_Target__c,  Volume_Sales_Target_for_Year__c, 
                Yearly_Activity_Target__c, Days_Since_Activity__c from Account  ];
    
        
                
        return null;
    }              
}