public class TotalContactCount {
    
    @future
    public static void countContacts(List<Id> accId){
        List<Account> accountList = new List<Account>();
        for(Id aId: accId){
            Account acc = [Select Id, Name from Account where Id=:aId];
            acc.Total_Contact_Count__c = [Select Count() from Contact where AccountId =: aId];
            accountList.add(acc);
        }
        update accountList;
    }	
    
    public TotalContactCount(){
        List<Account> accList = [select Id from Account];
        List<Id> accId = new List<Id>();
        for(Account a : accList){
            accId.add(a.Id);
        }
        
        TotalContactCount.countContacts(accId);
    }  
    
}