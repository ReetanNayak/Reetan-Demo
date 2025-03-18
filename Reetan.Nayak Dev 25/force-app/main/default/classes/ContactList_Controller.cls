public class ContactList_Controller {

    @AuraEnabled
    public static List<Contact> getContactList(String accId){
        List<Contact> contList = new List<Contact>([Select Id, Name, FirstName, LastName, Email, Phone from Contact where AccountId =: accId]);
        return contList;
    }
    
    @AuraEnabled
    public static Contact CreateContact(Contact con, Id accId){
        con.AccountId = accId;
        insert con;
        return con;
    }
}