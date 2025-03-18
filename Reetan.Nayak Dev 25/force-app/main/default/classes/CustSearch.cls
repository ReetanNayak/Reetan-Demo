public class CustSearch {

    public contact con{set;get;}
    public list<contact> cont {set;get;}
    
    public CustSearch(Apexpages.StandardController controller){
        cont = new list<contact>();
    // list<string> str = new list<string>{'FirstName','LastName','Email','AccountId','Account.name', 'Languages__c'};  
    
    list<string> str = new list<string>{'FirstName','LastName','Email','Languages__c'};  

        controller.addFields(str);
        con = (contact)controller.getRecord();  
    }
    
    public void search(){
     transient String lastname= '%'+con.LastName+'%';
     transient string firstname = '%'+con.FirstName+'%';
     transient string email1 = '%'+con.Email+'%';
   transient id accName = con.Accountid;
   transient String acctno = '%'+con.Languages__c+'%';
   
   transient String mStreet = '%'+con.MailingStreet+'%';
  
        System.debug(accName);
        System.debug(con.AccountId);
        cont = [select id,firstname,lastname,email,phone,contact.account.name, Languages__c, Level__c, MailingStreet, MailingCity, MailingPostalCode, MailingState  from contact where firstname like : firstname OR lastname like : lastname OR email like : email1 OR Languages__c like :acctno OR MailingStreet like : mStreet  ];    
            
        if(cont.size()==0)
       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ' No Matching Contact Records Found '));
       System.debug(cont.size());        
    }
    
}