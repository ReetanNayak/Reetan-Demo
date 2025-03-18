/*
Asynchronous Apex = 2. Use Future Methods

Apex Class: AccountProcessor
Test Class: AccountProcessorTest
*/

public class AccountProcessor {

    @future
    public static void countContacts(Set<Id> setIds){
        List<Account> lstAcc = [Select Id, Name, Number_of_Contacts__c, (Select Id from Contacts) from Account where ID IN:setIds];

        for(Account acc:lstAcc){
            acc.Number_of_Contacts__c = acc.Contacts.Size();
        }
        update lstAcc;
    }

}