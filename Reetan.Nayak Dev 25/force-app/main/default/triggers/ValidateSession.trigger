trigger ValidateSession on Session__c (after update) {
/*
if(Trigger.isAfter){
  if(Trigger.isUpdate){
        for(Session__c ses:Trigger.new){
        String batchId = ses.Batch__c;
       // System.debug('Batch Id '+batchId);
        
        List<Session__c> lses = [SELECT Id, Name, CourseId__c, Task_Completed__c, Task__c, Session_Type__c, Session_Status__c, 
                                 FacultyID__c, Comment__c, Topic_Covered__c, Topic_InProgress__c, Topic_Not_Yet_Started__c, 
                                 Batch__c from Session__c where Batch__c=:ses.Batch__c];

        Batch__c bat = [SELECT Id, Name, CourseId__c, BatchId__c, Status__c, Faculty_Id__c, Start_Date__c, End_Date__c, 
                        Batch_Status__c from Batch__c where Id=:ses.Batch__c ];

        Integer i=0; 
        Integer j=0;   
        
        for(Session__c ss:lses) {
            if(ss.Session_Status__c=='Topic Completed' ) {
                i=i+1;
              }
        
            if(ss.Session_Status__c=='Topic Not yet Started') {
                j=j++;
              }
        
            if(ss.Session_Status__c=='Topic In Progress') {
                bat.Batch_Status__c='Batch In Progress';
              }
           }
       
            if(i==lses.size() && j!=lses.size()) {
                bat.Batch_Status__c='Batch Completed';
              }
              else {
                if(j==lses.size()) {
                    bat.Batch_Status__c='Batch Not yet Started';
                    }
                
                else {
                    bat.Batch_Status__c='Batch In Progress';
                    }
               }    
        
        
           
        for(Session__c ss:lses) {
            if(ss.Session_Status__c=='Completed' ) {
                i=i+1;
              }
        
            if(ss.Session_Status__c=='Not yet Started') {
                j=j++;
              }
        
            if(ss.Session_Status__c=='In Progress') {
                bat.Batch_Status__c='In Progress';
              }
           }
       
            if(i==lses.size() && j!=lses.size()) {
                bat.Batch_Status__c='Completed';
              }
              else {
                if(j==lses.size()) {
                    bat.Batch_Status__c='Not yet Started';
                    }
                
                else {
                    bat.Batch_Status__c='In Progress';
                    }
               }    
            
         update bat;
       }   
     //   System.debug('lses '+lses.size());
       
     }
   }
 */
}