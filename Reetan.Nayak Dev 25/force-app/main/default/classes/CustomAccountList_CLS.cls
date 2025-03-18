//The extension class named 'CustomAccountList_CLS  ' fetch account records and display in the vf  page named CustomAccountList .
public with sharing class CustomAccountList_CLS {

        // Venu
    // holds selected column name from the account list
    private String queryColumnName = 'Name';
    // holds accending or decending order value on the selected column name from the account list
    private String queryColumnOrderBy = 'asc';
    
    // holds the selected column name from the account list for sorting.
    public String SortColName { get; set;}
    // holds the selectd filter key from filter links (A to Z, Other, All)
    public String filterKey { get;set;}
    
    // holds the column sort order ('asc' | ' desc')
    public String strAscDesc { get; set; }
    
    // holds the list of Account Object filtered from the FilteredID combo box
    public List<Account> AccontListRows = new List<Account>();

    private final String BaseQuery = 'Select Name, Type, BillingCity, BillingState, BillingCountry from Account order by Name';


    public CustomAccountList_CLS    (ApexPages.StandardController controller) {
    }


    public CustomAccountList_CLS    (ApexPages.StandardSetController controller) {
            queryString = BaseQuery;
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
            setCon.setPageSize(listRowSize);
                    //Now keeping the filter id static on load of the page
                    /*
                            setCon.setFilterId(strFilterId);
                    */
            strSelectedFilterId = '00B90000002Y9Hz';
            setCon.setFilterId(strSelectedFilterId);
            noOfRecords = setCon.getresultSize();
            fetchColNames();
            SortColName = queryColumnName;
            strAscDesc  = queryColumnOrderBy;
            AccontListRows = fetchAccontListRows();
    }
    
    
    
     // Check for delete status from list box, if delete option clicked then deletedSelected = true else deletedSelected = false
    public boolean deletedSelected = false;
    
     //for selected account id to store
     public Id SelAccIdToDelete{ get; set; }
     
    // Set the list row size to constant 
    private final Integer listRowSize = 10;
    
    //Instance of the wrapper class called AccountWrapper --- Used to store the checkbox value for each records 
    List<AccountWrapper> lstAccWrp {get;set;}
    
    //For storing the total count of records fetched by query
    Public Integer noOfRecords{get; set;}

    //For storing the list view selected from picklist 
    public String strSelectedFilterId{get;set;}
    
    //to hide /show the pop up 
    public boolean blDisplayPopUp{get;set;} 
    
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
    public static String strMessage {get;set;}
    
    
    
    public ApexPages.StandardSetController setCon {
        get{
            return setCon;
        }set;
    }

  // Venu

    // holds all the Accout Object column name and values.
    private  final Map<String, Schema.SObjectField> accountFieldsMap = Schema.SObjectType.Account.fields.getMap();
  // holds boolean value if account filter combo box selected

  // Method is used to fetch the dynamic column names from the StandardSetController account object
     private void fetchColNames(){
            sObject Account_Cols = null;
            if (setCon.getresultSize() > 0){
                Account_Cols = setcon.getRecords().get(0);
            }
            //Getting the columns from the query
            lstAccountFields = new List<categoryWrapper>();
            lstAccountFields.add(new CategoryWrapper(accountFieldsMap.get('name') +'',accountFieldsMap.get('name').getDescribe().getLabel()+''));
            for (String s: accountFieldsMap.keySet())
            {
                try{
                    if(s!='Name') {
                         Account_Cols.get(accountFieldsMap.get(s));
                         lstAccountFields.add(new CategoryWrapper(accountFieldsMap.get(s)+'',accountFieldsMap.get(s).getDescribe().getLabel()+''));
                    }
                }catch(Exception er){
                    
                }
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
            if (SortColName== null ) {           SortColName='name';           }
            if (queryColumnName == SortColName && queryColumnOrderBy =='asc'){
               AssDesc = 'desc';
            }
            queryColumnName = SortColName;
            queryColumnOrderBy = AssDesc;
            strAscDesc  = queryColumnOrderBy;
            String compStr;

            system.debug(' sort Column is  :'+ queryColumnName );
            system.debug(' sort order  is  :'+ queryColumnOrderBy);
                     
            for (i = 1; i <= n; i++) 
            {  
                for (j = n; j >= i ; j--) 
                {
                    //system.debug('object value is :' + accList[j].get(SortColName));
                    if (queryColumnOrderBy == 'desc') 
                    {
                        if (sortAccList[j].get(SortColName)+'' >= sortAccList[j-1].get(SortColName)+'') 
                        {
                                temp = sortAccList[j-1];
                                sortAccList[j-1] = sortAccList[j];
                                sortAccList[j] = temp;
                        }    
                    } 
                    else 
                    {
                       if (sortAccList[j].get(SortColName)+'' <= sortAccList[j-1].get(SortColName)+'') 
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
            system.debug('Error Venu :' + er);
        }
    }
     
     
     
     
     

    //for showing the pop up   
    public void openPopUp(){
        blDisplayPopUp = true;
    }
    //for closing the pop up   
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
            return nL;
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
    
    // on click of save in the pop up getting the fields which are checked.
    public void saveFields(){
      strFields = '';
      system.debug('in save fields function');
      for (categoryWrapper cW:lstAccFields) {
           if(cW.valChecked == true){
               if(strFields == ''){
                   strFields = cW.strFieldName;
               }
               else{
                    if(cW.strFieldName != 'name'){
                            strFields = strFields +','+ cW.strFieldName;
                    }
               }
           }
           system.debug(' field Name  : ' + cW.strFieldValue + ' selected :' +cW.strFieldName );
       }
       system.debug('strFields:'+strFields);
        
        queryColumnName = 'Name';
        queryColumnOrderBy = 'asc';
        SortColName = queryColumnName;
        strAscDesc  = queryColumnOrderBy;

        if(strFields == ''){
            system.debug('static query*******');
            queryString = BaseQuery;
            fetchColNames();
        }
        //On select of fields  in the pop up the dynamic query will run
        else{
            setCon = null;
            system.debug('dynamic query*******');
            queryString = 'SELECT name,'+strFields+' FROM Account';
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));                       
            setCon.setPageSize(listRowSize);
            setcon.setFilterId(strSelectedFilterId);
            fetchColNames();
        }
       blDisplayPopUp = false;
    }
    
    
 //To assign the filter on change of list view from dropdown    
    public void assignFilter(){
          system.debug('inside assignFilter : '+strSelectedFilterId);
        queryColumnName = 'Name';
        queryColumnOrderBy = 'asc';
        SortColName = queryColumnName;
        strAscDesc  = queryColumnOrderBy;
        if(strSelectedFilterId != null){
                 system.debug('Filter***'+strSelectedFilterId);
                 setcon.setFilterId(strSelectedFilterId);
        } 
        //system.debug(' Inside assignFilter :' + ' Filter id is :' + strSelectedFilterId);
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        setCon.setPageSize(listRowSize);
        setcon.setFilterId(strSelectedFilterId);
        setCon.first();
        AccontListRows = fetchAccontListRows();
   }
   
   
   
   

    //An instance of Event object
    public Event eventList;
    
   
    //To set values to Event as default on load of the pop up
    public Event getEvents() {
    
           eventList=new Event();
           system.debug('selectedAccountID11111111***********'+selectedAccountID);
           eventList.ownerId= UserInfo.getUserId();
           
           if((selectedAccountID == null) || (selectedAccountID == '')){}
           else
           {
                eventList.WhatId = selectedAccountID;
           }
          
          return eventList;
    }

    //For displaying the event pop up
    public void doPopUp() {
        
        displayEventPopUp = true;
    }
    
    // An instance of event object
    public event saveEvent;
    
    //For saving a particular event on click of save button
       public void doSave() {
          
            saveEvent= new event();
            saveEvent.ownerId=eventList.ownerid;
            saveEvent.Subject = eventList.Subject;
            saveEvent.WhoId = eventList.WhoId;
            saveEvent.WhatId = eventList.WhatId;
            
            String strStart = StartDate +' '+ StartTime;
            system.debug('Start*******************'+strStart);
            String strEnd = EndDate+' '+ EndTime;
            system.debug('Start*******************'+strEnd);
                     
            Integer hours = Integer.valueOf(strStart.substring(11,13));
               
            system.debug(' AM/PM are :'+ strStart.substring(20,22) + ' # hours :' + hours);
            
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
            system.debug(' AM/PM are :'+ strEnd.substring(20,22) + ' # hours :' + hours);
            
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
            system.debug('date1******'+dt1);
            system.debug('date2****'+dt2);
            saveEvent.StartDateTime = dt1;
            saveEvent.EndDateTime = dt2;
            //saveEvent.DurationInMinutes = 60;
            
                       
            try {
                 system.debug('save*******************'+saveEvent);
                 insert saveEvent; 
                 
                EventResultReturn inv1 = new EventResultReturn(eventList.Subject,dt1.format(),dt2.format(),selectedAccountName);
                String JSONString = JSON.serialize(inv1);
                
                strMessage = JSONString;
                
                system.debug('strMessage*******************'+strMessage);
               
            } catch(Exception ev) {
                 system.debug('exception*******************'+ev);
                 strMessage = 'Failure: '+ev;
            }    
      
             displayEventPopUp = false;
     }
    
    //On click of cancel button closing the event pop up
    public void doCancel() {
        displayEventPopUp = false;
        system.debug('hello');
    }
    
      
    //To delete  the selected account Record
    public void DeleteAccount(){ 
    List<Account> delAccts = [SELECT Id FROM Account WHERE Id =:SelAccIdToDelete]; 
          
            try {
                    if(delAccts.size()>0){
                       delete delAccts;
                       deletedSelected = true;
                       assignFilter();
                       //setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));  
                       //setcon.setFilterId(strSelectedFilterId);
                    }
            } catch (DmlException e) {
               system.debug('error :'+ e);
            }

    }   
      //builds a picklist of start time
 
   public List<SelectOption> getTime() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('12.00 am','12.00 am'));
        options.add(new selectOption('12.30 am','12:30 am'));
        options.add(new selectOption('01.00 am','01:00 am'));
        options.add(new selectOption('01.30 am','01:30 am'));
        options.add(new selectOption('02.00 am','02:00 am'));
        options.add(new selectOption('02.30 am','02:30 am'));
        options.add(new selectOption('03.00 am','03:00 am'));
        options.add(new selectOption('03.30 am','03:30 am'));
        options.add(new selectOption('04.00 am','04:00 am'));
        options.add(new selectOption('04.30 am','04:30 am'));
        options.add(new selectOption('05.00 am','05:00 am'));
        options.add(new selectOption('05.30 am','05:30 am'));
        options.add(new selectOption('06.00 am','06:00 am'));
        options.add(new selectOption('06.30 am','06:30 am'));
        options.add(new selectOption('07.00 am','07:00 am'));
        options.add(new selectOption('07.30 am','07:30 am'));
        options.add(new selectOption('08.00 am','08:00 am'));
        options.add(new selectOption('08.30 am','08:30 am'));
        options.add(new selectOption('09.00 am','09:00 am'));
        options.add(new selectOption('09.30 am','09:30 am'));
        options.add(new selectOption('10.00 am','10:00 am'));
        options.add(new selectOption('10.30 am','10:30 am'));
        options.add(new selectOption('11.00 am','11:00 am'));
        options.add(new selectOption('11.30 am','11:30 am'));
        options.add(new selectOption('12.00 pm','12:00 pm'));
        options.add(new selectOption('12.30 pm','12:30 pm'));
        options.add(new selectOption('01.00 pm','01:00 pm'));
        options.add(new selectOption('01.30 pm','01:30 pm'));
        options.add(new selectOption('02.00 pm','02:00 pm'));
        options.add(new selectOption('02.30 pm','02:30 pm'));
        options.add(new selectOption('03.00 pm','03:00 pm'));
        options.add(new selectOption('03.30 pm','03:30 pm'));
        options.add(new selectOption('04.00 pm','04:00 pm'));
        options.add(new selectOption('04.30 pm','04:30 pm'));
        options.add(new selectOption('05.00 pm','05:00 pm'));
        options.add(new selectOption('05.30 pm','05:30 pm'));
        options.add(new selectOption('06.00 pm','06:00 pm'));
        options.add(new selectOption('06.30 pm','06:30 pm'));
        options.add(new selectOption('07:00 pm','07:00 pm'));
        options.add(new selectOption('07:30 pm','07:30 pm'));
        options.add(new selectOption('08:00 pm','08:00 pm'));
        options.add(new selectOption('08:30 pm','08:30 pm'));
        options.add(new selectOption('09:00 pm','09:00 pm'));
        options.add(new selectOption('09:30 pm','09:30 pm'));
        options.add(new selectOption('10:00 pm','10:00 pm'));
        options.add(new selectOption('10:30 pm','10:30 pm'));
        options.add(new selectOption('11:00 pm','11:00 pm'));
        options.add(new selectOption('11:30 pm','11:30 pm'));

        return options;
    }
 
// On save of an event sending a JSON object with all the details - start date,end date,account name,
//an inner class is created to define the properties of the  JSON object

public class EventResultReturn {
        String subject;
        String endDate;
        String startDate;
        String accNm;
        
        public EventResultReturn(String i,String dt1,String dt2,String dt3)
        {
            subject = i;
            startDate = dt1;
            endDate= dt2;
            accNm = dt3;
        }
    }
}