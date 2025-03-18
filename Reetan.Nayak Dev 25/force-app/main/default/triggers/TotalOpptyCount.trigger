trigger TotalOpptyCount on Opportunity (after Insert, after Update, after Delete, after Undelete) {
    
    Set<Id> accId = new Set<Id>();
    List<Account> accList = new List<Account>();
    
    if(Trigger.isInsert || Trigger.isUpdate){
        for(Opportunity opp1 : Trigger.New){
            if(opp1.AccountId != null){
                accId.add(opp1.AccountId);
            }
        }
    }
    
    if(Trigger.isDelete){
        for(Opportunity opp2 : Trigger.Old){
            if(opp2.AccountId != null){
                accId.add(opp2.AccountId);
           	}
        }
    }
    
    List<Account> accountList = [Select Total_Oppty_Count__c, (Select Id from Opportunities) from Account where Id =:accId];
    
    for(Account acc: accountList){
        acc.Total_Oppty_Count__c = acc.Opportunities.size();
        accList.add(acc);
    }
    update accList;
}