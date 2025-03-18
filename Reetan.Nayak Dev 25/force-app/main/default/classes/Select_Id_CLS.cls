public class Select_Id_CLS {

public string  selectedid{get;set;}
public boolean check = false;

    public Select_Id_CLS(ApexPages.StandardController controller) {

    }
    
    public Select_Id_CLS() {
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
    
}