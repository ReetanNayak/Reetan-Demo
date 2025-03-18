trigger OnInsertCoordinator on Coordinator__c (before insert,before delete,after insert) {
    static String AUTH_TYPE = 'Coordinator';
    static String DEFAULT_PASSWORD = 'ceptes321';
    if(Trigger.isBefore) {
        if(Trigger.isInsert){
            Integer i=[select count() from Coordinator__c];          
            for(Coordinator__c cord:Trigger.new){        
                String fname=cord.Name.substring(0,2);
                String lname=cord.Last_Name__c.substring(0,2);
                String uname;
                if(i>99){
                    Integer j=i/100;
                    uname=fname+lname+String.valueof(j);
                }else{
                    uname=fname+lname+String.valueof(i);
                }  
                cord.Login_ID__c=uname;
            }
        }

        if(Trigger.isDelete){
            List<String> cordIds = new List<String>();
            for(Coordinator__c cord:Trigger.old){
                cordIds.add(cord.Login_ID__c); 
            }
            List<Authentication__c> auths=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById,
                LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, End_Date__c, Password__c, 
                Start_Date__c, Type__c, UpdatedBy__c, UserId__c, UserRevoked__c, UserSuspend__c, Valid_Till__c
                from  authentication__c where UserId__c in :cordIds];
            if(auths != null && auths.size() > 0)
                delete auths;
        }
    }       
         
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<Authentication__c> auths = new List<Authentication__c>();
            for (Coordinator__c cord: Trigger.new) {
                Blob pw = Blob.valueOf(DEFAULT_PASSWORD);
                String encryptedPw = EncodingUtil.base64Encode(pw);             
                auths.add(new Authentication__c(UserID__c=cord.Login_ID__c,Type__c=AUTH_TYPE,
                password__c=encryptedPw,Change_Password__c=true));
            }   
            insert auths; 
        }
    }   
}