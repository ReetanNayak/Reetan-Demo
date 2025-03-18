public class Account_Contact_Edit_CLS {
 
    private ApexPages.StandardController std;
     
    // the associated contacts
   public List<Contact> contacts;
      
    // the chosen contact id - used when deleting a contact
    public Id chosenContactId {get; set;}
     
    public String newContactFirstName {get; set;}
    public String newContactLastName {get; set;}
     
    public Account_Contact_Edit_CLS()
    {
    }
     
    public Account_Contact_Edit_CLS(ApexPages.StandardController stdCtrl)
    {
     std=stdCtrl;
    }
     
    public Account getAccount()
    {
     return (Account) std.getRecord();
    }
 
 public SObject getSobject()
 {
  return std.getRecord();
 }
      
    private boolean updateContacts()
    {
        boolean result=true;
        if (null!=contacts)
           {
              // TODO: should work out what's changed and then save, easier to update everything for prototype
           List<Contact> updConts=new List<Contact>();
              try
              {
               update contacts;
              }
              catch (Exception e)
              {
                 String msg=e.getMessage();
                 integer pos;
                  
                 // if its field validation, this will be added to the messages by default
                 if (-1==(pos=msg.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION, ')))
                 {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, msg));
                 }
                  
                 result=false;
              }
           }
            
           return result;
    }
     
    public PageReference saveAndExit()
    {
     boolean result=true;
    result=updateContacts();
      
     if (result)
     {
        // call standard controller save
        return std.save();
     }
     else
     {
      return null;
     }
    }
     
    public PageReference save()
    {
     Boolean result=true;
     PageReference pr = Page.Account_Contact_Edit;
     if (null!=getAccount().id)
     {
      result=updateContacts();
     }
     else
     {
      pr.setRedirect(true);
     }
      
     if (result)
     {
        // call standard controller save, but don't capture the return value which will redirect to view page
        std.save();
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Changes saved'));
     }
        pr.getParameters().put('id', getAccount().id);
      
     return pr;
    }
 
    public void newContact()
    {
       if (updateContacts())
       {
          Contact cont=new Contact(FirstName=newContactFirstName, LastName=newContactLastName, AccountId=getAccount().id);
          insert cont;
         
          newContactFirstName=null;
          newContactLastName=null;
          contacts=null;
       }
    }
     
    public void deleteContact()
    {
       if (updateContacts())
       {
          if (null!=chosenContactId)
          {
             Contact cont=new Contact(Id=chosenContactId);
              delete cont;
        
              contacts=null;
              chosenContactId=null;
          }
       }
    }
     
   public List<Contact> getContacts()
    {
       if ( (null!=getAccount().id) && (contacts == null) )
       {
           contacts=[SELECT Id, Name, Email, Phone, AccountId, Title, 
                        Salutation, OtherStreet, OtherState, OtherPostalCode,
                        OtherPhone, OtherCountry, OtherCity, MobilePhone, MailingStreet, MailingState,
                        MailingPostalCode, MailingCountry, MailingCity, LeadSource, LastName,
                        HomePhone, FirstName, Fax, Description, Department
                         FROM Contact
                         WHERE AccountId = : getAccount().ID
                         ORDER BY CreatedDate];
       }
                           
       return contacts;
    }
}