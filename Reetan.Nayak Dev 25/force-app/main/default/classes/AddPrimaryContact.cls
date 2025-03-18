/*
Asynchronous Apex = 4. Control Processes with Queueable Apex

Apex Class: AddPrimaryContact
Test Class: AddPrimaryContactTest
*/

public class AddPrimaryContact implements Queueable {

    public Contact con;
    public String bilState;

    public AddPrimaryContact(Contact con, String bilState) {
        this.con = con;
        this.bilState = bilState;
    }

    public void Execute (QueueableContext QC){
        List<Account> lstAcc = [Select Id, Name, BillingState, (Select Id, Name from Contacts) from Account where BillingState =: bilState limit 200];
        List<contact> lstCont = new List<Contact>();

        for(Account acc:lstAcc){
            Contact cont = con.clone(false, false, false, false);
            cont.accountId = acc.Id;
            lstCont.add(cont); 
        }

        if(lstCont.size()>0){
            insert lstCont;
        }
    }
}