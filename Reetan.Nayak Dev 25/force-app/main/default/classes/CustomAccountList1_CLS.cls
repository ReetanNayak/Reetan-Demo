public class CustomAccountList1_CLS {

    public CustomAccountList1_CLS(ApexPages.StandardController controller) {

    }

    public string AccName {get; set;}
    private final Account accn;
    public Id SelAccIdToDelete{ get; set; }
    public boolean check = false;
    public CustomAccountList1_CLS() {
    }
    
   
      public ApexPages.StandardSetController AccRecords {
        get {
            if(AccRecords == null) {
               AccRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name, BillingCity, BillingState, Phone, AccountNumber, Site FROM Account order by Name]));
               if(selectedid != null){AccRecords.setFilterId(selectedid);}
               AccRecords.setPageSize(10);
               AccRecords.setPageNumber(0);
            }
            else{ 
            
            if(check){
                        AccRecords = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Name, BillingCity, BillingState, Phone, AccountNumber, Site FROM Account order by Name]));
                        //AccRecords.setPageSize(10);
                        //AccRecords.setPageNumber(0);
                        check = false;
                    }
            else{}
                if(selectedid != null){AccRecords.setFilterId(selectedid);}
            }
             
                            
           
            system.debug('hellooooooooooooo'+selectedid);
            return AccRecords;
        }
        set;
    }
    
    public List<Account> getAccountTable() {
        return (List<Account>) AccRecords.getrecords();
    }
    
    
    public void firstButton() {
        AccRecords.first();
    }
    
    public void previousButton() {
        AccRecords.previous();
    }
    
    public void nextButton() {
        AccRecords.next();
    }
    
    public void lastButton() {
        AccRecords.last();
    }  
    
    public Boolean disablePrevious {
        get {
            return AccRecords.getHasPrevious();
        }
        set;
    }    
    
    public Boolean disableNext {
        get {
            return AccRecords.getHasNext();
        }
        set;
    }  
    
    public Integer pageNo {
        get {
            return AccRecords.getPageNumber();
        }
        set;
    }  
    
    public Integer totalRecords {
        get {
            return AccRecords.getResultSize();
        }
        set;
    }   
    
    public Integer pageSize {
       get {
            return AccRecords.getPageSize();
        }
        set;
    }
    
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
    
    public Integer nextRecord {
        get {
            if(totalRecords != 0){
            Integer nr = (pageNo - 1)*pageSize + 1;
            return nr;
            }
            else{return 0;}
        }
        set;
    }
    
    public Integer lastRecord {
        get {
            if(totalRecords > pageSize){
            Integer nL = (pageNo * pageSize);
            return nL;
            }
            else{return totalRecords;}
        }
        set;
    }           
    
 public string  selectedid{get;set;}
    public List<SelectOption> ipadlistviewoptions {
        get {
            
            return AccRecords.getListViewOptions();
        }
        set;
    }   
  public ID selectedvalue{
        get {
            return AccRecords.getFilterID();
        }
        set;
    }  
 public void DeleteAccount(){   
    List< Account> delAccts = [SELECT Id, Name FROM Account 
                         WHERE Id =:SelAccIdToDelete]; 
    system.debug('test*******'+SelAccIdToDelete);
    try {
    if(delAccts.size()>0)
        delete delAccts;
        check = true;
    } catch (DmlException e) {
    // Process exception here 
    
    }
    
     }
   /* // if for any reason we are missing the reference       
    if (SelAccIdToDelete== null) {              
     return;      
     }           
    // find the account record within the collection      
    Account tobeDeleted = null;
      
    for(Account a : accRecords.getrecords())       
        if (a.Id == SelAccIdToDelete) {          
            tobeDeleted = a;          
            break;       
        }            
    //if account record found delete it      
    if (tobeDeleted != null) {       
        Delete tobeDeleted;      
    }           
   }    */

 
}