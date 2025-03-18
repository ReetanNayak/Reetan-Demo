//The extension class named 'WeekViewCalendar_CLS' fetch account records and display in the vf  page named CustomAccountList .
public with sharing class WeekViewCalendar_CLS {
  
    
    //instance UrL
    public String instanceURL = URL.getSalesforceBaseUrl().toExternalForm();
    
    //holds the start date for retrieving the events for a week based on the start date
    public String strDatePass { get; set;}
    
    //holds success/failure message on deletion of an event
    public String strEvntDelMsg { get; set;}
    
    //holds page number
    public Integer intPageNumber { get; set;}
    
    
    //holds the calendarUserName and calendarUserId
    public String calendarUserId { get; set;}
    public String calendarUserName { get; set;}
    
    // holds selected column name from the account list
    private String queryColumnName;
    
    // holds accending or decending order value on the selected column name from the account list
    private String queryColumnOrderBy = 'asc';
    
    // holds the selected column name from the account list for sorting.
    public String SortColName { get; set;}
    
    // holds the selectd filter key from filter links (A to Z, Other, All)
    public String filterKey { get;set;}
    
    // holds the column sort order ('asc' | ' desc')
    public String strAscDesc { get; set; }
    
       
     // Check for delete status from list box, if delete option clicked then deletedSelected = true else deletedSelected = false
    public boolean deletedSelected = false;
    
   //for deleting a particular event
    public Id SelEventIdToDelete{ get; set; }
    
     //for selected account id to store
     public Id SelAccIdToDelete{ get; set; }
     
    // holds the list row size 
    public Integer listRowSize{ get; set; }
    
    //Instance of the wrapper class called AccountWrapper --- Used to store the checkbox value for each records 
    List<AccountWrapper> lstAccWrp {get;set;}
    
    //For storing the total count of records fetched by query
    Public Integer noOfRecords{get; set;}

    //For storing the list view selected from picklist 
    public String strSelectedFilterId{get;set;}
    
    //For storing the list view name for a particular list view id
    public String strFilterName{get;set;}
    
    //to hide /show the pop up 
    public boolean blDisplayPopUp{get;set;} 
    
     //to hide /show the change user pop up 
    public boolean displayUserPopUp{get;set;} 
    
    
    //To store the fields selected in a concatenated string
    public String strFields = '';
    
    //Query string - for dynamically passing the string to query
    private String queryString;
    
    //For storing the account fields 
    public Map<String, Schema.SObjectField> mapFields {get;set;}
    
    //An instance of the wrapper class to store the field names and labels of account object
    public List<categoryWrapper> lstAccountFields{get;set;}
    
    //The filter ID to be fetched after redirecting from the previous account home page
    public string strFilterId;
        
    //strFilterId = ApexPages.currentPage().getParameter().get('fcf');
    // fetching Account records by soql query
    
    // String variables to store the selected accountID and Account name
    public String selectedAccountID {get;set;}
    public String selectedAccountName {get;set;}
    
    // A boolean to set the display of event pop up to true/false
    public Boolean displayEventPopUp {get; set;}
    
    //To store the start date,start time,end date,end time of the event.
    public string StartDate {get; set;}
    public string StartTime {get; set;}
    public string EndDate {get; set;}
    public string EndTime {get; set;}
    
    
    //To return a string message to page on save of a particular event.
    public String strMsg {get;set;}
    
    //To return a string message to page if deleting a particular account fails.
    public String strAccDelMsg {get;set;}
    
    //to store the set of fields fetched from list view object.
    public String myFields = '';
    
    
    // holds the list of Account Object filtered from the FilteredID combo box
    public List<Account> AccontListRows = new List<Account>();
    private String account_column_names = 'Name, Type, BillingCity, BillingState, BillingCountry';
    private final String BaseQuery = 'Select ' +account_column_names+'  from Account order by Name ASC';
   
     public ApexPages.StandardSetController setCon {
        get{
            
            return setCon;
        }set;
    }
   
    // Constructor
   
    public WeekViewCalendar_CLS(ApexPages.StandardSetController controller) {
            
            
            //Getting the filter/view id from the url and setting the filter id.        
            strSelectedFilterId = apexpages.currentpage().getparameters().get('fcf');        
                    
            //On load  of page we are loading the calendar for the logged in user
            calendarUserName = Userinfo.getName();
            calendarUserId = UserInfo.getUserId();
            // On load of page we are initially querying  accounts based on a specific query string 
            
            //Fetching the columns from the custom list view object based on the list view
            Account_List_View__c[] acctsListView = [SELECT Fields__c FROM Account_List_View__c WHERE View_Id__c=:strSelectedFilterId];
            if(acctsListView.size() > 0){
                
                myFields = acctsListView[0].Fields__c;
                queryColumnName = getFirstColumn(myFields);
                queryString = 'Select ' +acctsListView[0].Fields__c+'  from Account order by '+queryColumnName+' ASC';

                
                system.debug('myquery***'+queryString);
                
            }
            //If no data is stored in columns we are showing static columns.
            else{
                
                queryString = BaseQuery;
                queryColumnName = 'Name';
                
            }
            SortColName = queryColumnName;   
            queryColumnOrderBy = 'asc';
            strAscDesc  = queryColumnOrderBy; 
            
            //Instantiating the vent object on load.
            eventList = new Event();
            
            //Quering list of accounts and setting the page size.On load of page it is set to 10
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            system.debug('setCon***'+setCon);
            listRowSize = 10;
            setCon.setPageSize(listRowSize);
                   
                       
           
            if(strSelectedFilterId != null){
                setCon.setFilterId(strSelectedFilterId);
            }
            // If the fcf is null in any case we are setting a static fcf.
            else {
                strSelectedFilterId = '00B90000002Y9Hz';
                setCon.setFilterId('00B90000002Y9Hz');
            }
            
            noOfRecords = setCon.getresultSize();
            fetchColNames();
            AccontListRows = fetchAccontListRows();
            
            //for setting the filter id in the need box we need 18 digit filter id.From url we get only 15 digit.So need to convert it to 18 to get the 18 digit Filter ID
            if(strSelectedFilterId != null){
                for(System.SelectOption str:setCon.getListViewOptions()){
                       if((str.getValue()+'').contains(strSelectedFilterId)){
                           strSelectedFilterId = str.getValue()+'';
                           system.debug('tt**'+strSelectedFilterId);
                           strFilterName = str.getLabel()+'';
                           system.debug('tt2**'+strFilterName);
                     }
                }
            }
          

         
          //Calling the fetchCanlenderEvents method and passing
          //the current week start date in this format 04/16/2012
            
            date todayDate = system.today();
            date weekStart = todayDate.toStartofWeek();
            DateTime weekStartDt = Datetime.newInstance(weekStart.year(),weekStart.month(),weekStart.day(),0,0,0);
            String wkStrt =  weekStartDt.format('MM/dd/yyyy');
            fetchCanlenderEvents(wkStrt);
            
            
            //User Pop Up for change user
             user = new User();
            
            // get the current search string to search a particular user in the change user  pop up
            searchString = System.currentPageReference().getParameters().get('lksrch');
            runSearch();  
            
            
            
    }
    
    
    
    // Sending Event Data to JQuery.
    // We are sending data based on a particular week.
    // Clubbing all the data in a list and sending it as JSON String.

    public List<String> weekEvents{ get; set; }
    
    private void fetchCanlenderEvents(String strStart){
         //passing  start date like this 04/12/2012
         // changing it to datetime format
         datetime StartDt = datetime.newInstance(Integer.valueOf(strStart.substring(6,10)),Integer.valueOf(strStart.substring(0,2)),Integer.valueOf(strStart.substring(3,5)));
         //Adding 7days to the start date to get the end date 
         datetime EndDt = StartDt.addDays(7);
        
         //getting the datetime value in this format 1960-02-19 00:00:00
         
         
         //Changing it to String format like this -- 19/02/1960 00:00
         String strStartDt = StartDt.format();
         String strEndDt = EndDt.format();
         
         List<Event> eventRows;
         eventRows = new List<Event>();
         // Fetching calender events based on Start date,End Date and Owner ID.        
         String strStartDate = strStartDt.substring(6,10)+'-'+strStartDt.substring(3,5)+'-'+strStartDt.substring(0,2)+'T00:00:00.000Z';
         String strEndDate = strEndDt.substring(6,10)+'-'+strEndDt.substring(3,5)+'-'+strEndDt.substring(0,2)+'T23:59:00.000Z';
         //String sql = 'SELECT IsAllDayEvent,ownerId,owner.name,Subject,WhoId,Who.Name,WhatId,What.Name,Call_Report__c,StartDateTime,Category__c,Type__c,Call_Type__c,Status__c,Time_off_Territory_PM__c,Time_off_Territory_AM__c,EndDateTime FROM EVENT where StartDateTime>=' + strStartDate + ' and EndDateTime<=' + strEndDate+ 'and ownerId=\'' + calendarUserId + '\'';
         //String sql = 'SELECT IsAllDayEvent,ownerId,owner.name,Subject,WhoId,Who.Name,WhatId,What.Name,Call_Report__c,StartDateTime,Category__c,Type__c,Call_Type__c,Status__c,Time_off_Territory_PM__c,Time_off_Territory_AM__c,EndDateTime FROM EVENT where (StartDateTime>=' + strStartDate + ' and EndDateTime<=' + strEndDate+ ') OR (StartDateTime<' + strStartDate + ' and EndDateTime>' + strEndDate+') OR (StartDateTime>=' + strStartDate + ' and StartDateTime<=' + strEndDate+' and EndDateTime>' + strEndDate+') OR (StartDateTime<' + strStartDate + ' and EndDateTime<=' + strEndDate+' and EndDateTime>=' + strStartDate+' ) and (ownerId=\'' + calendarUserId + '\'';
         String sql = 'SELECT IsAllDayEvent,ownerId,owner.name,Subject,WhoId,Who.Name,WhatId,What.Name,Call_Report__c,StartDateTime,Category__c,Type__c,Call_Type__c,Status__c,Time_off_Territory_PM__c,Time_off_Territory_AM__c,EndDateTime FROM EVENT where ((StartDateTime>=' + strStartDate + ' and EndDateTime<=' + strEndDate+ ') OR (StartDateTime<' + strStartDate + ' and EndDateTime>' + strEndDate+') OR (StartDateTime>=' + strStartDate + ' and StartDateTime<=' + strEndDate+' and EndDateTime>' + strEndDate+') OR (StartDateTime<' + strStartDate + ' and EndDateTime<=' + strEndDate+' and EndDateTime>=' + strStartDate+' )) and ownerId=\'' + calendarUserId + '\'';
         
         try {
             eventRows = Database.query(sql);
         } catch(QueryException s) {}
         
         if(eventRows.size() > 0) {
         system.debug('done rows fetched:' + eventRows.size());
         EventResultReturn evnt;
         weekEvents = new List<String>();
         
         for( Event evt: eventRows) {
              
              //Call report coming in this format :<a href="/a0XW00000001XY1MAM" target="_parent">Call Report</a>;
            
              String strCallReport;
              if(evt.Call_Report__c != null){
                  String a  = evt.Call_Report__c;
                  strCallReport = '<a href=/'+a.substring(10,28)+'>Call Report</a>';
              }
              else{
                  strCallReport = '';
              }
              Integer iDate = evt.StartDateTime.dayOfYear();
              Integer iYear = evt.StartDateTime.year();
              String url = instanceURL+'/'+evt.id+'/e?retURL=apex/AccountContactList';
              // In case any of the value is null,sending blank value to JQuery side
                String type;
                if(evt.Type__c ==  null){type = '';}
                else{type = evt.Type__c;}
                String callType;
                if(evt.Call_Type__c ==  null){callType = '';}
                else{callType = evt.Call_Type__c;}
                String status;
                if(evt.Status__c ==  null){status = '';}
                else{status = evt.Status__c;}
                String category;
                if(evt.Category__c ==  null){category = '';}
                else{category = evt.Category__c;}
                String what;
                if(evt.WhatId ==  null){what = '';}
                else{what = '<a href=/'+evt.WhatId+'>'+evt.What.Name+'</a>';}
                String strSubjct;
                if(evt.Subject ==  null){strSubjct = '';}
                else{strSubjct = evt.Subject;}
                String contactName;
                if(evt.Who.Name ==  null){contactName = '';}
                else{contactName = evt.Who.Name;}
                
              evnt = new EventResultReturn(
                                              strSubjct,
                                              evt.IsAllDayEvent,
                                              type,
                                              callType,
                                              strSubjct,
                                              //evt.StartDateTime.format('E MMM dd yyyy hh:mm:ss Z', 'GMT'),
                                              evt.StartDateTime.format('MM/dd/yyyy hh:mm a'),
                                              evt.EndDateTime.format('MM/dd/yyyy hh:mm a'),
                                              strCallReport,
                                              evt.owner.name+'',
                                              status,
                                              evt.id+'',
                                              evt.Time_off_Territory_AM__c,
                                              evt.Time_off_Territory_PM__c,
                                              category,
                                              what,
                                              '<a href=/'+evt.WhoId+'>'+evt.Who.Name+'</a>',
                                              '<a href=/00U/c?md0='+iYear+'&md3='+iDate+'>Check Availability</a>',
                                              url,
                                              contactName
                                        );
          
         // Storing all the event date in 'evnt' list and converting it to JSON 
          weekEvents.add(JSON.serialize(evnt));
          
        }
        system.debug('Total Events :'+weekEvents);
      } 
    }
    
 

    // holds all the Accout Object column name and values.
    private  final Map<String, Schema.SObjectField> accountFieldsMap = Schema.SObjectType.Account.fields.getMap();
  // holds boolean value if account filter combo box selected

  // Method is used to fetch the dynamic column names from the StandardSetController account object
     private void fetchColNames(){
            String ss;
            sObject Account_Cols = null;
            lstAccountFields = new List<categoryWrapper>();
            
                String[]  arr;
                if(myFields == ''){
                    arr = account_column_names.split(',');
                    system.debug('test3*');
                }
                else{
                     arr = myFields.split(',');
                     
                }
                for (Integer i=0;i<arr.size();i++){
                      
                             ss = arr[i].trim();
                             lstAccountFields.add(new CategoryWrapper(accountFieldsMap.get(ss)+'',accountFieldsMap.get(ss).getDescribe().getLabel()+''));
                             
                }
           
               
     }
     
     
      // This method is used to fetch all the rows from Standard Set controller.
      private List<Account> fetchAccontListRows(){
        List<Account> tempList = new List<Account>();
        //Integer j = setCon.getresultSize();
        //system.debug('Initial Size:'+ j + ' Records Size :' + setCon.getRecords().size());
        setCon.first();
        while (true)      {
            for (SObject s: setCon.getRecords()){
                   tempList.add((Account)s);             
            }
            if (setCon.getHasNext()){
                setCon.next();
            } else { break; }
        } 
        setCon.first();
        system.debug('test6***'+tempList);
        return tempList;
    }
    
     
     
     /* This method is used to filter the Account List Records based on the 
       selected filter key from UI (between A to Z,Other,All),
       Takes complete Account List objects from List and filter records based on the selected char and column.
       The column name is picked from queryColumnName.
       The Account List is picked from myAccList.
    */
    public void filterRecords()
    {
      try{  //For looping the list object
            Integer n;
            Integer i;
            //holds account object column value
            String compVal;
            //Temporoy Account List object holds filtered Account Objects.
            List<Account> tempList = new List<Account>();
            List<Account> accl = AccontListRows;
            
            if (filterKey==null) {               filterKey='All';            }
            //Check if "All" option is selected and set the all Previously selected account list objects to StandardSetControll
            if (filterKey.equals('All'))
            {
                tempList = AccontListRows;
            }
            //Check if "Other" option is selected and fetch all account objects starting other then A to Z on the filter column selected.
            else if (filterKey.equals('Other'))
            {
                n = accl.size() -1;
                for (i = 0; i <= n; i++) 
                {  
                        if (accl[i].get(queryColumnName) == null){
                            tempList.add(accl[i]);
                        }
                        else{
                            compVal = accl[i].get(queryColumnName)+'';
                            compVal = compVal.trim();
                            if (compVal.length() > 0) 
                            {
                                final String alphs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
                                compVal = compVal.substring(0,1);
                                if (alphs.indexOf(compVal) == -1 ) 
                                {
                                    tempList.add(accl[i]);
                                }   
                            }
                            else{
                                tempList.add(accl[i]);
                            }
                        }
                }
            }
            //Check if option between (A to Z) is selected and fetch all account objects starting with selected Char(between  A to Z) on the filter column selected.
            else  
            {
                n = accl.size() -1;
                for (i = 0; i <= n; i++) 
                {  
                        compVal = accl[i].get(queryColumnName)+'';
                        compVal = compVal.trim();
                        if (compVal.length() > 0) 
                        {
                            if (compVal.substring(0,1).equalsIgnoreCase(filterKey)) 
                            {
                                tempList.add(accl[i]);
                            }   
                        }
                }
            }
            // After filtering the Account Object set the tempList object to StandardSetController
            setCon = new ApexPages.StandardSetController(tempList);
            setCon.setPageSize(listRowSize);
        }catch(Exception er){
                system.debug('Error In FilterRecords :' + er);
        }
   }
   
        
    /* This method is used to sort the Account List Records based on the 
       selected column name from account list columns,
       Takes complete Account List objects from List and sort records (accending | decending).
       The column name is picked from queryColumnName.
       The accending|decending order is picked from queryColumnOrderBy 
       The Account List is picked from myAccList.
       
    */
    
    public void sortRecords()
    {
        try{
            //For looping the list object
            Integer n;
            Integer i;
            Integer j;
            
            String AssDesc = 'asc';
            List<Account> sortAccList = AccontListRows;
            Account temp;
            n = sortAccList.size() -1;
            system.debug(' Acc List count is :'+ n);
            if (SortColName== null ) {           SortColName='Name';           }
            if (queryColumnName == SortColName && queryColumnOrderBy =='asc'){
               AssDesc = 'desc';
            }
            queryColumnName = SortColName;
            queryColumnOrderBy = AssDesc;
            strAscDesc  = queryColumnOrderBy;
            //String compStr;

            system.debug(' sort Column is  :'+ queryColumnName );
            system.debug(' sort order  is  :'+ queryColumnOrderBy);
                     
            String compStr1;
            String compStr2;
                     
            for (i = 1; i <= n; i++) 
            {  
                for (j = n; j >= i ; j--) 
                {
                    compStr1 = '';
                    compStr2 = '';
                    if (sortAccList[j].get(SortColName)!= null)
                        compStr1 = sortAccList[j].get(SortColName)+'';
                    if (sortAccList[j-1].get(SortColName)!= null)   
                        compStr2 = sortAccList[j-1].get(SortColName)+'';
                    
                    compStr1 = compStr1.toUpperCase();
                    compStr2 = compStr2.toUpperCase();

                    
                    if (queryColumnOrderBy == 'desc') 
                    {
                        if (compStr1.compareTo(compStr2) >= 0) 
                        {
                                temp = sortAccList[j-1];
                                sortAccList[j-1] = sortAccList[j];
                                sortAccList[j] = temp;
                        }    
                    } 
                    else 
                    {
                        if (compStr1.compareTo(compStr2) <= 0) 
                        {
                                temp = sortAccList[j-1];
                                sortAccList[j-1] = sortAccList[j];
                                sortAccList[j] = temp;
                        }    
                    }
               }
         } 

         // After sorting the Account Object set the tempList object to StandardSetController
         setCon = new ApexPages.StandardSetController(sortAccList);
         setCon.setPageSize(listRowSize);
         //setCon.first();
        }catch (Exception er){
            system.debug('Exception :' + er);
        }
    }
     
 

    //for showing the select fields pop up   
    public void openPopUp(){
        blDisplayPopUp = true;
    }
    //for closing the select fields pop up   
     public void closePopUp(){
        blDisplayPopUp = false;  
    }
    // Using wrapper class to get the name and labels of fields in account
    List<categoryWrapper> lstAccFields{get;set;}
    public List<categoryWrapper> getAccFields() {
        lstAccFields = new List<categoryWrapper>();
        mapFields = Schema.SObjectType.Account.fields.getMap();
        for (String s: mapFields.keySet())
            {
                 lstAccFields.add(new CategoryWrapper(mapFields.get(s).getDescribe().getName(),mapFields.get(s).getDescribe().getLabel()));

            }   
        return lstAccFields;
    }
    
       
     // Using wrapper class to show the account records
    public List<AccountWrapper> getAccountsWrp() {
        lstAccWrp = new List<AccountWrapper>();
        for (Account acc : (List<Account>)setCon.getRecords())
            lstAccWrp.add(new AccountWrapper(acc));
        system.debug('lstAccWrp****'+lstAccWrp);    
        return lstAccWrp;
    }   
    
    //For refreshing the account list
    public pageReference refresh() {
        setcon.setFilterId(strSelectedFilterId);
        setCon.setPageNumber(1);
        return null;
    }
     //For changing the row size
    public pageReference changeRowSize() {
         system.debug('inside function changerowsize'+listRowSize+'filter:'+strSelectedFilterId);
         
         setCon.setPageSize(listRowSize);
         
         assignFilter();
        
         return null;
    }
    //For going to a specific page
    
    public pageReference changePageNumber() {
         system.debug('inside function changePageNumber'+intPageNumber);
         
                 
         assignFilter();
         setCon.setpageNumber(intPageNumber);
        
         return null;
    }
     //For checking if it has next value
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    
    //For checking if it has previous value
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    //For getting the page number
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
    //Go to first page
    public void first() {
        setCon.first();
    }
    
    //Go to last page
    public void last() {
        setCon.last();
    }
    
    //Go to previous page
    public void previous() {
        setCon.previous();
    }
    
    //Go to next page
    public void next() {
        setCon.next();
    }
    
    //To get the total records
    public Integer totalRecords {
        get {
            return setCon.getResultSize();
        }
        set;
    }
    
    //To get the next record
    public Integer nextRecord {
         get {
            if(totalRecords != 0){
            Integer nr = (pageNumber - 1)*pageSize + 1;
            return nr;
            }
            else{return 0;}
        }
        set;
    }
    
    //To get the last record
    public Integer lastRecord {
        get {
            if(totalRecords > pageSize){
            Integer nL = (pageNumber * pageSize);
            if(nL>totalRecords){return totalRecords;}
            else{return nL;}
            }
            else{return totalRecords;}
        }
        set;
    } 
    
    //To get the total page size
    public Integer pageSize {
       get {
            return setCon.getPageSize();
        }
        set;
    }
    
    //To get the total page number
    public Integer totalPageNumber {
        get {
            Integer n = totalRecords - (pageSize * (totalRecords / pageSize));
             if(n == 0){
                 return totalRecords / pageSize;
                 }
             else
             return (totalRecords / pageSize) + 1;
        }
        set;
    }  
    
    //To get account the list views
     public List<SelectOption> lstIpadListViewOptions {
        get {
          
            return setCon.getListViewOptions();
        }
        set;
    }

    
    
 //To assign the filter on change of list view from dropdown    
    public void assignFilter(){
        
        if(strSelectedFilterId != null){
                   setcon.setFilterId(strSelectedFilterId);
                   
                   for(System.SelectOption str:setCon.getListViewOptions()){
                       if((str.getValue()+'').equals(strSelectedFilterId))
                           strFilterName = str.getLabel()+'';
                }
        } 
        Account_List_View__c[] acctsListView = [SELECT Fields__c FROM Account_List_View__c WHERE View_Id__c=:strSelectedFilterId.substring(0,15)];
            if(acctsListView.size() > 0){
                myFields = acctsListView[0].Fields__c;
                queryColumnName = getFirstColumn(myFields);
                queryString = 'Select ' +acctsListView[0].Fields__c+'  from Account order by '+queryColumnName+' ASC';
                system.debug('seee****'+queryString);
               
            }
            else{
                
                queryString = BaseQuery;
                myFields = '';
                queryColumnName = 'Name';
                
            }
            SortColName = queryColumnName;       
            queryColumnOrderBy = 'asc';
            strAscDesc  = queryColumnOrderBy;    
        
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            setCon.setPageSize(listRowSize);
            setcon.setFilterId(strSelectedFilterId);
            setCon.first();
            AccontListRows = fetchAccontListRows();
            fetchColNames();
   }
   
 
    //An instance of Event object
    public Event eventList{get;set;}
    
    //To set values to Event as default on load of the pop up
    public Event getEvents() {
        
           //To set the value of owner field.
           eventList.ownerId= UserInfo.getUserId();
           
           //To set the value of Related to field and person account contact field.
           if((selectedAccountID == null) || (selectedAccountID == '')){}
           else {
                eventList.WhatId = selectedAccountID;
                List<Contact> lstCon= new List<Contact>();
                List<Account> lstAcc= new List<Account>();
            /*   lstAcc = [select IsPersonAccount from Account where Account.Id =:selectedAccountID];
                if(lstAcc.size()>0 && lstAcc[0].IsPersonAccount == true){
                    lstCon = [select id from contact where Account.Id =:selectedAccountID AND Account.RecordTypeID = '012200000009w7B'];
                    if(lstCon.size()>0) {
                         eventList.WhoId = lstCon[0].id;
                         system.debug('whos****'+eventList.WhoId);
                    }
                   
                }    */
           }
            
          return eventList;
    }
    
   

    //For displaying the event pop up
    public void doPopUp() {
        //clearing the eventList data when the event pop up opens
        // so that it cleans the data stored previously.
        eventList =  new Event();
        //To open the event pop up
        displayEventPopUp = true;
        
    }
    
    //for displaying change user pop up
    
     public void changeUserShowLookUp() {
       
        displayUserPopUp = true;
    }
    //for closing change user pop up
    public void closeUserShowLookUp() {
        
        displayUserPopUp = false;
    }
     // for setting a user to the calendar on change of user
     public void setCalendarUser() {
        List<user> usr = [select name from user where id=:calendarUserId];
        calendarUserName = usr[0].name;
        displayUserPopUp = false;
        //In case the calendar is not in current week take the date and show the data for
        //that particular week
        if(strDatePass != null){
            fetchCanlenderEvents(strDatePass);
        }
        //In case the calendar is in current week show the data for current week
        else{
            date todayDate = system.today();
            date weekStart = todayDate.toStartofWeek();
            DateTime weekStartDt = Datetime.newInstance(weekStart.year(),weekStart.month(),weekStart.day(),0,0,0);
            String wkStrt =  weekStartDt.format('MM/dd/yyyy');
            fetchCanlenderEvents(wkStrt);
        }
        
    }
    // An instance of event object
    public event saveEvent;
    
    //For saving a particular event on click of save button
       public void doSave() {
            system.debug('do save****************');
            strMsg = '';
            saveEvent= new event();
            saveEvent.ownerId=eventList.ownerid;
            saveEvent.Subject = eventList.Subject;
            saveEvent.WhoId = eventList.WhoId;
            saveEvent.WhatId = eventList.WhatId;
            saveEvent.Type__c = eventList.Type__c;
            saveEvent.Call_Type__c = eventList.Call_Type__c;
            saveEvent.Status__c = eventList.Status__c;
            saveEvent.Time_off_Territory_AM__c = eventList.Time_off_Territory_AM__c;
            saveEvent.Time_off_Territory_PM__c = eventList.Time_off_Territory_PM__c;
            saveEvent.Category__c = eventList.Category__c;
            
            String strStart = StartDate +' '+ StartTime;
            String strEnd = EndDate+' '+ EndTime;
            
            
            String strSubjct;
            if(eventList.Type__c == null & eventList.Status__c == null){strSubjct = '';}
            else{strSubjct = eventList.Type__c+ '-' +eventList.Status__c;}
             
                     
            Integer hours = Integer.valueOf(strStart.substring(11,13));
               
            
            // Adding 12 in case of PM time
            if (strStart.substring(20,22).equalsIgnoreCase('pm') && hours < 12)
            {
                 hours = hours + 12;
            }
            // Making the hour as 00 for 12AM  
            if (strStart.substring(20,22).equalsIgnoreCase('am') && hours == 12)
            {
                 hours = 00;
            }
            
            // Event Start Date time
            Datetime dt1 = Datetime.newInstance(Integer.valueOf(strStart.substring(6,10)), Integer.valueOf(strStart.substring(0,2)), Integer.valueOf(strStart.substring(3,5)),hours, Integer.valueOf(strStart.substring(14,16)),Integer.valueOf(strStart.substring(17,19)));
                          
            hours = Integer.valueOf(strEnd.substring(11,13));
            
            //Adding 12 in case of PM
            if (strEnd.substring(20,22).equalsIgnoreCase('pm') && hours < 12)
            {
                 hours = hours + 12;
            }
            // Making the hour as 00 for 12AM  
             if (strEnd.substring(20,22).equalsIgnoreCase('am') && hours == 12)
            {
                 hours = 00;
            }
            // Event End Date time
            Datetime dt2 = Datetime.newInstance(Integer.valueOf(strEnd.substring(6,10)), Integer.valueOf(strEnd.substring(0,2)), Integer.valueOf(strEnd.substring(3,5)),hours, Integer.valueOf(strEnd.substring(14,16)),Integer.valueOf(strEnd.substring(17,19)));
            saveEvent.StartDateTime = dt1;
            saveEvent.EndDateTime = dt2;

            String dtStart = strStart.substring(0,2)+'/'+strStart.substring(3,5)+'/'+strStart.substring(6,10) +' '+strStart.substring(11,13)+':'+strStart.substring(14,16)+' '+strStart.substring(20,22);
            String dtEnd = strEnd.substring(0,2)+'/'+strEnd.substring(3,5)+'/'+strEnd.substring(6,10) +' '+strEnd.substring(11,13)+':'+strEnd.substring(14,16)+' '+strEnd.substring(20,22);
            
        
                       
            try {
                 system.debug('saveEvent*****'+saveEvent);                
                 insert saveEvent; 
                 String editUrl = instanceURL+'/'+saveEvent.id+'/e?retURL=apex/AccountContactList';
                 
                 
                 //To get the Contact name from contact ID
                 List<Contact> lstCon= new List<Contact>();
                 String contactname;
                 lstCon = [select name from contact where Id =:eventList.WhoId];
                 if(lstCon.size()>0)
                    {
                         contactName = lstCon[0].name;
                    }
                 //To get the Account name from Account ID
                 List<Account> lstAc= new List<Account>();
                 String accountname;
                 if(eventList.WhatId != null){
                     lstAc = [select name from account where Id =:eventList.WhatId];
                     if(lstAc.size()>0)
                        {
                             accountname = lstAc[0].name;
                        }
                 }
                // In case if any value is null,sending a blank value to JQuery
                String strCallReport;
                  if(saveEvent.Call_Report__c != null){
                      String a  = saveEvent.Call_Report__c;
                      strCallReport = '<a href=/'+a.substring(10,28)+'>Call Report</a>';
                  }
                  else{
                      strCallReport = '';
                  }
                String type;
                if(eventList.Type__c ==  null){type = '';}
                else{type = eventList.Type__c;}
                String callType;
                if(eventList.Call_Type__c ==  null){callType = '';}
                else{callType = eventList.Call_Type__c;}
                String status;
                if(eventList.Status__c ==  null){status = '';}
                else{status = eventList.Status__c;}
                String category;
                if(saveEvent.Category__c ==  null){category = '';}
                else{category = saveEvent.Category__c;}
                String what;
                if(saveEvent.WhatId ==  null){what = '';}
                else{what = '<a href=/'+saveEvent.WhatId+'>'+accountname+'</a>';}
                
                system.debug('whatname**********'+saveEvent.What.Name);
                
                //Inserting values to each property of the inner class
                EventResultReturn evt;
                //if(strEnd.substring(3,5)== strStart.substring(3,5)){
                     evt = new EventResultReturn(
                                                 strSubjct,
                                                 false,
                                                 type,
                                                 callType,
                                                 strSubjct,
                                                 dtStart,
                                                 dtEnd,
                                                 strCallReport,
                                                 UserInfo.getName(),
                                                 status,
                                                 saveEvent.id,
                                                 saveEvent.Time_off_Territory_AM__c,
                                                 saveEvent.Time_off_Territory_PM__c,
                                                 saveEvent.Category__c,
                                                 what,
                                                 '<a href=/'+eventList.WhoId+'>'+contactName+'</a>',
                                                 '<a href=/00U/c?md0='+saveEvent.StartDateTime.Year()+'&md3='+saveEvent.StartDateTime.dayOfYear()+'>Check Availabilty</a>',
                                                 editUrl,
                                                 contactName
                                                );
                //}
                //else{}
                 string  JSONString1 = JSON.serialize(evt);
                 
                 strMsg = JSONString1;
                 
                 system.debug('strMsg*******************'+strMsg);
                 displayEventPopUp = false;
                 
                
               
            } catch(Exception ev) {
                 system.debug('exception*******************'+ev);
                 strMsg = 'Failure';                 
            }    
      
             
     }
    
    //On click of cancel button closing the event pop up
    public void doCancel() {
        displayEventPopUp = false;
         strMsg = 'Cancel';
    }

      
    //To delete  the selected account Record
    public void DeleteAccount(){ 
    List<Account> delAccts = [SELECT Id FROM Account WHERE Id =:SelAccIdToDelete]; 
          
            try {
                    if(delAccts.size()>0){
                       delete delAccts;
                       deletedSelected = true;
                       assignFilter();
                       //strAccDelMsg = 'Deletion Success';
                       
                    }
            } catch (DmlException e) {
               system.debug('error :'+ e);
               strAccDelMsg = 'Account Deletion Failed';
            }

    }   
     //To delete a particular event Record
    public void DeleteEvent(){ 
    List<Event> delevents = [SELECT Id FROM Event WHERE Id =:SelEventIdToDelete]; 
          
            try {
                    if(delevents.size()>0){
                       delete delevents;
                       strEvntDelMsg = 'success';
                      
                    }
            } catch (DmlException e) {
               system.debug('error :'+ e);
               strEvntDelMsg = 'failure';
               
            }

    }
      //builds a picklist of start time
 
   public List<SelectOption> getTime() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('12:00:00 AM','12:00 AM'));
        options.add(new selectOption('12:30:00 AM','12:30 AM'));
        options.add(new selectOption('01:00:00 AM','01:00 AM'));
        options.add(new selectOption('01:30:00 AM','01:30 AM'));
        options.add(new selectOption('02:00:00 AM','02:00 AM'));
        options.add(new selectOption('02:30:00 AM','02:30 AM'));
        options.add(new selectOption('03:00:00 AM','03:00 AM'));
        options.add(new selectOption('03:30:00 AM','03:30 AM'));
        options.add(new selectOption('04:00:00 AM','04:00 AM'));
        options.add(new selectOption('04:30:00 AM','04:30 AM'));
        options.add(new selectOption('05:00:00 AM','05:00 AM'));
        options.add(new selectOption('05:30:00 AM','05:30 AM'));
        options.add(new selectOption('06:00:00 AM','06:00 AM'));
        options.add(new selectOption('06:30:00 AM','06:30 AM'));
        options.add(new selectOption('07:00:00 AM','07:00 AM'));
        options.add(new selectOption('07:30:00 AM','07:30 AM'));
        options.add(new selectOption('08:00:00 AM','08:00 AM'));
        options.add(new selectOption('08:30:00 AM','08:30 AM'));
        options.add(new selectOption('09:00:00 AM','09:00 AM'));
        options.add(new selectOption('09:30:00 AM','09:30 AM'));
        options.add(new selectOption('10:00:00 AM','10:00 AM'));
        options.add(new selectOption('10:30:00 AM','10:30 AM'));
        options.add(new selectOption('11:00:00 AM','11:00 AM'));
        options.add(new selectOption('11:30:00 AM','11:30 AM'));
        options.add(new selectOption('12:00:00 pm','12:00 PM'));
        options.add(new selectOption('12:30:00 PM','12:30 PM'));
        options.add(new selectOption('01:00:00 PM','01:00 PM'));
        options.add(new selectOption('01:30:00 PM','01:30 PM'));
        options.add(new selectOption('02:00:00 PM','02:00 PM'));
        options.add(new selectOption('02:30:00 PM','02:30 PM'));
        options.add(new selectOption('03:00:00 PM','03:00 PM'));
        options.add(new selectOption('03:30:00 PM','03:30 PM'));
        options.add(new selectOption('04:00:00 PM','04:00 PM'));
        options.add(new selectOption('04:30:00 PM','04:30 PM'));
        options.add(new selectOption('05.00:00 PM','05:00 PM'));
        options.add(new selectOption('05:30:00 PM','05:30 PM'));
        options.add(new selectOption('06.00:00 PM','06:00 PM'));
        options.add(new selectOption('06:30:00 PM','06:30 PM'));
        options.add(new selectOption('07:00:00 PM','07:00 PM'));
        options.add(new selectOption('07:30:00 PM','07:30 PM'));
        options.add(new selectOption('08:00:00 PM','08:00 PM'));
        options.add(new selectOption('08:30:00 PM','08:30 PM'));
        options.add(new selectOption('09:00:00 PM','09:00 PM'));
        options.add(new selectOption('09:30:00 PM','09:30 PM'));
        options.add(new selectOption('10:00:00 PM','10:00 PM'));
        options.add(new selectOption('10:30:00 PM','10:30 PM'));
        options.add(new selectOption('11:00:00 PM','11:00 PM'));
        options.add(new selectOption('11:30:00 PM','11:30 PM'));

        return options;
    }
 
