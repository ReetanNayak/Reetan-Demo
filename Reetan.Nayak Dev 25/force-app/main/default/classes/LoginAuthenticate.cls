public   class  LoginAuthenticate {

  public Boolean forgot{get;set;}
  public Boolean isError{get;set;}
  public Boolean checkmail{get;set;}
  public String userid {get;set;}
  public String errorMessage{get;set;}
  public String emailMessage{get;set;}
  public Boolean errMessage{get;set;}
      
    public PageReference login() {
        String userid = ApexPages.currentPage().getParameters().get('pg:fm:pb:uid');        
        String password = ApexPages.currentPage().getParameters().get('pg:fm:pb:pwd');
        PageReference ref = null;
        Authentication__c  auth;
         try{
             auth  = [Select UserId__c,Password__c,Type__c,Change_Password__c,UserSuspend__c,UserRevoked__c from Authentication__c where  UserId__c=:userid LIMIT 1];
             System.debug('USERID IS==========='+auth.UserId__c  +  'Password-----------'+auth.Password__c);
             if(auth == null){
                // isError = true;
                // errorMessage = 'User does not exist. Enter valid user.';
             }else{
                 if(auth.Password__c != null){
                     Blob pw = EncodingUtil.base64Decode(auth.Password__c);
                     String decryptedPw = pw.toString();
                     System.debug('Password-----------'+decryptedPw);
                     
                     if(decryptedPw != null && decryptedPw == password){
                         System.debug('Password-----------'+decryptedPw+'    Change password is............'+auth.Change_Password__c);
                         if(auth.Change_Password__c){
                             //redirect to reset password page
                             ref = new PageReference('/apex/SignUpPage');
                             ref.getParameters().put('uid',userid);  
                             ref.setRedirect(true);
                         }else{
                            if(auth.UserRevoked__c==true){
                               isError = true;
                               errorMessage = 'User Revoked.';
                            }else if(auth.UserSuspend__c==true){
                                isError = true;
                                errorMessage = 'User Suspended.';
                            }else if(auth.Type__c=='Faculty'){
                                 //   ref = new PageReference('/apex/FacultyDetail');
                                    ref = new PageReference('/apex/FacultyHomePage');
                                    ref.getParameters().put('Id',auth.UserId__c);
                                    ref.setRedirect(true);
                                    
                             } else if(auth.Type__c=='Student'){
                                    System.debug('Redirect to StuntPage..........>');
                                    ref = new PageReference('/apex/StudentHome');
                                    ref.getParameters().put('Id',auth.UserId__c);
                                    ref.setRedirect(true);
                             } else if(auth.Type__c=='Coordinator'){
                                    System.debug('Redirect to CoordinatorHomePage..........>');
                                    ref = new PageReference('/apex/CoordinatorHomePage');
                                    ref.getParameters().put('Id',auth.UserId__c);
                                    ref.setRedirect(true);
                             }
                         }
                      }else{
                          isError = true;
                          errorMessage = 'Invalid Password. Enter valid password.';
                          forgot = true;
                     }
                 }else{
                   isError = true;
                          errorMessage = 'You have Given Null Password.';
                          forgot = true;
                     }
                 
             }
         }catch(Exception e){
             System.debug(e);
              isError = true;
               errorMessage = 'User does not exist. Enter valid user.';
         }
        return ref; 
   }
    
   public void forgotPassword(){
        isError = false;
        String userid = ApexPages.currentPage().getParameters().get('pg:fm:pb:uid');   
        Authentication__c  auth;
        try{
            auth  = [Select UserId__c,Password__c,Type__c,Change_Password__c from Authentication__c where  UserId__c=:userid LIMIT 1];
            auth.Change_Password__c=true;
            update auth;
        }catch(Exception e){
            isError = true;
            errorMessage = 'Invalid User.';
        }
        if(auth != null){
            Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
            email.setSubject( 'Your request for password');
            email.setPlainTextBody( 'Hi! your temporary password is: ceptes321');
            if(auth.Type__c=='student'){
                Student__c st;
                try{
                   st=[select id, Name,SEmail_Id__c from Student__c where loginId__c=:userid LIMIT 1];
                   if(st != null)
                       email.setToAddresses( new String[]{st.SEmail_Id__c} );   
                }catch(Exception e){
                    isError = true;
                    errorMessage = 'Student Not Found.';
                }
            }
            if(auth.Type__c=='faculty'){
                Faculty__c fac;
                try{
                    fac=[select id,Name,Email_ID__c from Faculty__c where Login_ID__c=:userid LIMIT 1];
                    if(fac!=null)
                        email.setToAddresses( new String[]{fac.Email_ID__c} );
                }catch(Exception e){
                    isError = true;
                    errorMessage = 'Faculty Not Found.';
                }
            }
             if(auth.Type__c=='Coordinator'){
                Coordinator__c cord;
                try{
                    cord=[select id,Name,Email_ID__c from Coordinator__c where Login_ID__c=:userid LIMIT 1];
                    if(cord!=null)
                        email.setToAddresses( new String[]{cord.Email_ID__c} );
                }catch(Exception e){
                    isError = true;
                    errorMessage = 'Coordinator Not Found.';
                }
            }
            // Now send message 
            try{
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            }catch(Exception e){
                isError = true;
                errorMessage = 'Error in sending the mail.';
            }
            if(!isError){
                errMessage=true;
                emailMessage = 'A mail has been sent to your mail id with new password';
                Blob pw = Blob.valueOf('ceptes321');
                String encriptPw = EncodingUtil.base64Encode(pw);
                auth.Password__c = encriptPw;
                try{
                    update auth;
                }catch(Exception e){
                    System.debug('Error : '+e);
                }
            }
        }

   }
   
   // Test Methods    
    static testMethod void loginAuthWithStudent1(){
        String userid='baje6';
        String pw ='barun123';
        Blob data = Blob.valueOf(pw);
        String encryptedPw = EncodingUtil.base64Encode(data);
        Authentication__c authins=new Authentication__c();
        authins.UserId__c=userid;
        authins.Password__c=encryptedPw;
        authins.Change_Password__c=false;  
        authins.UserSuspend__c=false;
        authins.UserRevoked__c=false;
        authins.Type__c='Student';
        insert authins;
        
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw);        
        LoginAuthenticate log=new LoginAuthenticate();
        log.login();
        log.forgotPassword();  
     
        
        userid='fxcgf';
        pw='cvbgcv';
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw);        

        log=new LoginAuthenticate();
        log.login();
        log.forgotPassword(); 
        
        userid='baje6';
        pw='cvbgcv';
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw); 
        
        log=new LoginAuthenticate();
        log.login();
        log.forgotPassword(); 
   } 
   
    static testMethod void loginAuthWithFaculty(){
   
        String userid='bajej9';
        String pw='barun9';
        Blob data = Blob.valueOf(pw);
        String encryptedPw = EncodingUtil.base64Encode(data);
        Authentication__c authins=new Authentication__c();
        authins.UserId__c=userid;
        authins.Password__c=encryptedPw;
        authins.Change_Password__c=false;  
        authins.UserSuspend__c=false;
        authins.UserRevoked__c=false;
        authins.Type__c='faculty';
        insert authins;
        
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw);       

        LoginAuthenticate log=new LoginAuthenticate();
        log.login();
        log.forgotPassword();
   } 
 
 
   static testMethod void loginAuthWithCoordinator(){
        
        String userid='bajej10';
        String pw='barun9';
        Blob data = Blob.valueOf(pw);
        String encryptedPw = EncodingUtil.base64Encode(data);
        Authentication__c authins=new Authentication__c();
        authins.UserId__c=userid;
        authins.Password__c=encryptedPw;
        authins.Change_Password__c=false;  
        authins.UserSuspend__c=false;
        authins.UserRevoked__c=false;
        authins.Type__c='Coordinator';
        insert authins;
        
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw);        
    

        LoginAuthenticate log=new LoginAuthenticate();
        log.login();
        log.forgotPassword();
   } 
   
   static testMethod void loginAuthWithExistCoordinator(){
        String userid='bajej11';
        String pw='barun9';
        Blob data = Blob.valueOf(pw);
        String encryptedPw = EncodingUtil.base64Encode(data);
        Authentication__c authins=new Authentication__c();
        authins.UserId__c=userid;
        authins.Password__c=encryptedPw;
        authins.Change_Password__c=true;  
        authins.UserSuspend__c=false;
        authins.UserRevoked__c=false;
        authins.Type__c='Coordinator';
        insert authins;
        
        ApexPages.currentPage().getParameters().put('pg:fm:pb:uid',userid);
        ApexPages.currentPage().getParameters().put('pg:fm:pb:pwd',pw); 
        LoginAuthenticate log=new LoginAuthenticate();
        log.login();
        log.forgotPassword();
   }
}