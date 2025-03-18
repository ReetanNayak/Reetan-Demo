/*
Asynchronous Apex = 2. Use Future Methods

Apex Class: AccountProcessor
Test Class: AccountProcessorTest
*/


@isTest
public class AccountProcessorTest {

    public static testMethod void AccountProcessorTest_Test(){
        Account acc = new Account();
        acc.Name = 'Reetan Nayak';
        insert acc;

        Contact con = new Contact();
        con.firstName = 'Reet';
        con.LastName = 'Saha';
        con.AccountId = acc.Id;
        insert con;        

        set<Id> setAccId = new set<Id>();
            setAccId.add(acc.Id);
        
        Test.startTest();
        AccountProcessor.countContacts(setAccId);
        Test.stopTest();

        Account acc1 = [select Id, Number_of_Contacts__c from Account where Id =:acc.Id limit 1];
        system.assertEquals(Integer.valueOf(acc1.Number_of_Contacts__c), 1);
    }

}