// On save of an event sending a JSON object with all the details - start date,end date,account nAMe,
//an inner class is created to define the properties of the  JSON object

public class EventResultReturn {
        String title;
        Boolean allDay;
        String subject;
        String endDate;
        String startDate;
        String type;
        String callType;
        String name;
        String relatedTo;
        String status;
        String eventID;
        String assignedTo;
        Boolean toTAM;
        Boolean toTPM;
        String toTCategory;
        String callReport;
        String editUrl;
        String checkAv;
        String nameCopy;
        
        
              
        public EventResultReturn(String dt19,Boolean dt20,String dt1,String dt2,String dt3,String dt4,string dt5,String dt8,String dt9,String dt10,String dt11,Boolean dt12,Boolean dt13,String dt14,String dt15,String dt16,String dt17,String dt18,String dt21)
        {
            title = dt19;
            allDay =  dt20;
            type = dt1;
            callType = dt2;
            subject = dt3;
            startDate = dt4;
            endDate = dt5;
            callReport = dt8;
            assignedTo = dt9;
            status = dt10;
            eventID = dt11;
            toTAM = dt12;
            toTPM = dt13;
            toTCategory = dt14;
            relatedTo = dt15;
            name = dt16;
            checkAv = dt17;
            editUrl = dt18;
            nameCopy = dt21;
            
        }
    }
    
  //Fetching week events
   public void getWkEvents(){
            fetchCanlenderEvents(strDatePass);
   }

//User pop up
  public User user{get;set;} // new account to create
  public List<User> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
 
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<User> performSearch(string searchString) {
    //searchString= searchString.replace('*','');
    String soql = 'select id, name from User';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString.replace('*','') +'%\'';
    soql = soql +' order by name';
    System.debug(soql);
    return database.query(soql); 
 
  }
 //To get the view name from view id
 private String retrieveFilterName(){
            system.debug('dips**'+strSelectedFilterId);
            if(strSelectedFilterId!= null){
                for(System.SelectOption str:setCon.getListViewOptions()){
                       if((str.getValue()+'').contains(strSelectedFilterId))
                           strFilterName = str.getLabel()+'';
                }
            }
           
            return strFilterName;
 }
  //To get the first column from selected fields
 private String getFirstColumn(String strSelectedFields){
            strSelectedFields = strSelectedFields.split('\\,')[0];
            return strSelectedFields;
 }
}