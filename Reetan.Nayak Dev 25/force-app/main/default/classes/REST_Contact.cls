@RestResource(urlMapping = '/showContactDetails/*')
global Class REST_Contact {

    @HttpGet
    global static List<Contact> getContacts(){
        List<Contact> lstCont;
        try{
            lstCont = [select Id, Name, Phone, AccountId from Contact order by LastName];
            return lstCont;
        }
        Catch(Exception ex){
            system.debug('Check Error... '+ ex.getMessage());
        }
        return lstCont;
    }
    
    @HttpPost
    global static String doCreateContact(String cName, String cPhone, String cEmail){
        /* List<Contact> cL;// = new List<Contact>();
        For(Contact cc:cL){
        cc.LastName = cName;
        cc.Phone = cPhone;
        cc.Email = cEMail;
        cL.add(cc);
        }
        insert cL;
        return cL; */
        
        Contact cc = new Contact();
        cc.LastName = cName;
        cc.Phone = cPhone;
        cc.Email = cEMail;
        
        insert cc;
        return cc.Id;
        
        
    }
    
}