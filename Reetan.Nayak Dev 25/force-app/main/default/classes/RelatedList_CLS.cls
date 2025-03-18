public class RelatedList_CLS {

    private List<Opportunity> oppz;
    private Contact cntact; 
    
    public RelatedList_CLS(ApexPages.StandardController controller) {
        this.cntact= (Contact)controller.getRecord();
    }
    
    public List<Opportunity> getOppz() {
        Contact con = [Select id, name, Account.id FROM Contact where id =:cntact.id ];
        if (con.Account == null)
            return null;    
            
        oppz = [Select id, Name, Account.Name, CloseDate, Amount, Type from Opportunity where Account.id =:con.Account.id];
            return oppz;
    }    
}

/*
public class RelatedList_CLS {
    
    private List<Opportunity> oppty1;
    private Contact cont1;
    
    public RelatedList_CLS(ApexPages.StandardController controller) {
     //   this.cont = (Contact).controller.getRecord();
    }
    
    public List<Opportunity> getOppty2() {
        Contact cont2 = [select Id, Account.Id from Contact where Id=: cont1.Id];
        
        if(cont2.Account == null)
            return null;    
    
        oppty1 = [Select Id, Name, Account.Name, CloseDate, Amount, Type from Opportunity order by Name ];
        
        return oppty1;
    }
}    */