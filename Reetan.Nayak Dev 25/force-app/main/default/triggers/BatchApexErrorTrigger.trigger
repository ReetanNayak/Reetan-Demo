/* trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    List<BatchLeadConvertErrors__c> lstBLC= new List<BatchLeadConvertErrors__c>();
    
    for(BatchApexErrorEvent BAE : Trigger.New){
        BatchLeadConvertErrors__c BLC = new BatchLeadConvertErrors__c();
        BLC.AsyncApexJobId__c = BAE.AsyncApexJobId;
        BLC.Records__c = BAE.JobScope;
        BLC.StackTrace__c = BAE.StackTrace;
        lstBLC.add(BLC);
    }
    
    if(lstBLC > 0){
        insert lstBLC;
    }
}
*/

trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    
    BatchLeadConvertErrors__c[] batchLeadConvertErrors = new BatchLeadConvertErrors__c[]{};
    
        for(BatchApexErrorEvent a: Trigger.new){
            BatchLeadConvertErrors__c b=new BatchLeadConvertErrors__c();
            b.AsyncApexJobId__c=a.AsyncApexJobId;
            b.Records__c=a.JobScope;
            b.StackTrace__c=a.StackTrace;
            batchLeadConvertErrors.add(b);
        }
    	
    if(batchLeadConvertErrors.size()>0){
        insert batchLeadConvertErrors;
    }
}