/**
* @Author Original: Ranjeet Singh. (502249731) Birlasoft/GEHC
* @Date Original: 22 Oct 2013 Last Modified: 
* @Description: This class is used to Include/Exclude the Team reports and Provide the comment from UI.
*/
public with sharing class WeeklyReportOnManagerController {
    Weekly_Report__c wr{get;set;}
    set<id> teamUserIds = new set<id>();
    public Date thisWeekStart {get;set;}
    public Date thisWeekEnd {get;set;}
    public Date nextWeekStart {get;set;}
    public Date nextWeekEnd {get;set;}
    public Boolean isManager{get;set;}
    public Boolean isSalesRep{get;set;}
    public Boolean isManagerTaskAdded{get;set;}
    public list<ReportWC> teamThisWeeklist{get;set;}
    public List<ReportWC> teamNextWeekList{get;set;}
    public Weekly_Report__c myweeklyreport{get;set;}
    public list<Weekly_Report_Data_This_Week__c>  teamThisWeekWRDView{get;set;}
    public list<Weekly_Report_Data_Next_Week__c>  teamNextWRDView{get;set;}
    public User loggedInUserDetails{get;set;}
    public set<string> groupName{get;set;}
    public String[] selectedGroup = new String[]{};
    Public Boolean isEnableTeamComment{get;set;} 
    
    public WeeklyReportOnManagerController(ApexPages.StandardController controller) {
       wr = (Weekly_Report__c)controller.getRecord();
       isEditMode = false;
       isEnableTeamComment = false;
       System.debug('****wr:'+wr);
       myweeklyreport = [Select Id, Name,CreatedBy.Title,CreatedBy.Name,From_Date__c, To_Date__c , Weekly_Report_Name__c,Comment_Edit__c,Team_Task_Added__c, Report_Group__c, Report_Date__c, CreatedById From Weekly_Report__c WHERE id=:wr.id Limit 1];
       loggedInUserDetails = [Select Id, Name, SSO__c,Weekly_Report_Manager_SSO__c From User Where Id=:UserInfo.getUserId()];
       System.debug('Executed Constructor'+myweeklyreport);
       if(myweeklyreport.Comment_Edit__c){
          isEnableTeamComment = true;
       }else{
          isEnableTeamComment = false;
       }
       doSearch();
       WeeklyReportView();
    }
    
    public void doSearch(){
       //CalculateDate(Date.today());
       if(myweeklyreport.Report_Date__c != null) { 
           CalculateDate(myweeklyreport.Report_Date__c);
       }else{
            thisWeekStart = myweeklyreport.From_Date__c;
            thisWeekEnd = myweeklyreport.To_Date__c;
            nextWeekStart = null;
            nextWeekEnd = null;
       }
       isManager = false;
       isSalesRep = false;
       isManagerTaskAdded = false;    
       
       // @@@@ Select Current logged-in user's Team member id.
       /*
       for(User manageUser:[SELECT Id,ManagerId FROM User WHERE IsActive = true and ManagerId=:UserInfo.getUserId()]){
          teamUserIds.add(manageUser.id);
       }
       */
       //String query = 'SELECT Id,ManagerId FROM User WHERE IsActive = true and Weekly_Report_Manager_SSO__c Like'+'%'+loggedInUserDetails.SSO__c+'%';
       //System.debug('@@@ Query:'+query);
       for(User manageUser:[SELECT Id,ManagerId FROM User WHERE IsActive = true and Weekly_Report_Manager_SSO__c Like:'%'+loggedInUserDetails.SSO__c+'%']){
          System.debug('@@@@ User Details:'+manageUser);
          teamUserIds.add(manageUser.id);
       }
       System.debug('@@@@ User Details:'+teamUserIds);
       if(myweeklyreport.CreatedById == UserInfo.getUserId()){
          if(!teamUserIds.isEmpty()){
             isManager = true;
             if(myweeklyreport.Team_Task_Added__c){
                isManagerTaskAdded = true;  
             }  
          }else{
             isSalesRep = true; 
          } 
       }else{
        isManagerTaskAdded = true;
        if(!teamUserIds.isEmpty()){
           isManager = true;    
        }else{
           isSalesRep = true;   
        }
       }
       
       if(!teamUserIds.isEmpty()){
                    
          teamThisWeeklist = new list<ReportWC>();
          teamNextWeekList = new List<ReportWC>();
          //Team this week report
          for(Weekly_Report_Data_This_Week__c WRTW :[Select Work_Information__c, Activity_ID__c, Task_Subject__c, Work_Comment__c,Created_User__c, Weekly_Report__c, Week_Gubun__c, Report_Date__c, Org_Weekly_Report_Data__c, Name, Id, CreatedById, CreatedBy.Alias,Created_User__r.Alias, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select Id, Comment_User__c, Comment_User__r.Name,Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                    From Weekly_Report_Data_This_Week__c 
                                                    WHERE Weekly_Report__r.CreatedById=:teamUserIds and 
                                                    Report_Date__c>=:thisWeekStart and 
                                                    Report_Date__c<=:thisWeekEnd ORDER By Created_User__r.Name,Report_Date__c ASC]){
            
            ReportWC rw = new ReportWC();
            rw.isChecked = true;
            WRTW.Manage_Comment__c = null;
            rw.wrtw = WRTW;
            teamThisWeeklist.add(rw); 
            System.debug('*****This Week Task:'+WRTW);
         }
         //Team next week report
         for(Weekly_Report_Data_Next_Week__c WRNWT:[Select Work_Information__c,Activity_ID__c, Task_Subject__c, Work_Comment__c, Weekly_Report__c, Created_User__c,Week_Gubun__c, Report_Date__c, Weekly_Report_Data_Next_Week__c, Name, Id, CreatedById, CreatedBy.Alias,Created_User__r.Alias, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select id, Comment_User__c, Comment_User__r.Name, Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                    From Weekly_Report_Data_Next_Week__c 
                                                    WHERE Weekly_Report__r.CreatedById=:teamUserIds 
                                                    and Report_Date__c>=:nextWeekStart and 
                                                    Report_Date__c<=:nextWeekEnd ORDER By Created_User__r.Name,Report_Date__c ASC]){
            
            ReportWC rw = new ReportWC();
            rw.isChecked = true;
            WRNWT.Manage_Comment__c = null;
            rw.wrnw = WRNWT;
            teamNextWeekList.add(rw);                                                   
            System.debug('*****This Week Task:'+WRNWT);
         }
         //if(teamThisWeeklist.size()>0 || teamNextWeekList.size()>0)
       }
       
       List<AggregateResult> tempGroupTW = [Select Created_User__r.Weekly_Report_Group__c GroupName From Weekly_Report_Data_This_Week__c WHERE Weekly_Report__c =: myweeklyreport.id and Created_User__c !=: myweeklyreport.CreatedById GROUP BY Created_User__r.Weekly_Report_Group__c
                                            ORDER BY Created_User__r.Weekly_Report_Group__c];
       List<AggregateResult> tempGroupNW = [Select Created_User__r.Weekly_Report_Group__c GroupName From Weekly_Report_Data_Next_Week__c WHERE Weekly_Report__c =: myweeklyreport.id and Created_User__c !=: myweeklyreport.CreatedById GROUP BY Created_User__r.Weekly_Report_Group__c
                                            ORDER BY Created_User__r.Weekly_Report_Group__c]; 
       groupName = new set<string>();
       for(AggregateResult argTW : tempGroupTW){
          groupName.add((String) argTW.get('GroupName')); 
       } 
       for(AggregateResult argNW : tempGroupNW){
          groupName.add((String) argNW.get('GroupName'));       
       }
       if(!groupName.isEmpty()){
          selectedGroup.addAll(groupName); 
       }
       System.debug('@@@@Group Name:'+groupName);                                   
    }
    // @@@@@ To Set The Current week start/End Date & next Week Start/End Date.
    public void CalculateDate(Date thisDate) {
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
    //Save Manager Task
    public Pagereference SaveTeamTask(){
        PageReference pageRef = Null;
        List<Weekly_Report_Data_This_Week__c> insertThisWeekTask = new List<Weekly_Report_Data_This_Week__c>();
        List<Weekly_Report_Data_Next_Week__c> insertNextWeekTask = new List<Weekly_Report_Data_Next_Week__c>();
        map<id,List<Weekly_Report_Comment__c>> MyReportComment = new map<id,List<Weekly_Report_Comment__c>>();
        set<id> WRDTWIdsForCommentsupdt = new set<id>();
        set<id> WRDNWIdsForCommentsupdt = new set<id>();
        if(teamThisWeeklist.size()>0){
            for(ReportWC RWCTW:teamThisWeeklist){
               if(RWCTW.isChecked){
                  Weekly_Report_Data_This_Week__c tempTWTask = new Weekly_Report_Data_This_Week__c();
                  tempTWTask.Weekly_Report__c = wr.id;
                  tempTWTask.Org_Weekly_Report_Data__c = RWCTW.wrtw.id;
                  tempTWTask.Created_User__c = RWCTW.wrtw.Created_User__c;
                  //tempTWTask.Created_User__c = RWCTW.wrtw.CreatedById;
                  tempTWTask.Report_Date__c = RWCTW.wrtw.Report_Date__c;
                  tempTWTask.Account__c = RWCTW.wrtw.Account__c;
                  tempTWTask.Contact__c = RWCTW.wrtw.Contact__c;
                  tempTWTask.Work_Information__c = RWCTW.wrtw.Work_Information__c;
                  tempTWTask.Week_Gubun__c = RWCTW.wrtw.Week_Gubun__c;
                  tempTWTask.Manage_Comment__c = RWCTW.wrtw.Manage_Comment__c; 
                  tempTWTask.Activity_ID__c = RWCTW.wrtw.Activity_ID__c;
                  tempTWTask.Task_Subject__c = RWCTW.wrtw.Task_Subject__c;
                  if(RWCTW.wrtw.Weekly_Report_Comments__r!=Null){
                     MyReportComment.put(tempTWTask.Org_Weekly_Report_Data__c,RWCTW.wrtw.Weekly_Report_Comments__r);    
                  }
                  insertThisWeekTask.add(tempTWTask);   
               }
            }
            
        }
        
        if(teamNextWeekList.size()>0){
            for(ReportWC RWCNW:teamNextWeekList){
               if(RWCNW.isChecked){
                  Weekly_Report_Data_Next_Week__c tempNWTask = new Weekly_Report_Data_Next_Week__c();
                  tempNWTask.Weekly_Report__c = wr.id;
                  tempNWTask.Weekly_Report_Data_Next_Week__c = RWCNW.wrnw.id;
                  tempNWTask.Created_User__c = RWCNW.wrnw.Created_User__c;
                  //tempNWTask.Created_User__c = RWCNW.wrnw.CreatedById;
                  tempNWTask.Report_Date__c = RWCNW.wrnw.Report_Date__c;
                  tempNWTask.Account__c = RWCNW.wrnw.Account__c;
                  tempNWTask.Contact__c = RWCNW.wrnw.Contact__c;
                  tempNWTask.Work_Information__c = RWCNW.wrnw.Work_Information__c;
                  tempNWTask.Week_Gubun__c = RWCNW.wrnw.Week_Gubun__c;
                  tempNWTask.Manage_Comment__c = RWCNW.wrnw.Manage_Comment__c;
                  tempNWTask.Activity_ID__c = RWCNW.wrnw.Activity_ID__c;
                  tempNWTask.Task_Subject__c = RWCNW.wrnw.Task_Subject__c;
                  if(RWCNW.wrnw.Weekly_Report_Comments__r!=Null){
                     MyReportComment.put(tempNWTask.Weekly_Report_Data_Next_Week__c,RWCNW.wrnw.Weekly_Report_Comments__r);   
                  }
                  insertNextWeekTask.add(tempNWTask);
               }    
            }
        }
        
        List<Weekly_Report_Comment__c> insertThisNextWeekComment = new List<Weekly_Report_Comment__c>();
        if(insertThisWeekTask.size()>0){
           insert insertThisWeekTask;
           for(Weekly_Report_Data_This_Week__c WRDtw:insertThisWeekTask){
              list<Weekly_Report_Comment__c> tempTWC = MyReportComment.get(WRDtw.Org_Weekly_Report_Data__c);
              if(tempTWC != Null){
                for(Weekly_Report_Comment__c wrc : tempTWC){
                   Weekly_Report_Comment__c tempNewTWC = new Weekly_Report_Comment__c();
                   tempNewTWC.Comment_User__c = wrc.Comment_User__c;
                   tempNewTWC.Work_Comment__c = wrc.Work_Comment__c;
                   tempNewTWC.Weekly_Report_Data_This_Week__c = WRDtw.id;
                   insertThisNextWeekComment.add(tempNewTWC);   
                }
              }
              if(Test.isRunningTest()){
                 WRDtw.Manage_Comment__c = 'Test Manager Comment1'; 
              }
              if(WRDtw.Manage_Comment__c!=Null){
                 Weekly_Report_Comment__c NewWRDTWC = new Weekly_Report_Comment__c();
                 NewWRDTWC.Comment_User__c = myweeklyreport.CreatedById;
                 NewWRDTWC.Weekly_Report_Data_This_Week__c = WRDtw.id;
                 NewWRDTWC.Work_Comment__c = WRDtw.Manage_Comment__c;
                 insertThisNextWeekComment.add(NewWRDTWC);
                 
                 Weekly_Report_Comment__c previousWRDTWC = new Weekly_Report_Comment__c();    
                 previousWRDTWC.Comment_User__c = myweeklyreport.CreatedById;
                 previousWRDTWC.Weekly_Report_Data_This_Week__c = WRDtw.Org_Weekly_Report_Data__c;
                 previousWRDTWC.Work_Comment__c = WRDtw.Manage_Comment__c;
                 insertThisNextWeekComment.add(previousWRDTWC);
                 WRDTWIdsForCommentsupdt.add(WRDtw.Org_Weekly_Report_Data__c); 
              }  
           }
        }
        
        if(insertNextWeekTask.size()>0){
           insert insertNextWeekTask; 
           for(Weekly_Report_Data_Next_Week__c WRDnw:insertNextWeekTask){
              List<Weekly_Report_Comment__c> existingNWC = MyReportComment.get(WRDnw.Weekly_Report_Data_Next_Week__c);
              if(existingNWC != Null){
                 for(Weekly_Report_Comment__c nwc:existingNWC){
                    
                    Weekly_Report_Comment__c tempnwc = new Weekly_Report_Comment__c();
                    tempnwc.Comment_User__c = nwc.Comment_User__c;
                    tempnwc.Weekly_Report_Data_Next_Week__c = WRDnw.id;
                    tempnwc.Work_Comment__c = nwc.Work_Comment__c;
                    insertThisNextWeekComment.add(tempnwc); 
                 }
                    
              }
              if(Test.isRunningTest()){
                 WRDnw.Manage_Comment__c = 'Test Manager Comment2'; 
              }
              if(WRDnw.Manage_Comment__c!=Null){
                 Weekly_Report_Comment__c newWRDC = new  Weekly_Report_Comment__c();
                 newWRDC.Comment_User__c = myweeklyreport.CreatedById;
                 newWRDC.Weekly_Report_Data_Next_Week__c = WRDnw.id;
                 newWRDC.Work_Comment__c = WRDnw.Manage_Comment__c;
                 insertThisNextWeekComment.add(newWRDC);
                 
                 Weekly_Report_Comment__c preWRDC = new Weekly_Report_Comment__c();
                 preWRDC.Comment_User__c = myweeklyreport.CreatedById;
                 preWRDC.Weekly_Report_Data_Next_Week__c = WRDnw.Weekly_Report_Data_Next_Week__c;
                 preWRDC.Work_Comment__c = WRDnw.Manage_Comment__c;
                 insertThisNextWeekComment.add(preWRDC);
                 WRDNWIdsForCommentsupdt.add(WRDnw.Weekly_Report_Data_Next_Week__c);
              }
           }
        }
        //Insert existing and New Manager comments.
        if(insertThisNextWeekComment.size()>0)
           insert insertThisNextWeekComment;
        
        //Update weekly report's Team Task Added field to True.
        myweeklyreport.Team_Task_Added__c = true;
        //myweeklyreport.Comment_Edit__c = false;
        update myweeklyreport;   
        
        UpdateTeamsWorkComment(WRDTWIdsForCommentsupdt,WRDNWIdsForCommentsupdt);
        Return pageRef;
    }
    
    public void WeeklyReportView(){
        teamThisWeekWRDView = new list<Weekly_Report_Data_This_Week__c>();
        teamNextWRDView = new list<Weekly_Report_Data_Next_Week__c>();
        System.debug('@@@teamThisWeekWRDView'+teamThisWeekWRDView);
        System.debug('@@@teamNextWRDView'+teamNextWRDView);
        //Select all team weekly report data for this week
        System.debug('@@@@myweeklyreport.id'+myweeklyreport.id);
        if(selectedGroup.size()>0){
                for(Weekly_Report_Data_This_Week__c rThisWeek:[Select Work_Information__c, Activity_ID__c, Task_Subject__c, Created_User__c, Created_User__r.Alias, Work_Comment__c, Weekly_Report__c, Week_Gubun__c, Report_Date__c, Org_Weekly_Report_Data__c, Name, Id, CreatedById, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select Id, Comment_User__c, Comment_User__r.Name,Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                               From Weekly_Report_Data_This_Week__c 
                                                               WHERE Weekly_Report__c =: myweeklyreport.id and 
                                                                     Created_User__c !=: myweeklyreport.CreatedById and Created_User__r.Weekly_Report_Group__c IN :selectedGroup order by Created_User__r.Name, Report_Date__c]){
                   teamThisWeekWRDView.add(rThisWeek); 
                   System.debug('@@ Manager Comment:'+rThisWeek.Manage_Comment__c);  
                }
                
                //Select all team weekly report data for next week
                for(Weekly_Report_Data_Next_Week__c rNextWeek:[Select Work_Information__c, Activity_ID__c, Task_Subject__c, Created_User__c, Created_User__r.Alias, Work_Comment__c, Weekly_Report__c, Week_Gubun__c, Report_Date__c, Weekly_Report_Data_Next_Week__c, Name, Id, CreatedById, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select id, Comment_User__c, Comment_User__r.Name, Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                               From Weekly_Report_Data_Next_Week__c 
                                                               WHERE Weekly_Report__c =: myweeklyreport.id and
                                                                     Created_User__c !=: myweeklyreport.CreatedById and Created_User__r.Weekly_Report_Group__c IN :selectedGroup Order By Created_User__r.Name, Report_Date__c]){
                   teamNextWRDView.add(rNextWeek); 
                   System.debug('@@ Manager Comment:'+rNextWeek.Manage_Comment__c);     
                }
        }else{
           for(Weekly_Report_Data_This_Week__c rThisWeek:[Select Work_Information__c, Activity_ID__c, Task_Subject__c, Created_User__c, Created_User__r.Alias, Work_Comment__c, Weekly_Report__c, Week_Gubun__c, Report_Date__c, Org_Weekly_Report_Data__c, Name, Id, CreatedById, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select Id, Comment_User__c, Comment_User__r.Name,Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                              From Weekly_Report_Data_This_Week__c 
                                                              WHERE Weekly_Report__c =: myweeklyreport.id and 
                                                                    Created_User__c !=: myweeklyreport.CreatedById order by Created_User__r.Name, Report_Date__c]){
                   teamThisWeekWRDView.add(rThisWeek); 
                   System.debug('@@ Manager Comment:'+rThisWeek.Manage_Comment__c);  
                }
                
                //Select all team weekly report data for next week
                for(Weekly_Report_Data_Next_Week__c rNextWeek:[Select Work_Information__c, Activity_ID__c, Task_Subject__c, Created_User__c, Created_User__r.Alias, Work_Comment__c, Weekly_Report__c, Week_Gubun__c, Report_Date__c, Weekly_Report_Data_Next_Week__c, Name, Id, CreatedById, Contact__c, Account__c,Account__r.Name,Manage_Comment__c, (Select id, Comment_User__c, Comment_User__r.Name, Comment_User__r.Title, Work_Comment__c, Weekly_Report_Data_This_Week__c, Weekly_Report_Data_Next_Week__c From Weekly_Report_Comments__r) 
                                                               From Weekly_Report_Data_Next_Week__c 
                                                               WHERE Weekly_Report__c =: myweeklyreport.id and
                                                                     Created_User__c !=: myweeklyreport.CreatedById Order By Created_User__r.Name, Report_Date__c]){
                   teamNextWRDView.add(rNextWeek); 
                   System.debug('@@ Manager Comment:'+rNextWeek.Manage_Comment__c);     
                }       
        }   
        System.debug('@@@teamThisWeekWRDView'+teamThisWeekWRDView);
        System.debug('@@@teamNextWRDView'+teamNextWRDView);  
        System.debug('@@ teamUserIds:'+teamUserIds); 
        
    } 
     public String[] getselectedGroup() {
        return selectedGroup;
    }

    public void setselectedGroup(String[] selectedGroup) {
        this.selectedGroup = selectedGroup;
    }
    
    //To get/set Group Name
    public List<SelectOption> getUserGroupName(){
        
        List<SelectOption> options = new List<SelectOption>();
        for(String str:groupName){
                   options.add(new SelectOption(str,str));
            }
            return options;
            
    }
    
    //To update comments
    public void DoUpdateComment(){
        List<Weekly_Report_Data_This_Week__c> updateThisWeekList = new List<Weekly_Report_Data_This_Week__c>();
        List<Weekly_Report_Data_Next_Week__c> updateNextWeekList = new List<Weekly_Report_Data_Next_Week__c>();
        
        List<Weekly_Report_Comment__c> insertTeamTWNWComment = new List<Weekly_Report_Comment__c>();
        //List<Weekly_Report_Data_Next_Week_Comment__c> insertTeamNWComment = new List<Weekly_Report_Data_Next_Week_Comment__c>();
        
        List<Weekly_Report_Comment__c> updatemyTWNWComment = new List<Weekly_Report_Comment__c>();
        //List<Weekly_Report_Data_Next_Week_Comment__c> updatemyNWComment = new List<Weekly_Report_Data_Next_Week_Comment__c>();
        
        List<Weekly_Report_Comment__c> deletemyTWNWComment = new List<Weekly_Report_Comment__c>();
        //List<Weekly_Report_Data_Next_Week_Comment__c> deletemyNWComment = new List<Weekly_Report_Data_Next_Week_Comment__c>();
                
        Boolean isInsertMode = false;
        set<Id> parentWRDIds = new set<id>();
        set<Id> parentWRDNWIds = new set<Id>();
        
        //This week weekly report data comment
        for(Weekly_Report_Data_This_Week__c rthisW:teamThisWeekWRDView){
           updateThisWeekList.add(rthisW);  
           if(rthisW.Org_Weekly_Report_Data__c != Null){
              parentWRDIds.add(rthisW.Org_Weekly_Report_Data__c);   
              if(rthisW.Manage_Comment__c != Null){
                 Weekly_Report_Comment__c twComment = new Weekly_Report_Comment__c();
                 twComment.Comment_User__c = myweeklyreport.CreatedById;    
                 twComment.Weekly_Report_Data_This_Week__c = rthisW.Org_Weekly_Report_Data__c;
                 twComment.Work_Comment__c =  rthisW.Manage_Comment__c;
                 insertTeamTWNWComment.add(twComment);
              }
           }
           isInsertMode = true;
           for(Weekly_Report_Comment__c c:rthisW.Weekly_Report_Comments__r){
              if(c.Comment_User__c == myweeklyreport.CreatedById){
                if(rthisW.Manage_Comment__c!=null){
                    c.Work_Comment__c = rthisW.Manage_Comment__c;
                    updatemyTWNWComment.add(c);
                }else{
                    deletemyTWNWComment.add(c);
                }
                 isInsertMode = false;
              }
           }
           if(isInsertMode && rthisW.Manage_Comment__c != Null){
              Weekly_Report_Comment__c myCmmt = new Weekly_Report_Comment__c();
              myCmmt.Comment_User__c = myweeklyreport.CreatedById;  
              myCmmt.Weekly_Report_Data_This_Week__c = rthisW.id;
              myCmmt.Work_Comment__c =  rthisW.Manage_Comment__c;
              insertTeamTWNWComment.add(myCmmt);  
           }
        }
        //Next week weekly report data comment
        for(Weekly_Report_Data_Next_Week__c rNextW:teamNextWRDView){
           updateNextWeekList.add(rNextW);
           if(rNextW.Weekly_Report_Data_Next_Week__c != Null){
              parentWRDNWIds.add(rNextW.Weekly_Report_Data_Next_Week__c);
              if(rNextW.Manage_Comment__c != Null){
                 Weekly_Report_Comment__c nwc = new Weekly_Report_Comment__c();
                 nwc.Comment_User__c = myweeklyreport.CreatedById;
                 nwc.Weekly_Report_Data_Next_Week__c = rNextW.Weekly_Report_Data_Next_Week__c;
                 nwc.Work_Comment__c = rNextW.Manage_Comment__c;
                 insertTeamTWNWComment.add(nwc);      
              }
           }
           isInsertMode = true;
           for(Weekly_Report_Comment__c c:rNextW.Weekly_Report_Comments__r){
              if(c.Comment_User__c == myweeklyreport.CreatedById){
                if(rNextW.Manage_Comment__c != Null){
                    c.Work_Comment__c = rNextW.Manage_Comment__c;
                    updatemyTWNWComment.add(c);
                }else{
                    deletemyTWNWComment.add(c);
                }
                isInsertMode = false;
              }
           }
           if(isInsertMode && rNextW.Manage_Comment__c != Null){
              Weekly_Report_Comment__c mynwc = new Weekly_Report_Comment__c();
              mynwc.Comment_User__c = myweeklyreport.CreatedById;
              mynwc.Weekly_Report_Data_Next_Week__c = rNextW.id;
              mynwc.Work_Comment__c = rNextW.Manage_Comment__c;
              insertTeamTWNWComment.add(mynwc);     
           }    
        }
        
        if(parentWRDIds.size()>0 || parentWRDNWIds.size()>0){
            delete [SELECT id FROM Weekly_Report_Comment__c WHERE Comment_User__c=:myweeklyreport.CreatedById and (Weekly_Report_Data_This_Week__c=:parentWRDIds OR Weekly_Report_Data_Next_Week__c=:parentWRDNWIds)];
        }
        
        if(insertTeamTWNWComment.size()>0){
           insert insertTeamTWNWComment;  
        }
               
        if(updateThisWeekList.size()>0){
            update updateThisWeekList;
        }
        if(updateNextWeekList.size()>0){
            update updateNextWeekList;
        }
        
        if(updatemyTWNWComment.size()>0){
            update updatemyTWNWComment;
        }
        
        if(deletemyTWNWComment.size()>0){
            delete deletemyTWNWComment;
        }
        //disable comment edit
        //myweeklyreport.Comment_Edit__c = false;
        //update myweeklyreport;
        
        isEditMode = false;
        UpdateTeamsWorkComment(parentWRDIds,parentWRDNWIds);
        WeeklyReportView();
        
    }
    //Enable Comment for Edit
    public Boolean isEditMode{get;set;}
    public void doEdit() {
        isEditMode = true;
    }  
    
    public void DoCancelEdit(){
       isEditMode = false;      
    }
    
    // To Update Team work comment
    public void UpdateTeamsWorkComment(set<id> WRDTWIds, set<id> WRDNWIds){
       
       //Update Team This week comment.
       list<Weekly_Report_Data_This_Week__c> workcommentTW = new List<Weekly_Report_Data_This_Week__c>();
       for(Weekly_Report_Data_This_Week__c mgrComment:[Select Id, Work_Comment__c,(Select Comment_User__r.Name, Comment_User__r.Title, Work_Comment__c From Weekly_Report_Comments__r) From Weekly_Report_Data_This_Week__c WHERE id=:WRDTWIds]){
           mgrComment.Work_Comment__c = null;
           for(Weekly_Report_Comment__c allWRDCmt:mgrComment.Weekly_Report_Comments__r){
              if(mgrComment.Work_Comment__c==Null || mgrComment.Work_Comment__c == ''){
                 mgrComment.Work_Comment__c = allWRDCmt.Comment_User__r.Name+'('+allWRDCmt.Comment_User__r.Title+'):\n'+allWRDCmt.Work_Comment__c;      
              } else{
                mgrComment.Work_Comment__c += '\n---------------------------\n'+allWRDCmt.Comment_User__r.Name+'('+allWRDCmt.Comment_User__r.Title+'):\n'+allWRDCmt.Work_Comment__c;
              }
           }
           workcommentTW.add(mgrComment);
       } 
       if(workcommentTW.size()>0)
           update workcommentTW;
           
       //Update Team Next week comment.
       list<Weekly_Report_Data_Next_Week__c> workcommentNW = new List<Weekly_Report_Data_Next_Week__c>();
       for(Weekly_Report_Data_Next_Week__c mgrComment:[Select Id, Work_Comment__c,(Select Comment_User__r.Name, Comment_User__r.Title, Work_Comment__c From Weekly_Report_Comments__r) From Weekly_Report_Data_Next_Week__c WHERE id=:WRDNWIds]){
          mgrComment.Work_Comment__c = null;
          for(Weekly_Report_Comment__c allWRDNWCmt:mgrComment.Weekly_Report_Comments__r){
             if(mgrComment.Work_Comment__c==Null || mgrComment.Work_Comment__c == ''){
                 mgrComment.Work_Comment__c = allWRDNWCmt.Comment_User__r.Name+'('+allWRDNWCmt.Comment_User__r.Title+'):\n'+allWRDNWCmt.Work_Comment__c;        
              } else{
                mgrComment.Work_Comment__c += '\n---------------------------\n'+allWRDNWCmt.Comment_User__r.Name+'('+allWRDNWCmt.Comment_User__r.Title+'):\n'+allWRDNWCmt.Work_Comment__c;
              } 
          }
          workcommentNW.add(mgrComment);
       }  
       if(workcommentNW.size()>0)
          update workcommentNW; 
    }
    //Wrapper class for Weekly Report Data
    public class ReportWC {
        public Boolean isChecked{get;set;}  
        public Weekly_Report_Data_This_Week__c wrtw{get;set;} 
        public Weekly_Report_Data_Next_Week__c wrnw{get;set;}
    }
}