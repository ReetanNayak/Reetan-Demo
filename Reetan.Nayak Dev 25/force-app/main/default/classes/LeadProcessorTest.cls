/*
Asynchronous Apex = 3. Use Batch Apex

Apex Class: LeadProcessor
Test Class: LeadProcessorTest
*/

@isTest
public class LeadProcessorTest {
    
    public static testMethod void LeadProcessorTest_Test(){
        List<Lead> lstLead = new List<Lead>();
        for(Integer i=0; i<200; i++){
            Lead ld = new Lead();
            ld.FirstName = 'Test Lead 1'+i;
            ld.LastName = 'Test Lead 2'+i;
            ld.Company = 'ABC'+i;
            lstLead.add(ld);
        }
        insert lstLead;

        Test.startTest();
            LeadProcessor LP = new LeadProcessor();
            Database.executeBatch(LP);
        Test.stopTest();
    }
}