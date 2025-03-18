public with sharing class SelectFieldsController {

         
    //Holds the list of selected values (ids) in the left list box
    public List<String> leftSelectedValues {get; set;}
    //Holds the list of selected values (ids) in the right list box
    public List<String> rightSelectedValues {get; set;}

    //Holds the list of all values  (ids,values) in the left list box
    public List<SelectOption> LeftListValues { get;set;}
    //Holds the list of all values  (ids,values) in the right list box
    public List<SelectOption> RightListValues { get;set;}
    
    //Hold the error message
    public String strMsg { get;set;}
    //Holds the view name
    public String strViewName { get;set;}
  
    public String strListViewId = apexpages.currentpage().getparameters().get('id');
    
    List<String> selectedFields = new List<String>{'Name','Type','BillingCity','BillingState','BillingCountry','Id'};
    
    //constructor, fetch all the account fields and fill in the left list box
    // move selectedFields from left list box to right list box.
    public SelectFieldsController() {
            Map<String, Schema.SObjectField> mapField = Schema.SObjectType.Account.fields.getMap();  
            LeftListValues = new List<SelectOption>();
            RightListValues = new List<SelectOption>();
            SelectOption SO;
           // strViewName = apexpages.currentpage().getparameters();
            strViewName = apexpages.currentpage().getparameters().get('name');
            if((strViewName == 'All Accounts ')||(strViewName == 'My Accounts ')||(strViewName == 'Recently Viewed Accounts ')) {
                strViewName = strViewName + '& Contacts';
            }
            if(strViewName == 'New Accounts ') {
                strViewName = strViewName + '& Contacts to be verified';
            }
            for(String str:mapField.KeySet() ) {
                SO = new SelectOption(mapField.get(str).getDescribe().getName(),mapField.get(str).getDescribe().getLabel());
                LeftListValues.add(SO);
                SortOptionList(LeftListValues,'Label');
            }
             
            Account_List_View__c[] acctsListView = [SELECT Fields__c FROM Account_List_View__c WHERE View_Id__c=:strListViewId.substring(0,15)];

            if(acctsListView.size() == 0) {
                addToRight(selectedFields); 
            }
            
            else{
                String strFields = acctsListView[0].Fields__c;
                addToRight(strFields.split(',')); 
            }

           // AccountControllerExtn3 aCE = new AccountControllerExtn3();
            
            //strViewName = aCE.retrieveFilterName(strListViewId);
    }   
     
    // method used to move selected left list box values to right list box.
    private void addToRight(List<String> selectedCols){
        for (Integer i=0; i<selectedCols.size(); i++)
        {
            for (Integer j=0;j<LeftListValues.size();j++)
            { 
                if (selectedCols[i] == LeftListValues[j].getValue())
                {
                    RightListValues.add(LeftListValues[j]);
                    LeftListValues.remove(j--);
                    break; 
                }
            }
        }
    }
    
    
    // method used to move selected right list box values to left list box.
    private void addToLeft(List<String> selectedCols){
        for (Integer i=0; i<selectedCols.size(); i++)
        {
           for (Integer j =0;j<RightListValues.size();j++)
           { 
                if (selectedCols[i] == RightListValues[j].getValue()){
                   LeftListValues.add(RightListValues[j]);
                   RightListValues.remove(j--);
                   break; 
                }
           }
        }    
     }
       
  
    // method used to move selected right list box values to Top.
    // if ToTop is true then move the selected values to Top most.
    // else move the selected values to one position up.
     private void moveColsTop(List<String> selectedCols,boolean ToTop){
        Integer k=0;
           for (Integer i=0; i< selectedCols.size(); i++){
               for (Integer j =0;j<RightListValues.size();j++)
                { 
                    if (selectedCols[i] == RightListValues[j].getValue())
                    {
                       if (ToTop) { 
                           RightListValues.add(k++,RightListValues[j]);
                           RightListValues.remove(j+1);
                       } else {
                           if (j>0){
                               RightListValues.add(j-1,RightListValues[j]);
                               RightListValues.remove(j+1);
                            }
                       }
                       break; 
                    }
                }
            }
    }

    // method used to move selected right list box values to Bottom.
    // if ToBottom is true then move the selected values to Bottom most.
    // else move the selected values to one position down.
    private void moveColsBottom(List<String> selectedCols,boolean ToBottom){
           Integer RightListSize = RightListValues.size() -1;
           Integer listsize;
           for (Integer i=0; i< selectedCols.size(); i++)
           {  
               listsize = RightListSize;
               for (Integer j=listsize; j>=0 ; j--)
                { 
                    if (selectedCols[i] == RightListValues[j].getValue()){
                        if (ToBottom){
                           RightListValues.add(RightListValues[j]);
                           RightListValues.remove(j);
                        } else {
                           if (j==listsize-1){
                               RightListValues.add(RightListValues[j]);
                               RightListValues.remove(j);
                           }
                           else if (j<listsize){
                               RightListValues.add(j+2,RightListValues[j]);
                               RightListValues.remove(j);
                           }
                        }
                       break; 
                    }
                }
           }
    }
    
   

    public void assignRight(){
        addToRight(leftSelectedValues);
    }

    public void assignLeft(){
        addToLeft(rightSelectedValues);
    }

    public void moveToTop() {
        moveColsTop(rightSelectedValues,true);
    }
     
    public void moveToBottom() {
      moveColsBottom(rightSelectedValues,true);
    }    
    

    public void moveOneUp() {
        moveColsTop(rightSelectedValues,false);
    }
     
    public void moveOneBottom() {
      moveColsBottom(rightSelectedValues,false);
    }
    public PageReference saveFields(){
        String strNames;
        system.debug('rightlist****'+RightListValues.size());
        if(RightListValues.size() <= 15){
                for(Integer i = 0;i<RightListValues.size();i++){
                    if(strNames == null){
                        strNames = RightListValues[i].getValue();
                    }
                    else{
                        strNames = strNames +','+ RightListValues[i].getValue();
                    }
                    
                }
             
                Account_List_View__c[] acctsList = [SELECT Fields__c FROM Account_List_View__c WHERE View_Id__c=:strListViewId.substring(0,15)];
                for ( Account_List_View__c a : acctsList) {
                    a.Fields__c = strNames;
                }
                
                if(acctsList.size() == 0){
                    Account_List_View__c accListViews = new Account_List_View__c();
                    accListViews.Fields__c = strNames;
                    accListViews.View_Id__c = strListViewId.substring(0,15);
                    acctsList.add(accListViews);
                 }
                
                try {
                    upsert acctsList;
                } catch (DmlException e) {
                    // Process exception here 
                    
                }
                PageReference pageRef = new PageReference('/apex/AccountContactList?fcf='+strListViewId.substring(0,15));
                return pageRef;
        }
        else{
                
                strMsg = 'You cannot display more than 15 fields.';
                return null;
        }
    } 
    public PageReference doCancel(){
        PageReference pageRef = new PageReference('/apex/AccountContactList?fcf='+strListViewId.substring(0,15));
        return pageRef;
    }
    //For sorting list of available fields alphabetically
    public void SortOptionList(List<Selectoption> opts, String sortField) {
        
        Map<String, Selectoption> mapping = new Map<String, Selectoption>();
        // Suffix to avoid duplicate values like same labels or values are in inbound list
        Integer suffix = 1;
        for (Selectoption opt : opts) {
            if (sortField == 'Label') {
                mapping.put( // Done this cryptic to save scriptlines, if this loop executes 10000 times
                 // it would every script statement would add 1, so 3 would lead to 30000.
                 (opt.getLabel() + suffix++), // Key using Label + Suffix Counter
                 opt);
            } else {
                mapping.put(
                 (opt.getValue() + suffix++), // Key using Label + Suffix Counter
                 opt);
            }
        }
        
        List<String> sortKeys = new List<String>();
        sortKeys.addAll(mapping.keySet());
        sortKeys.sort();
        // clear the original collection to rebuilt it
        opts.clear();
        
        for (String key : sortKeys) {
            opts.add(mapping.get(key));
        }
    }
 
}