/**
* @author Original: Reetan Nayak(502268483) Birlasoft/GEHC
* @date Original: 6th Feb 2014
* @description: This Class is used in component to return This Week and Next Week data in Email tempalate.
*/
public class WeekThisNextController {

    public Id WeeklyReportID { get; set; }
    
    public List<Weekly_Report_Data_This_Week__c> WRTW;
    public List<Weekly_Report_Data_Next_Week__c> WRNW;
    
    
    //To return List of This Week data in Email Template
    public list<Weekly_Report_Data_This_Week__c> getWRTW(){
        WRTW = [Select Id, Report_Date__c, Account__r.Name, Opportunity__r.Name, Task_Subject__c, Work_Information__c from Weekly_Report_Data_This_Week__c where Weekly_Report__c=:WeeklyReportID order by Report_Date__c];  
        return WRTW; 
    }
    
    //To return List of Next Week data in Email Template    
     public list<Weekly_Report_Data_Next_Week__c> getWRNW(){
        WRNW = [Select Id, Report_Date__c, Account__r.Name, Opportunity__r.Name, Task_Subject__c, Work_Information__c from Weekly_Report_Data_Next_Week__c where Weekly_Report__c=:WeeklyReportID  order by Report_Date__c];
        return WRNW; 
    }
    

}