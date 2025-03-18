/*
Asynchronous Apex = 5. Schedule Jobs Using the Apex Scheduler

Apex Class: DailyLeadProcessor
Test Class: DailyLeadProcessorTest
*/

/*
@isTest
public  class DailyLeadProcessorTest {
    static testMethod void DailyLeadProcessorTest_Test() {
        List<Lead> lstLead = new List<Lead>();
            for(Integer i=0; i<200; i++){
                Lead Ld = new Lead();
                Ld.FirstName = 'Test1'+i;
                Ld.LastName = 'Test2'+i;
                Ld.Company = 'Dreamforce'+i;
                lstLead.add(Ld);
            }
            insert lstLead;
    }

    static testMethod void DailyLeadProcessorTest_Test2(){
            DailyLeadProcessor DLP = new DailyLeadProcessor();  
            string sch = '0 5 * * * ? ';
 
            Test.startTest();
            //string JobId = system.Schedule('Dream Job', sch, DLP);
            // String jobId = System.schedule('ScheduleApexText', sch, new DailyLeadProcessor());  
            string JobId = system.Schedule('Dream Job', sch, DLP);


           // List<Lead> Ldlst = [Select Id, Name from Lead where LeadSource=null limit 200];
           // system.assertEquals(200, Ldlst.size());
            Test.stopTest();
    }
}
*/

@isTest
private class DailyLeadProcessorTest{
    //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
    public static String CRON_EXP = '0 0 0 2 6 ? 2022';
    
    static testmethod void testScheduledJob(){
        List<Lead> leads = new List<Lead>();
        
        for(Integer i = 0; i < 200; i++){
            Lead lead = new Lead(LastName = 'Test ' + i, LeadSource = '', Company = 'Test Company ' + i, Status = 'Open - Not Contacted');
            leads.add(lead);
        }
        
        insert leads;
        
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('Update LeadSource to DreamForce', CRON_EXP, new DailyLeadProcessor());
        
        // Stopping the test will run the job synchronously
        Test.stopTest();
    }
}