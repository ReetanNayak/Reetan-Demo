/*
TrailHead = Apex Integration Services
			 (D) Apex Web Services

Apex Class: AccountManager
Test Class: AccountManagerTest
*/


//@RestResource(urlMapping='/Accounts/*/Contacts')
/* global class AccountManager {

    // To READ the Account record.
    @HttpGet
    global static Account getAccount(){
        RestRequest req = Restcontext.request;
        // grab the caseId from the end of the URL
        //String accId = req.requestURI.subString(req.requestURI.lastIndexOf('/')+1);
        // Account accResult = [Select Id, Name from Account where ID =: accId];
        String accId = req.requestURI.substringBetween('Accounts/','/Contacts');
		Account accResult = [Select Id, Name, (Select Id, Name from Contacts) from Account where ID =: accId];        
		System.debug('accResult... ' + accResult);
        return accResult;
    }
}	*/

@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager{
    @HttpGet
    global static Account getAccount(){
        RestRequest request = RestContext.request;
        String accId = request.requestURI.substringBetween('Accounts/','/contacts');
        system.debug('accId... '+ accId);
        Account objAccount = [SELECT Id,Name,(SELECT Id,Name FROM Contacts) FROM Account WHERE Id =:accId LIMIT 1];
        System.debug('accResult... ' + objAccount);
        return objAccount;
    }
}