/*
Create an Apex class that returns both contacts and leads based on a parameter.

To pass this challenge, create an Apex class that returns both contacts and leads that have first or last name matching the incoming parameter.

The Apex class must be called ContactAndLeadSearch and be in the public scope
The Apex class must have a public static method called searchContactsAndLeads
The method must accept an incoming string as a parameter
It should then find any contact or lead that matches the string as part of either the first or last name
The method should use a return type of List<List< SObject>>
NOTE: Because SOSL indexes data for searching, you must create a Contact record and Lead record before checking this challenge. Both records must have the last name Smith. The challenge uses these records for the SOSL search
*/

public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads (String FName){
        //FName = 'Reetkshi';
        List<List<SObject>> lstContLead = [FIND 'Smith' IN ALL FIELDS Returning Contact(Name), Lead(Name) ];
           System.debug('Reetan Test 4... '+ lstContLead ); 

        return lstContLead;
    }
}


// ContactAndLeadSearch.searchContactsAndLeads('Reetkshi');