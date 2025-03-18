trigger AccountAddressTrigger on Account (Before Insert, Before Update) {
    //if(trigger.isUpdate){
        /* List<Account> accList = [Select Id, Name, Match_Billing_Address__c, BillingPostalCode, ShippingPostalCode from Account where Id='0019000000D0BXE'];
        for(Account a: accList){
            if(a.Match_Billing_Address__c == True){
                a.ShippingPostalCode = a.BillingPostalCode;
                update a;
            }
        }   */ 
        
        for(Account a: Trigger.New){
            if(a.Match_Billing_Address__c == True){
                 a.ShippingPostalCode = a.BillingPostalCode;
              //  update a;
            }
            else{
                a.ShippingPostalCode = null;
            }
        }         
    //}

}