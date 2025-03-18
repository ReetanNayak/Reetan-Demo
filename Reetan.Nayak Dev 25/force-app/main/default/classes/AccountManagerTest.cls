/*
TrailHead = Apex Integration Services
			 (D) Apex Web Services

Apex Class: AccountManager
Test Class: AccountManagerTest
*/

/*
@isTest
Private class AccountManagerTest {
	
    // @HttpGet: To READ the Case record.
    @isTest static void testGetAccount(){
    	Id recId = CreateAccountRecord();
    	// Set up a test request
    	RestRequest req = new RestRequest();  
        req.requestURI = 'https://reetan-dev-ed.salesforce.com/services/apexrest/Accounts/'+ recId + '/Contacts';
        req.httpMethod = 'GET';
        RestContext.request = req;
        
        // Call the method to test
        Account thisAcc = AccountManager.getAccount();
        system.assert(thisAcc != null);
        system.assertEquals('Reet Test', thisAcc.Name);
    }
    
    // Helper Method
    Static Id CreateAccountRecord(){
        Account acc = new Account();
        acc.Name = 'Reet Test';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Reet1';
        con.LastName = 'Nayak1';
        con.AccountId = acc.Id;
        insert con;
        
        return acc.Id;
    }
} */

@isTest 
private class AccountManagerTest{
    static testMethod void testMethod1(){
        Account objAccount = new Account(Name = 'test Account');
        insert objAccount;
        Contact objContact = new Contact(LastName = 'test Contact', AccountId = objAccount.Id);
        insert objContact;
        
        Id recordId = objAccount.Id;
        RestRequest request = new RestRequest();
        
        request.requestUri = 'https://reetan-dev-ed.salesforce.com/services/apexrest/Accounts/'+ recordId +'/contacts';
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Account thisAccount = AccountManager.getAccount();
        // Verify results
        System.assert(thisAccount!= null);
        System.assertEquals('test Account', thisAccount.Name);
    }
}