//The extension class named 'AccountControllerExtn' fetch account records and display in the vf  page named CustomAccountList .
public with sharing class AccountList_CLS{

    public AccountList_CLS(ApexPages.StandardSetController controller) {

    }
    //Instance of the wrapper class called AccountWrapper --- Used to store the checkbox value for each records 
    List<AccountWrapper> lstAccWrp {get;set;}
    //For storing the total count of records fetched by query
    Public Integer noOfRecords{get; set;}
    //For setting the page size
    Public Integer size{get;set;}
    //For storing the list view selected from picklist 
    public String strSelectedFilterId{get;set;}
    //to hide /show the pop up 
    public boolean blDisplayPopUp{get;set;} 
    //To store the fields selected in a concatenated string
    public String strFields = '';
    //Query string - for dynamically passing the string to query
    public String queryString;
    //For storing the account fields 
    public Map<String, Schema.SObjectField> mapFields {get;set;}
    //An instance of the wrapper class to store the field names and labels of account object
    public List<categoryWrapper> lstAccountFields{get;set;}
    //An instance of Sobject
    public sObject Account_Cols = null;
    //The filter ID to be fetched after redirecting from the previous account home page
    public string strFilterId;
    //strFilterId = ApexPages.currentPage().getParameter().get('fcf');
    // fetching Account records by soql query
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                    size = 10;
                    queryString = 'Select Name, Type, BillingCity, BillingState, BillingCountry from Account order by Name';
                    setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                    setCon.setPageSize(size);
                    //Now keeping the filter id static on load of the page
                    /*
                            setCon.setFilterId(strFilterId);
                    */
                    setCon.setFilterId('00B90000002Y9Hz');
                    noOfRecords = setCon.getresultSize();
            }
            else{
                    system.debug('inside else'+strSelectedFilterId);
                    size = 10;
                    
                  if(strSelectedFilterId != null){
                             system.debug('Filter***'+strSelectedFilterId);
                             setcon.setFilterId(strSelectedFilterId);
                  } 
            }
            List<Account> lstAccrecords =  setcon.getRecords();
            if (lstAccrecords.size()>0){
                Account_Cols = lstAccrecords.get(0);
            }
            //Getting the columns from the query
            lstAccountFields = new List<categoryWrapper>();
            Map<String, Schema.SObjectField> accountMap = Schema.SObjectType.Account.fields.getMap();
            for (String s: accountMap.keySet())
            {
                try{
                     Account_Cols.get(accountMap.get(s));
                     lstAccountFields.add(new CategoryWrapper(accountMap.get(s)+'',accountMap.get(s).getDescribe().getLabel()+''));
                     system.debug('Key is :' + s + ' value is :' + accountMap.get(s).getDescribe().getLabel());
                }catch(Exception er){
                    
                }
            } 
            return setCon;
        }set;
    }
    // on laod of account table this method calls ---- return list of account records.
    Public List<Account> getAccounts(){
        List<Account> accList = new List<Account>();
        for(Account a : (List<Account>)setCon.getRecords())
            accList.add(a);
        return accList;
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
    
    // on click of save getting the fields selected.
    public void saveFields(){
      strFields = '';
      system.debug('in save fields function');
      for (categoryWrapper cW:lstAccFields) {
           if(cW.valChecked == true){
               if(strFields == ''){
                   strFields = cW.strFieldName;
               }
               else{
                   strFields = strFields +','+ cW.strFieldName;
               }
           }
           system.debug(' field Name  : ' + cW.strFieldValue + ' selected :' +cW.strFieldName );
       }
       system.debug('strFields:'+strFields);
       if(strFields != ''){
                            setCon = null;
                            system.debug('dynamic query*******');
                            queryString = 'SELECT '+strFields+' FROM Account';
                            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));                       
                            setCon.setPageSize(10);
                            setCon.setPageNumber(1);
                            system.debug('strSelectedFilterId******'+strSelectedFilterId);
                                                    
                        }
                        setcon.setFilterId(strSelectedFilterId);
       blDisplayPopUp = false;
    }
    
        
    //For refreshing the account list
    public pageReference refresh() {
        setCon = null;
        getAccounts();
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
    //To getting the list views
     public List<SelectOption> lstIpadListViewOptions {
        get {
            
            return setCon.getListViewOptions();
        }
        set;
    }
    
    // For binding the checkbox with the list 
    public List<AccountWrapper> getAccountsWrp() {
        lstAccWrp = new List<AccountWrapper>();
        for (Account acc : (List<Account>)setCon.getRecords())
            lstAccWrp.add(new AccountWrapper(acc));
            
        return lstAccWrp;
    }

}