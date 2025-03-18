/*
Asynchronous Apex = 3. Use Batch Apex

Apex Class: LeadProcessor
Test Class: LeadProcessorTest
*/

global class LeadProcessor implements Database.Batchable<sObject>{

    global Database.QueryLocator Start (Database.BatchableContext BC){
        String strQuery = 'Select Id, Name, LeadSource from Lead';
        return Database.getQueryLocator(strQuery);
    }

    global void Execute(Database.BatchableContext BC, List<Lead> lstLead){
        for(Lead ld : lstLead){
            ld.LeadSource = 'Dreamforce';
        }
        update lstLead;
    }

    global void Finish(Database.BatchableContext BC){
        
    }

}