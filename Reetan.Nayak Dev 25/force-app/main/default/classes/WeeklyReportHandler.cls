/**
* @Author Original: Ranjeet Singh. (502249731) Birlasoft/GEHC
* @Date Original: 30 Sept 2013 Last Modified: 
* @Description: This class is used to get this week and next week task based on the weekly Report date and create the report.(Week always start from Monday to Stunday)   
*/
public with sharing class WeeklyReportHandler {
   
    public Date thisDate {get;set;}
    public Date thisWeekStart {get;set;}
    public Date thisWeekEnd {get;set;}
    public Date nextWeekStart {get;set;}
    public Date nextWeekEnd {get;set;}
    set<id> wrCreatedUserids = new set<id>();
    public Date FinalStartDate;
    public Date FinalEndDate;
    set<id> WROwnerIds = new set<id>();
    final string ACCOUNT_KEY_PREFIX = '001';
    final string OPPORTUNITY_KEY_PREFIX= '006';
    final string CONTACT_KEY_PREFIX = '003';
    set<Weekly_Report__c> wrSet = new set<Weekly_Report__c>();
       
    // To validate logged-in user and create weekly report
    public void CreateWeeklyReportData(List<Weekly_Report__c> wrList){
      
        User usreDetails = [SELECT id, Sub_Region__c FROM User WHERE id=:Userinfo.getUserId() limit 1];
        if(usreDetails.Sub_Region__c == System.Label.Weekly_Report_Subregion_Name){
            List<Weekly_Report__c> wrCustom = new List<Weekly_Report__c>();
            List<Weekly_Report__c>  wrStandard= new List<Weekly_Report__c>();
            List<Schema.PicklistEntry> JapanPurpose = Event.Japan_Purpose__c.getDescribe().getPicklistValues(); 
            List<Schema.PicklistEntry> JapanDept = Event.Japan_Dept__c.getDescribe().getPicklistValues();
            for(Weekly_Report__c wr:wrList){
                if(wr.Report_Date__c != Null){
                    wrStandard.add(wr);  
                }
                else if(wr.From_Date__c != null && wr.To_Date__c != null){
                    wrCustom.add(wr);    
                }
            }
            if(!wrStandard.isEmpty()){
                CreateWeeklyReportStandardDataForJapan(wrStandard, JapanPurpose, JapanDept); 
            }
            if(!wrCustom.isEmpty()){
                CreateWeeklyReportCustomDataForJapan(wrCustom, JapanPurpose, JapanDept); 
            }
            
        } 
        else if(usreDetails.Sub_Region__c == System.Label.Weekly_Report_Korea_User){
            CreateWeeklyReportDataForKorea(wrList);    
        }
      
    }
    
    
   //Weekly report for Japan
    private void CreateWeeklyReportStandardDataForJapan(List<Weekly_Report__c> wr, List<Schema.PicklistEntry> JapanPurposeValues, List<Schema.PicklistEntry> JapanDeptValues){
      
        set<id> wrCreatedBy =new set<id>();
        date finalStartWeekDate = null;
        date finalEndWeekDate = null;
        Date tempthisWeekStart = null;
        Date tempthisWeekEnd = null;
        Date tempnextWeekEnd = null;
        Date tempnextWeekStart = null;
        list<Weekly_Report_Data_This_Week__c> refWRDTW = new List<Weekly_Report_Data_This_Week__c>();
        list<Weekly_Report_Data_Next_Week__c> refWRDNW = new List<Weekly_Report_Data_Next_Week__c>();
        list<Event> eventlist = new list<Event>();
        
        for(Weekly_Report__c tempWR:wr) {
            //Collect Weekly report owner ids
            wrCreatedBy.add(tempWR.ownerId);
         
            //To find week start date and end date
            Date tempthisDate = tempWR.Report_Date__c;
            DateTime tmpDate = DateTime.newInstance(tempthisDate, Time.newInstance(9,0,0,0));
            String dayName = tmpDate.format('EEEE');
    
            if(dayName.contains('Sun')) {
                tempthisWeekStart = tempthisDate.addDays(-6);
                tempthisWeekEnd   = tempthisDate;
            }
            else {
                tempthisWeekStart = tempthisDate.toStartOfWeek().addDays(1);
                tempthisWeekEnd = tempthisWeekStart.addDays(6);
            }
            
            tempnextWeekStart = tempthisWeekEnd.addDays(1);
            tempnextWeekEnd   = tempnextWeekStart.addDays(6);
               
            if(finalStartWeekDate == null || finalStartWeekDate >= tempthisWeekStart)
                finalStartWeekDate = tempthisWeekStart;
                  
            if(finalEndWeekDate == null || finalEndWeekDate <= tempnextWeekEnd)
                finalEndWeekDate = tempnextWeekEnd;
        } 
      
        //for(Event events:[Select Id, WhoId, WhatId, Subject, OwnerId, Description, ActivityDate, AccountId From Event Where To_Weekly_report__c = true and WhatId <> Null and OwnerId=:wrCreatedBy and ActivityDate >=: finalStartWeekDate and ActivityDate <=: finalEndWeekDate Limit:Limits.getLimitQueryRows()]){
        for(Event events:[Select Id, WhoId, WhatId, Subject, OwnerId, Description, ActivityDate,Japan_Purpose__c,Japan_Visit__c,Japan_Dept__c, AccountId From Event Where (To_Weekly_report__c = true OR WhatId <> Null) and OwnerId=:wrCreatedBy and ActivityDate >=: finalStartWeekDate and ActivityDate <=: finalEndWeekDate Limit:Limits.getLimitQueryRows()])
        {
            eventlist.add(events);
        }
        System.debug('eventlist ---------'+ eventlist);
        
        for(Weekly_Report__c WRlist:wr){
            //To find week start data and end date
            date thisWeekStartvar = null;
            date thisWeekEndvar = null;
            date nextWeekStartvar = null;
            date nextWeekEndvar = null;
            date thisDatevar = WRlist.Report_Date__c;
            DateTime tmpDatevar = DateTime.newInstance(thisDatevar, Time.newInstance(9,0,0,0));
            String dayNamevar = tmpDatevar.format('EEEE');
    
            if(dayNamevar.contains('Sun')) {
               thisWeekStartvar = thisDatevar.addDays(-6);
               thisWeekEndvar   = thisDatevar;
            }
            else {
                thisWeekStartvar = thisDatevar.toStartOfWeek().addDays(1);
                thisWeekEndvar = thisWeekStartvar.addDays(6);
            }
            nextWeekStartvar = thisWeekEndvar.addDays(1);
            nextWeekEndvar = nextWeekStartvar.addDays(6);
        
            for(Event evt:eventlist){
                String tempWhatId = evt.WhatId;
                String tempWhoId = evt.WhoId;
                
                //if(evt.OwnerId == WRlist.OwnerId && evt.WhatId != null && evt.ActivityDate >= thisWeekStartvar && evt.ActivityDate <= thisWeekEndvar){ 
                if(evt.OwnerId == WRlist.OwnerId && evt.ActivityDate >= thisWeekStartvar && evt.ActivityDate <= thisWeekEndvar) {                           
                   
                    Weekly_Report_Data_This_Week__c tempWRDTW = new Weekly_Report_Data_This_Week__c();
                    tempWRDTW.Report_Date__c = evt.ActivityDate;
                    tempWRDTW.Weekly_Report__c = WRlist.id;
                    tempWRDTW.Task_Subject__c = evt.Subject;
                    tempWRDTW.Activity_ID__c = evt.id;

                    if(tempWhatId <> Null && tempWhatId.startsWith(OPPORTUNITY_KEY_PREFIX)){
                        tempWRDTW.Opportunity__c = tempWhatId;    
                    }
                    
                    tempWRDTW.Created_User__c = WRlist.OwnerId;
                    
                    if(tempWhoId <> Null && tempWhoId.startsWith(CONTACT_KEY_PREFIX)){
                        tempWRDTW.Contact__c = tempWhoId; 
                    }
                    
                    if(tempWhatId <> Null && tempWhatId.startsWith(ACCOUNT_KEY_PREFIX)){
                        tempWRDTW.Account__c = tempWhatId;    
                    }
                   
                    // Checking here NULL values
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        evt.Japan_Purpose__c = '';
                    }
                    if(evt.Japan_Visit__c == '' || evt.Japan_Visit__c == null) {
                        evt.Japan_Visit__c = '';
                    }
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        evt.Japan_Dept__c = '';
                    }           
                    if(evt.Description == '' || evt.Description == null) {
                        evt.Description = '';
                    }  
                    
                    //Schema.DescribeFieldResult PurposeValue = Event.Japan_Purpose__c.getDescribe();
                    //List<Schema.PicklistEntry> JapanPurposeValues = PurposeValue.getPicklistValues();
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanPurposeValues) {
                            if(a.getValue() == evt.Japan_Purpose__c){
                                tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+' '+a.getLabel();
                                break;
                            }
                        }
                    }
                    
                    tempWRDTW.Work_Information__c += '\n'+System.Label.Weekly_Report_Place_of_Visit+' '+evt.Japan_Visit__c+'\n';

                    //List<Schema.PicklistEntry> JapanDeptValues = Event.Japan_Dept__c.getDescribe().getPicklistValues();
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        tempWRDTW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanDeptValues) {
                            if(a.getValue() == evt.Japan_Dept__c){
                                tempWRDTW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+' '+a.getLabel();
                                break;
                            }
                        }
                    }
                    
                    tempWRDTW.Work_Information__c += '\n\n'+evt.Description;             
                    
                    // tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c+'.\n'+System.Label.Weekly_Report_Place_of_Visit+evt.Japan_Visit__c+'.\n'+System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c+'.\n\n'+evt.Description;
                    
                    refWRDTW.add(tempWRDTW);
                }
                
                //if(evt.OwnerId == WRlist.OwnerId && evt.WhatId != null && evt.ActivityDate >= nextWeekStartvar && evt.ActivityDate <= nextWeekEndvar){              
                if(evt.OwnerId == WRlist.OwnerId && evt.ActivityDate >= nextWeekStartvar && evt.ActivityDate <= nextWeekEndvar){              
                    Weekly_Report_Data_Next_Week__c tempWRDNW = new Weekly_Report_Data_Next_Week__c();
                    tempWRDNW.Report_Date__c = evt.ActivityDate;
                    tempWRDNW.Weekly_Report__c = WRlist.id;
                    tempWRDNW.Task_Subject__c = evt.Subject;
                    tempWRDNW.Activity_ID__c = evt.id;
                    
                    if(tempWhatId <> Null && tempWhatId.startsWith(ACCOUNT_KEY_PREFIX)){
                        tempWRDNW.Account__c = tempWhatId;
                    }
                    
                    if(tempWhatId <> Null && tempWhatId.startsWith(OPPORTUNITY_KEY_PREFIX)){
                        tempWRDNW.Opportunity__c = tempWhatId;
                    }
                    
                    tempWRDNW.Created_User__c = WRlist.OwnerId; 
                    
                    if(tempWhoId <> Null && tempWhoId.startsWith(CONTACT_KEY_PREFIX)){
                        tempWRDNW.Contact__c = tempWhoId;
                    }
                   
                    // Checking here NULL values
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        evt.Japan_Purpose__c = '';
                    }
                    if(evt.Japan_Visit__c == '' || evt.Japan_Visit__c == null) {
                        evt.Japan_Visit__c = '';
                    }
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        evt.Japan_Dept__c = '';
                    }           
                    if(evt.Description == '' || evt.Description == null) {
                        evt.Description = '';
                    } 

                    //Schema.DescribeFieldResult PurposeValue = Event.Japan_Purpose__c.getDescribe();
                    //List<Schema.PicklistEntry> JapanPurposeValues = PurposeValue.getPicklistValues();
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        tempWRDNW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanPurposeValues) {
                            if(a.getValue() == evt.Japan_Purpose__c){
                                tempWRDNW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+' '+a.getLabel();
                                break;
                            }
                        }
                    }                   

                    tempWRDNW.Work_Information__c += '\n'+System.Label.Weekly_Report_Place_of_Visit+' '+evt.Japan_Visit__c+'\n';

                    //List<Schema.PicklistEntry> JapanDeptValues = Event.Japan_Dept__c.getDescribe().getPicklistValues();
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        tempWRDNW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanDeptValues) {
                            if(a.getValue() == evt.Japan_Dept__c){
                                tempWRDNW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+' '+a.getLabel();
                                break;
                            }
                        }
                    }                   

                    tempWRDNW.Work_Information__c += '\n\n'+evt.Description;
            

                    // tempWRDNW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c+'.\n'+System.Label.Weekly_Report_Place_of_Visit+evt.Japan_Visit__c+'.\n'+System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c+'.\n\n'+evt.Description;
                   
                    refWRDNW.add(tempWRDNW);
                }           
            }
        }
      
        if(refWRDTW.size() > 0){
            insert refWRDTW;
        }

        if(refWRDNW.size() > 0){
            insert refWRDNW;
        }
    }
    
    
    private void CreateWeeklyReportCustomDataForJapan(List<Weekly_Report__c> wr, List<Schema.PicklistEntry> JapanPurposeValues,List<Schema.PicklistEntry> JapanDeptValues){
      
        //Preparing final From Date and To Date format.
        set<id> wrCreatedBy =new set<id>();
        date fromDate = null;
        date toDate = null;
        date wrFinalFromDate = null;
        date wrFinalToDate = null;
        list<Weekly_Report_Data_This_Week__c> refWRDTW = new List<Weekly_Report_Data_This_Week__c>();
        list<Event> eventlist = new list<Event>();
        
        for(Weekly_Report__c tempWR:wr){
        
            //Collect Weekly report owner ids
            wrCreatedBy.add(tempWR.ownerId);

            //To find week start date and end date
            fromDate = tempWR.From_Date__c;
            if(wrFinalFromDate == null || wrFinalFromDate >= fromDate)
            wrFinalFromDate = fromDate;

            toDate = tempWR.To_Date__c;
            if(wrFinalToDate == null || wrFinalToDate <= toDate)
            wrFinalToDate = toDate;
        } 
      
        //for(Event events:[Select Id, WhoId, WhatId, Subject, OwnerId, Description, ActivityDate, AccountId From Event Where To_Weekly_report__c = true and WhatId <> Null and OwnerId=:wrCreatedBy and ActivityDate >=: finalStartWeekDate and ActivityDate <=: finalEndWeekDate Limit:Limits.getLimitQueryRows()]){
        for(Event events:[Select Id, WhoId, WhatId, Subject, OwnerId, Description, ActivityDate,Japan_Purpose__c,Japan_Visit__c,Japan_Dept__c, AccountId From Event Where (To_Weekly_report__c = true OR WhatId <> Null) and OwnerId=:wrCreatedBy and ActivityDate >=: wrFinalFromDate and ActivityDate <=: wrFinalToDate Limit:Limits.getLimitQueryRows()])
        {
            eventlist.add(events);
        } 
      
        for(Weekly_Report__c WRlist:wr){
            date wrFromDate = WRlist.From_Date__c;
            date wrToDate = WRlist.To_Date__c;
            
            for(Event evt:eventlist){
                String tempWhatId = evt.WhatId;
                String tempWhoId = evt.WhoId;
                
                if(evt.OwnerId == WRlist.OwnerId && evt.ActivityDate >= wrFromDate && evt.ActivityDate <= wrToDate){                           
                    Weekly_Report_Data_This_Week__c tempWRDTW = new Weekly_Report_Data_This_Week__c();
                    tempWRDTW.Report_Date__c = evt.ActivityDate;
                    tempWRDTW.Weekly_Report__c = WRlist.id;
                    tempWRDTW.Task_Subject__c = evt.Subject;
                    tempWRDTW.Activity_ID__c = evt.id;
                   
                    if(tempWhatId <> Null && tempWhatId.startsWith(OPPORTUNITY_KEY_PREFIX)){
                      tempWRDTW.Opportunity__c = tempWhatId;    
                    }
                   
                    tempWRDTW.Created_User__c = WRlist.OwnerId;
                    if(tempWhoId <> Null && tempWhoId.startsWith(CONTACT_KEY_PREFIX)){
                        tempWRDTW.Contact__c = tempWhoId; 
                    }
                    
                    if(tempWhatId <> Null && tempWhatId.startsWith(ACCOUNT_KEY_PREFIX)){
                        tempWRDTW.Account__c = tempWhatId;    
                    }
                   
                   
                    // Checking here NULL values
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        evt.Japan_Purpose__c = '';
                    }
                    if(evt.Japan_Visit__c == '' || evt.Japan_Visit__c == null) {
                        evt.Japan_Visit__c = '';
                    }
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        evt.Japan_Dept__c = '';
                    }           
                    if(evt.Description == '' || evt.Description == null) {
                        evt.Description = '';
                    }  
                
                
                    //Schema.DescribeFieldResult PurposeValue = Event.Japan_Purpose__c.getDescribe();
                    //List<Schema.PicklistEntry> JapanPurposeValues = Event.Japan_Purpose__c.getDescribe().getPicklistValues();
                    if(evt.Japan_Purpose__c == '' || evt.Japan_Purpose__c == null) {
                        tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanPurposeValues) {
                            if(a.getValue() == evt.Japan_Purpose__c){
                                tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+' '+a.getLabel();
                                break;
                            }
                        }
                    }

                    tempWRDTW.Work_Information__c += '\n'+System.Label.Weekly_Report_Place_of_Visit+' '+evt.Japan_Visit__c+'\n';

                    //List<Schema.PicklistEntry> JapanDeptValues = Event.Japan_Dept__c.getDescribe().getPicklistValues();
                    if(evt.Japan_Dept__c == '' || evt.Japan_Dept__c == null) {
                        tempWRDTW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c;
                    }
                    else{
                        for (Schema.PicklistEntry a : JapanDeptValues) {
                            if(a.getValue() == evt.Japan_Dept__c){
                                tempWRDTW.Work_Information__c += System.Label.Weekly_Report_Clinical_Department+' '+a.getLabel();
                                break;
                            }
                        }
                    }

                    tempWRDTW.Work_Information__c += '\n\n'+evt.Description;                        
                               
                    // tempWRDTW.Work_Information__c = System.Label.Weekly_Report_Japan_Purpose+evt.Japan_Purpose__c+'.\n'+System.Label.Weekly_Report_Place_of_Visit+evt.Japan_Visit__c+'.\n'+System.Label.Weekly_Report_Clinical_Department+evt.Japan_Dept__c+'.\n\n'+evt.Description;

                    refWRDTW.add(tempWRDTW);
                }
            }   
        }
        if(refWRDTW.size()>0){
            insert refWRDTW;
        } 
    }
   
   
    //Weekly report for Korea
    private void CreateWeeklyReportDataForKorea(List<Weekly_Report__c> wr){
        date finalStartWeekDate = null;
        date finalEndWeekDate = null;
        Date tempthisWeekStart = null;
        Date tempthisWeekEnd = null;
        Date tempnextWeekEnd = null;
        Date tempnextWeekStart = null;
        list<Task> taskList = new list<Task>();
        List<Weekly_Report_Data_This_Week__c> thisWeekReport = new List<Weekly_Report_Data_This_Week__c>();
        List<Weekly_Report_Data_Next_Week__c> nextWeekReport = new List<Weekly_Report_Data_Next_Week__c>();
        
        //User creates weekly report from UI.if record created through dataloader or any other tools then following report date assignment must be bulkified.
        for(Weekly_Report__c tempWR:wr){
         
            wrCreatedUserids.add(tempWR.OwnerId);

            //To find week start data and end date
            Date tempthisDate = tempWR.Report_Date__c;
            DateTime tmpDate = DateTime.newInstance(tempthisDate, Time.newInstance(9,0,0,0));
            String dayName = tmpDate.format('EEEE');

            if(dayName.contains('Sun')) {
                tempthisWeekStart = tempthisDate.addDays(-6);
                tempthisWeekEnd   = tempthisDate;
            }
            else {
                tempthisWeekStart = tempthisDate.toStartOfWeek().addDays(1);
                tempthisWeekEnd = tempthisWeekStart.addDays(6);
            }
            tempnextWeekStart = tempthisWeekEnd.addDays(1);
            tempnextWeekEnd   = tempnextWeekStart.addDays(6);

            if(finalStartWeekDate == null || finalStartWeekDate >= tempthisWeekStart)
                finalStartWeekDate = tempthisWeekStart;
              
            if(finalEndWeekDate == null || finalEndWeekDate <= tempnextWeekEnd)
                finalEndWeekDate = tempnextWeekEnd;  
        }
      
        //To get all This week & Next week task
        for(Task tsk:[SELECT Id, Owner.Name, OwnerId, ActivityDate, Subject,WhatId, AccountId, What.Name, Description, WhoId FROM Task
                         WHERE To_Weekly_report__c = true AND OwnerId=:wrCreatedUserids AND ActivityDate >= :finalStartWeekDate AND ActivityDate <= :finalEndWeekDate Limit:Limits.getLimitQueryRows()]){
            taskList.add(tsk);
        }
      
      
        for(Weekly_Report__c WReport:wr){
            //To find week start data and end date
            date thisWeekStartvar = null;
            date thisWeekEndvar = null;
            date nextWeekStartvar = null;
            date nextWeekEndvar = null;
            date thisDatevar = WReport.Report_Date__c;
            DateTime tmpDatevar = DateTime.newInstance(thisDatevar, Time.newInstance(9,0,0,0));
            String dayNamevar = tmpDatevar.format('EEEE');
    
            if(dayNamevar.contains('Sun')) {
               thisWeekStartvar = thisDatevar.addDays(-6);
               thisWeekEndvar   = thisDatevar;
            }
            else {
                thisWeekStartvar = thisDatevar.toStartOfWeek().addDays(1);
                thisWeekEndvar = thisWeekStartvar.addDays(6);
            }
            nextWeekStartvar = thisWeekEndvar.addDays(1);
            nextWeekEndvar = nextWeekStartvar.addDays(6);
        
            for(Task tempTask:taskList){
                if(tempTask.OwnerId == WReport.OwnerId && tempTask.ActivityDate >= thisWeekStartvar && tempTask.ActivityDate <= thisWeekEndvar ){
                    Weekly_Report_Data_This_Week__c tempthisWeekReport = new Weekly_Report_Data_This_Week__c();
                    if(tempTask.AccountId != Null){
                        tempthisWeekReport.Account__c =  tempTask.AccountId;
                    }
                    tempthisWeekReport.Contact__c = tempTask.whoid;
                    tempthisWeekReport.Report_Date__c = tempTask.ActivityDate;
                    tempthisWeekReport.Week_Gubun__c = 'This Week';
                    tempthisWeekReport.Work_Information__c = tempTask.Description;
                    tempthisWeekReport.Weekly_Report__c = WReport.id;
                    tempthisWeekReport.Created_User__c = WReport.OwnerId;
                    tempthisWeekReport.Activity_ID__c = tempTask.id;
                    tempthisWeekReport.Task_Subject__c = tempTask.Subject;
                    thisWeekReport.add(tempthisWeekReport);
                } 
                
                if(tempTask.OwnerId == WReport.OwnerId && tempTask.ActivityDate >= nextWeekStartvar && tempTask.ActivityDate <= nextWeekEndvar ){
                    Weekly_Report_Data_Next_Week__c tempNextWeekReport = new Weekly_Report_Data_Next_Week__c();
                    if(tempTask.AccountId != Null){
                        tempNextWeekReport.Account__c =  tempTask.AccountId;
                    }
                    tempNextWeekReport.Contact__c = tempTask.whoid;
                    tempNextWeekReport.Report_Date__c = tempTask.ActivityDate;
                    tempNextWeekReport.Week_Gubun__c = 'Next Week';
                    tempNextWeekReport.Work_Information__c = tempTask.Description;
                    tempNextWeekReport.Weekly_Report__c = WReport.id;
                    tempNextWeekReport.Created_User__c = WReport.OwnerId;
                    tempNextWeekReport.Activity_ID__c = tempTask.id;
                    tempNextWeekReport.Task_Subject__c = tempTask.Subject;
                    nextWeekReport.add(tempNextWeekReport);
                }  
            }       
        }
        if(thisWeekReport.size()> 0){
            insert thisWeekReport;
        }  

        if(nextWeekReport.size() > 0){
            insert nextWeekReport;
        } 
    }
   
   
    // @@@@@ To Set The Current week start/End Date & next Week Start/End Date.
    public void CaluaratorDate(Date thisDate) {
        DateTime tmpDate = DateTime.newInstance(thisDate, Time.newInstance(9,0,0,0));
        String dayName = tmpDate.format('EEEE');

        if(dayName.contains('Sun')) {
            thisWeekStart = thisDate.addDays(-6);
            thisWeekEnd   = thisDate;
        } else {
            thisWeekStart = thisDate.toStartOfWeek().addDays(1);
            thisWeekEnd = thisWeekStart.addDays(6);
        }
        nextWeekStart = thisWeekEnd.addDays(1);
        nextWeekEnd   = nextWeekStart.addDays(6);
    }
    
    
    //To prevent duplicate weekly report.
    public void validateDuplicateWeeklyReport(List<Weekly_Report__c> newWr){
        for(Weekly_Report__c wr: newWr){
            date thisDate = wr.Report_Date__c;
            DateTime tmpDate = DateTime.newInstance(thisDate, Time.newInstance(9,0,0,0));
            String dayName = tmpDate.format('EEEE');

            if(dayName.contains('Sun')) {
                thisWeekStart = thisDate.addDays(-6);
                thisWeekEnd   = thisDate;
            }
            else {
                thisWeekStart = thisDate.toStartOfWeek().addDays(1);
                thisWeekEnd = thisWeekStart.addDays(6);
            }
           
            if(FinalStartDate == null || FinalStartDate >= thisWeekStart)
                FinalStartDate = thisWeekStart;
              
            if(FinalEndDate==null || FinalEndDate<=thisWeekEnd)
                FinalEndDate=thisWeekEnd;
            WROwnerIds.add(wr.ownerId);
        }
        
        for(Weekly_Report__c wrRef:[Select Name, Id, Report_Group__c, Report_Date__c, OwnerId From Weekly_Report__c 
                                    WHERE OwnerId=:WROwnerIds 
                                    AND Report_Date__c >= :FinalStartDate
                                    AND Report_Date__c <= :FinalEndDate Limit:Limits.getLimitQueryRows()])  {
            
            System.debug('@@@@@@'+wrRef);    
            
            for(Weekly_Report__c tempwr:newWr){
                Date tempthisWeekStart = null;
                Date tempthisWeekEnd = null;
                Date tempThisDate = tempwr.Report_Date__c;
              
                DateTime tmpDate = DateTime.newInstance(tempThisDate, Time.newInstance(9,0,0,0));
                String dayName = tmpDate.format('EEEE');

                if(dayName.contains('Sun')) {
                    tempthisWeekStart = tempThisDate.addDays(-6);
                    tempthisWeekEnd   = tempThisDate;
                }
                else {
                    tempthisWeekStart = tempThisDate.toStartOfWeek().addDays(1);
                    tempthisWeekEnd = tempthisWeekStart.addDays(6);
                }
                System.debug('Start Date:'+tempthisWeekStart+'End Date:'+tempthisWeekEnd);
                if(wrRef.ownerId==tempwr.ownerId && wrRef.Report_Date__c >=tempthisWeekStart && wrRef.Report_Date__c<=tempthisWeekEnd){
                    System.debug('@@@@@@Error'+tempwr+'&&&&'+wrRef);
                    
                    if(!Test.isRunningTest())
                        tempwr.addError(System.label.Weekly_Report_Duplicate_Error_Message); 
                } 
            }
        }
    
    }
    
    
    // @@@@@ To delete weekly report data related comments
    public void DeleteWRDRelatedCommnets(List<Weekly_Report__c> wrlist){
        System.debug('Weekly Report:'+wrlist);
        set<id> WRDTWIds = new set<id>();
        set<id> WRDNWIds = new set<id>();
        set<id> wrids = new set<id>();
        
        for(Weekly_Report__c wr:wrlist){
            wrids.add(wr.id);
        }
        
        for(Weekly_Report_Data_This_Week__c WRDTW:[SELECT id, Name FROM Weekly_Report_Data_This_Week__c WHERE Weekly_Report__c=:wrids Limit:Limits.getLimitQueryRows()]){
            WRDTWIds.add(WRDTW.id);
        }
       
        for(Weekly_Report_Data_Next_Week__c WRDNW:[SELECT id, Name FROM Weekly_Report_Data_Next_Week__c WHERE Weekly_Report__c=:wrids Limit:Limits.getLimitQueryRows()]){
            WRDNWIds.add(WRDNW.id);
        }
       
        List<Weekly_Report_Comment__c> wrComment = new List<Weekly_Report_Comment__c>();
        for(Weekly_Report_Comment__c wrc:[SELECT id, Name from Weekly_Report_Comment__c WHERE Weekly_Report_Data_This_Week__c =:WRDTWIds OR Weekly_Report_Data_Next_Week__c =: WRDNWIds Limit:Limits.getLimitQueryRows()]) {
            System.debug('Comments:'+wrc);
            wrComment.add(wrc);   
        }    
        
        System.debug('@@@Deleted Related Comment:'+wrComment);
        
        if(wrComment.size()>0){
            System.debug('@@@@ Comment Deleted Successfully');
            delete wrComment;  
        }
    }
    
}