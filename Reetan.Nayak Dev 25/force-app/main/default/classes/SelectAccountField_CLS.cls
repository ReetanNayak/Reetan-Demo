public with sharing class SelectAccountField_CLS {

    public String strFields = '';
    public String strQuery;
    public List<String> colNames {get;set;}
    public List<String> colNames1 {get;set;}
    public List<categoryWrapper> lstAccountFields{get;set;}
    public sObject Account_Cols = null;
    public SelectAccountField_CLS(ApexPages.StandardController controller) {

    }
    public List<Account> accountObj;
    public Map<String, Schema.SObjectField> mapFields {get;set;}      
    
    public ApexPages.StandardSetController accountRecords{
        get {
            if(accountRecords == null) {
            
                //On page load this query will run by default
                if(strFields == ''){
                    
                    system.debug('static query*******');
                    strQuery = 'SELECT name,Type,industry,BillingCity,BillingState, Phone, AccountNumber, Site FROM Account';
                }
                //On select of fields the dynamic query will run
                else{
                    system.debug('dynamic query*******');
                    strQuery = 'SELECT name,'+strFields+' FROM Account';
                }
                accountRecords = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));
            }
            else{
                //On page load this query will run by default
                if(strFields == ''){
                    
                    system.debug('static query*******');
                    strQuery = 'SELECT name,Type,industry,BillingCity,BillingState, Phone, AccountNumber, Site FROM Account';
                }
                //On select of fields the dynamic query will run
                else{
                    system.debug('dynamic query*******');
                    strQuery = 'SELECT '+strFields+' FROM Account';
                }
                accountRecords = new ApexPages.StandardSetController(Database.getQueryLocator(strQuery));
            
            }
            
           
            List<Account> a =  accountRecords.getRecords();
            if (a.size()>0){
                Account_Cols = a.get(0);
            }
            //Getting the columns from the query
            lstAccountFields = new List<categoryWrapper>();
            Map<String, Schema.SObjectField> M = Schema.SObjectType.Account.fields.getMap();
            colNames  = new List<String>();
             colNames1  = new List<String>();
            for (String s: M.keySet())
            {
                try{
                     Account_Cols.get(M.get(s));
                     colNames.add(M.get(s).getDescribe().getLabel()+'');
                     lstAccountFields.add(new CategoryWrapper(M.get(s)+'',M.get(s).getDescribe().getLabel()+''));
                     colNames1.add(M.get(s)+'');
                     system.debug('Key is :' + s + ' value is :' + M.get(s).getDescribe().getLabel());
                }catch(Exception er){
                    
                }
            }  
            system.debug('columns'+colNames);
            
            return accountRecords;
        }
        private set;
    }
    public List<Account> getaccTable() {
         return (List<Account>) accountRecords.getRecords();
    } 
    public boolean displayPopUp{get;set;} 
//for showing the pop up   
   public void openPopUp(){
         displayPopUp = true;
    }
//for closing the pop up   
     public void closePopUp(){
      displayPopUp = false;  
    }
    // Using wrapper class to get the name and labels of fields in account
   List<categoryWrapper> AccFields{get;set;}
  
   
   public List<categoryWrapper> getAccFields() {
        AccFields = new List<categoryWrapper>();
        mapFields = Schema.SObjectType.Account.fields.getMap();
        for (String s: mapFields.keySet())
            {
                  //AccFields.add(new CategoryWrapper(mapFields.get(s).getDescribe().getName(),mapFields.get(s).getDescribe().getLabel()));
                  AccFields.add(new CategoryWrapper(mapFields.get(s).getDescribe().getName(),mapFields.get(s).getDescribe().getLabel()));
            }   
        return AccFields;
    }
// on click of save getting the fields selected.
   public void saveFields(){
      strFields = '';
      system.debug('in save fields function');
      for (categoryWrapper cW:AccFields) {
           if(cW.valChecked == true){
               if(strFields == ''){
                   strFields = cW.strFieldName;
                    system.debug(' field Name  : ' + cW.valChecked  + ' selected :' +cW.strFieldName);
               }
               else{
                   strFields = strFields +','+ cW.strFieldName;
               }
           }
           system.debug(' field Name  : ' + cW.strFieldValue + ' selected :' +cW.strFieldName );
       }
       system.debug('strFields:'+strFields);
       displayPopUp = false;
   
   }
  
}