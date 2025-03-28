/*
Create an Apex class that returns contacts based on incoming parameters.

For this challenge, you will need to create a class that has a method accepting two strings. The method searches for contacts that have a last name matching the first string and a mailing postal code matching the second. It gets the ID and Name of those contacts and returns them.

The Apex class must be called ContactSearch and be in the public scope
The Apex class must have a public static method called searchForContacts
The method must accept two incoming strings as parameters
It should then find any contact that has a last name matching the first string, and mailing postal code (API name: MailingPostalCode) matching the second string
The method should return a list of Contact records of type List that includes the ID and Name fields
*/


public class ContactSearch  {
    public static List<Contact> searchForContacts(string LName, String PCode){
        
        List<Contact> lstCont = [Select Id, Name, LastName, MailingPostalCode from Contact where LastName=:LName AND MailingPostalCode=: PCode];
        System.debug('Reetan Test 3... '+ lstCont ); 
        return lstCont;
    }

}


// ContactSearch.searchForContacts('LName', 'PCode' );