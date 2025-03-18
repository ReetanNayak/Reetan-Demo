/*
Asynchronous Apex = 4. Control Processes with Queueable Apex

Apex Class: AddPrimaryContact
Test Class: AddPrimaryContactTest
*/

@isTest
public class AddPrimaryContactTest {

    public static testMethod void AddPrimaryContactTest_Test(){
        List<Account> lstAcc = new List<Account>();
        for(Integer i=0; i<50; i++){
            Account a1 = new Account();
            a1.Name = 'Test1'+i;
            a1.BillingState = 'NY';
            lstAcc.add(a1);
        }

        for(Integer j=0; j<50; j++){
            Account a2 = new Account();
            a2.Name = 'Test2'+j;
            a2.BillingState = 'CA';
            lstAcc.add(a2);
        }
        insert lstAcc;

        Contact cont = new Contact();
        cont.firstName = 'Reet';
        cont.LastName = 'Nayak';

        string strState = 'CA';

        AddPrimaryContact apc = new AddPrimaryContact(cont, strState);
        Test.startTest();
        system.enqueueJob(apc);
        Test.stopTest();
    }

}