/**
* @Author Original: Ranjeet Singh. (502249731) Birlasoft/GEHC
* @Date Original: 30 Sept 2013 Last Modified: 
* @Description: This trigger is used to validate duplicate report & and create Weekly report data & delete related weekly report Data's Comments.
*/
trigger WeeklyReportMasterTrigger on Weekly_Report__c (after delete, after insert, after update,before delete, before insert, before update) {
  
    WeeklyReportHandler WRH = new WeeklyReportHandler();
    
    //Validation for duplicate Weekly report
    if(Trigger.isInsert && Trigger.isbefore) {
          
        /*  Saving the Weekly Report Name + UserName    */
        for(Weekly_Report__c wr:Trigger.New) {
         if(!wr.Is_DataLoad_Source__c){
            if(wr.From_Date__c != null && wr.To_Date__c != null) { 
                String fromDt = String.valueOf(wr.From_Date__c.Year())+'/'+String.valueOf(wr.From_Date__c.Month())+'/'+String.valueOf(wr.From_Date__c.Day());
                
                String toDt = String.valueOf(wr.To_Date__c.Year())+'/'+String.valueOf(wr.To_Date__c.Month())+'/'+String.valueOf(wr.To_Date__c.Day());
                
                wr.Weekly_Report_Name__c = System.Label.Weekly_Report_Name_Prefix+fromDt+' - '+toDt;
            }else if(wr.Report_Date__c != null){
                WRH.validateDuplicateWeeklyReport(Trigger.New);
            }
            wr.Weekly_Report_Name__c = wr.Weekly_Report_Name__c+' - '+UserInfo.getName();
          }  
        }
        
    }
 
 
    //After weekly report create
    if(Trigger.isAfter && Trigger.isInsert){
        WRH.CreateWeeklyReportData(Trigger.New);
    }

    //After delete trigger
    if(Trigger.isBefore && Trigger.isDelete){
        WRH.DeleteWRDRelatedCommnets(Trigger.old);    
    }
   
}