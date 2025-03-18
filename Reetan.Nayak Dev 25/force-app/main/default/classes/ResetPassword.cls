public with sharing class ResetPassword{

    public String userid{get;set;}
    
    public ResetPassword(){
        system.debug('----------------->'+System.currentPagereference().getParameters());
        userid = ApexPages.currentPage().getParameters().get('uid');   
    }
 
    public PageReference login() {
         PageReference ref=null; 
         String userid1 = ApexPages.currentPage().getParameters().get('pg:fm:pb:uid');        
         String password = ApexPages.currentPage().getParameters().get('pg:fm:pb:pwd');  
         String password1 = ApexPages.currentPage().getParameters().get('pg:fm:pb:pwd1');  
         Authentication__c auth ;
         try{
               auth= [Select UserId__c,Password__c,Type__c from Authentication__c where  UserId__c=:userid LIMIT 1];
               Blob data = Blob.valueOf(password);
               String encryptedData = EncodingUtil.base64Encode(data);
               if(password !=  null && password==password1){
                    auth.Password__c=encryptedData;
                    auth.Change_Password__c=false;
                    update auth;
                    if(auth.UserId__c==userid &&  auth.Password__c==encryptedData){
                        if(auth.Type__c=='Faculty'){
                            ref = new PageReference('/apex/FacultyHomePage');    
                            ref.getParameters().put('Id',auth.UserId__c);
                            ref.setRedirect(true);
                        }else if(auth.Type__c=='Student'){
                            ref = new PageReference('/apex/StudentHome');
                            ref.getParameters().put('Id',auth.UserId__c);
                            ref.setRedirect(true);
                        }else if(auth.Type__c=='Coordinator'){
                            ref = new PageReference('/apex/CoordinatorHomePage');
                            ref.getParameters().put('Id',auth.UserId__c);
                            ref.setRedirect(true);
                        }  
                    }
              }else{
                  return null;
              }
        }catch(Exception e){
            System.debug(e);
        }
        return ref;     
    }
    

//    TEST CASE  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>    

     static testMethod void resetPassWordWith(){
        ApexPages.currentPage().getParameters().put('uid','bajo0');
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd','abcd');  
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd1','pqrs');
        
        ResetPassword rspwd=new ResetPassword();
        rspwd.login();
    }      
    
    static testMethod void resetPassWordStudent(){
        String userid='bajo5';
        String pwd='barun123';
        Authentication__c auth=new Authentication__c();
        auth.UserId__c=userid;
        auth.Password__c=pwd;
        auth.Change_Password__c=true;  
        auth.Type__c='Student';
        insert auth;
        
        Authentication__c authin=[select Id,name,UserId__c,Password__c,UserRevoked__c,UserSuspend__c,Type__c from Authentication__c 
                             where UserId__c=:userid LIMIT 1];
        
        
        ApexPages.currentPage().getParameters().put('uid',authin.UserId__c);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',authin.Password__c);  
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd1',authin.Password__c);
        
        ResetPassword rspwd=new ResetPassword();
        rspwd.login();
    } 
        
    static testMethod void resetPassWordFaculty(){
        String userid='bajo6'; 
        Authentication__c auth=new Authentication__c();
        auth.UserId__c=userid;
        auth.Password__c='barun123';
        auth.Change_Password__c=true;  
        auth.Type__c='faculty';
        insert auth;
       
        Authentication__c authin=[select Id,name,UserId__c,Password__c,UserRevoked__c,UserSuspend__c,Type__c from Authentication__c 
                                 where UserId__c=:userid LIMIT 1];
        ApexPages.currentPage().getParameters().put('uid',authin.UserId__c);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',authin.Password__c);  
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd1',authin.Password__c);
           
        ResetPassword rspwd=new ResetPassword();
        rspwd.login();
    } 
}