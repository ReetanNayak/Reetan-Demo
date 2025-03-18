public class UB_Sales_CLS {

//public string usr;
public decimal BudgetTarget {get; set;}
public decimal BudgetAchieved {get; set;}
public integer HistoryCount{get; set;}
public Integer UBOrderVolumeSales {get; set;}
public Account Outlet {get;set;}
public Boolean showKAM {get; set;}
public String KeyAccMetric_name {get;set;}
public List<AggregateResult> lstUbSalesOrder {get; set;}
public string totalUBSales {get; set;}

   /* public user getusername() {
      user usr= [SELECT id, Name FROM User WHERE id =: UserInfo.getUserid()];
        return usr;
    }*/
     
    public List<SelectOption> getItems() {
        List<Account> lstacc = [SELECT Name FROM Account WHERE UB_KAM__c =: UserInfo.getUserid()];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '-Select-'));
        for(integer i=0; i<lstacc.size(); i++) {
            options.add(new SelectOption(lstacc[i].Id,lstacc[i].Name));
        }
        return options;
    }
        
    public List<Account> getOutletDetails() {
               
        showKAM = true;             
        List<Account> Outletdet = new List<Account>();
        Outletdet = [SELECT  Yearly_Revenue_Target__c, Current_Order_Amount__c, Volume_Sales_Target_for_Year__c, Total_Number_Of_Orders__c, Current_Number_Of_Events__c, Yearly_Target_for_Branding_Activity__c, Yearly_Target_for_Promotional_Event__c, Total_Number_Of_Promotions__c, Yearly_Target_for_Branding_Activity_Valu__c, Total_Expenditure_In_Events__c, Cost_Incurred_In_Promotions__c, Yearly_Target_Promotional_Event_Value__c,  Yearly_Activity_Target__c FROM Account WHERE ID =: KeyAccMetric_name]; 
        
        for(Integer j=0; j<Outletdet.size(); j++) {         
            BudgetTarget = Outletdet[j].Yearly_Target_for_Branding_Activity_Valu__c + Outletdet[j].Yearly_Target_Promotional_Event_Value__c;
        }       
        
        for(Integer k=0; k<Outletdet.size(); k++) { 
            BudgetAchieved = Outletdet[k].Total_Expenditure_In_Events__c + Outletdet[k].Cost_Incurred_In_Promotions__c;  
        }      

        List<AccountHistory> Acchstr = new List<AccountHistory>();
            Acchstr = [SELECT Account.Name, Account.UB_KAM__c FROM AccountHistory WHERE account.id =: KeyAccMetric_name AND Account.UB_KAM__c =:UserInfo.getUserid()];
            
            HistoryCount = Acchstr.size();
            
        lstUbSalesOrder = [SELECT SUM(Volume_Sale__c)sv FROM UB_Order__c where UB_Outlet__c =:KeyAccMetric_name ];            
            System.debug('SUM Value=========================>>>>>>.'+lstUbSalesOrder);
        if(lstUbSalesOrder.size()>0){
            totalUBSales = string.Valueof(lstUbSalesOrder[0].get('sv'));
        }
         
        return Outletdet;                 
    }
        
}