/*
Asynchronous Apex = 5. Schedule Jobs Using the Apex Scheduler

Apex Class: DailyLeadProcessor
Test Class: DailyLeadProcessorTest
*/

/*
global class DailyLeadProcessor implements Schedulable{
    global void Execute(SchedulableContext SC){
        List<Lead> lstofLead = [Select Id from Lead where LeadSource = null limit 200];
        List<Lead> LeadLst = new List<Lead>();

        if(!lstofLead.isEmpty()){
            for(Lead Ld:lstofLead) {
                Ld.LeadSource = 'Dreamforce';
                LeadLst.add(Ld);
            }
            update LeadLst;
        }
    }
} */

global class DailyLeadProcessor implements Schedulable{
    global void execute(SchedulableContext ctx){
        List<Lead> leads = [SELECT Id, LeadSource FROM Lead WHERE LeadSource = ''];
        
        if(leads.size() > 0){
            List<Lead> newLeads = new List<Lead>();
            
            for(Lead lead : leads){
                lead.LeadSource = 'DreamForce';
                newLeads.add(lead);
            }
            
            update newLeads;
        }
    }
}