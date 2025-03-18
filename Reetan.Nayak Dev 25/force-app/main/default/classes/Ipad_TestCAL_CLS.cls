public with sharing class Ipad_TestCAL_CLS {
  
List<Account> Accounts {get;set;}
public ApexPages.StandardSetController Oacc {
        get {
            if(Oacc == null) {
                Oacc = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT ID, Name, BillingCity, BillingState, Phone, Type FROM Account Order By Name limit 100]));
                 Oacc.setPageSize(5);
            }
            return Oacc ;
        }
        set;
    }
     public List<Account> getAccount(){
         
         return (List<Account>) Oacc.getRecords();
     }


public Boolean hasNext {
        get {
            return Oacc.getHasNext();
        }
        set;
    }

    public Boolean hasPrevious {
        get {
            return Oacc.getHasPrevious();
        }
        set;
    }
 

    public Integer pageNumber {
        get {
            return Oacc.getPageNumber();
        }
        set;
    }
 
 
    public void first() {
        Oacc.first();
    }
 
 
    public void last() {
        Oacc.last();
    }
 
 
    public void previous() {
        Oacc.previous();
    }
 
 
    public void next() {
        Oacc.next();
    }

public void CreateCalenderEvent(){        
        String accid = System.currentPageReference().getParameters().get('accId');
        String accName =System.currentPageReference().getParameters().get('accName');        
        
    } 

}