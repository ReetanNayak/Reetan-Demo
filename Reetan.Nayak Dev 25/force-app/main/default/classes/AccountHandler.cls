/*
To pass this challenge, create an Apex class that inserts a new account named after an incoming parameter. If the account is successfully inserted, the method should return the account record. If a DML exception occurs, the method should return null.

The Apex class must be called AccountHandler and be in the public scope
The Apex class must have a public static method called insertNewAccount
The method must accept an incoming string as a parameter, which will be used to create the Account name
Insert the account into the system and then return the record
The method must also accept an empty string, catch the failed DML and then return null
*/

public class AccountHandler {
    public static Account insertNewAccount(String sName) {
        
        Account acc = new Account();
        acc.name = sName;
        try{    
            insert acc;
            System.debug('Reetan Test ABC PQR... '+ acc );  
            return acc;
        }
        catch(Exception e){
            System.debug('Reetan Test  XYZ... ' ); 
            return null;
        }
    
    }
}


// AccountHandler.insertNewAccount('Reetkshi Nayak');
// AccountHandler.insertNewAccount(null);