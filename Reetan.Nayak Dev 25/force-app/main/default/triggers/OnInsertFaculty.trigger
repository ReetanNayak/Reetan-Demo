trigger OnInsertFaculty on Faculty__c (before insert,before delete,after insert) {
    static String AUTH_TYPE = 'Faculty';
    static String DEFAULT_PASSWORD = 'ceptes321';
    if(Trigger.isBefore) {
        if(Trigger.isInsert){          
            for(Faculty__c fac:Trigger.new){        
                String fname=fac.Name.substring(0,2);
                String lname=fac.Last_Name__c.substring(0,2);
                Integer i=[select count() from Faculty__c];
                String uname;
                if(i>99){
                    Integer j=i/100;
                    uname=fname+lname+String.valueof(j);
                }else{
                    uname=fname+lname+String.valueof(i);
                }  
                fac.Login_ID__c=uname;
            }
        }

        if(Trigger.isDelete){
            List<String> facIds = new List<String>();
            for(Faculty__c fac:Trigger.old){
                facIds.add(fac.Login_ID__c); 
            }
            List<Authentication__c> auths=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById,
                LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, End_Date__c, Password__c, 
                Start_Date__c, Type__c, UpdatedBy__c, UserId__c, UserRevoked__c, UserSuspend__c, Valid_Till__c
                from  authentication__c where UserId__c in :facIds];
            if(auths != null && auths.size() > 0)
                delete auths;
        }
    }       
         
    if(Trigger.isAfter){
        if(Trigger.isInsert){
            List<Authentication__c> auths = new List<Authentication__c>();
            for (Faculty__c fac : Trigger.new) {
                Blob pw = Blob.valueOf(DEFAULT_PASSWORD);
                String encryptedPw = EncodingUtil.base64Encode(pw);             
                auths.add(new Authentication__c(UserID__c=fac.Login_ID__c,Type__c=AUTH_TYPE,
                password__c=encryptedPw,Change_Password__c=true));
            }   
            insert auths; 
        }
    }   
}