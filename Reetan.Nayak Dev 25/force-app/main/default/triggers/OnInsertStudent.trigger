trigger OnInsertStudent on Student__c (before insert,before delete,after insert) {
    static String DEFAULT_PASSWORD = 'ceptes321';
    static String AUTH_TYPE = 'Student';
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            Integer i=[select count() from student__c];
            for(Student__c stud:Trigger.new){       
                String fname=stud.Name.substring(0,2);
                String lname=stud.Last_Name__c.substring(0,2);
                String uname;
                if(i>99){
                    Integer j=i/100;
                    uname=fname+lname+String.valueof(j);
                }
                else{
                    uname=fname+lname+String.valueof(i);
                }
                stud.loginId__c=uname;
            }
        }     
        
        if(Trigger.isDelete){
            List<String> studIds = new List<String>();
            for(Student__c stud:Trigger.old){
                studIds.add(stud.loginId__c); 
            }
            List<Authentication__c> auths=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById,
                LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, End_Date__c, Password__c, 
                Start_Date__c, Type__c, UpdatedBy__c, UserId__c, UserRevoked__c, UserSuspend__c, Valid_Till__c
                from  authentication__c where UserId__c in :studIds];
            if(auths != null && auths.size() > 0)                    
                delete auths;
        }
    }       
    
    if(Trigger.isAfter){ 
        if(Trigger.isInsert){
            List<Authentication__c> auths = new List<Authentication__c>();
            for (Student__c s : Trigger.new) {
                List<Batch__c> dt1=[select Start_Date__c,End_Date__c from Batch__c where id=:s.BatchId__c];
                Blob pw = Blob.valueOf(DEFAULT_PASSWORD);
                String encryptedPw = EncodingUtil.base64Encode(pw);
                auths.add(new Authentication__c(userID__c=s.loginId__c,Start_Date__c=dt1[0].Start_Date__c,
                End_Date__c=dt1[0].End_Date__c,Type__c=AUTH_TYPE,password__c=encryptedPw,Change_Password__c=true));
            }  
            insert auths;
        }
    }  
}