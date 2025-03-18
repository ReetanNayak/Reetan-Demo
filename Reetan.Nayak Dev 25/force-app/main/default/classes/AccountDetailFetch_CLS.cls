public class AccountDetailFetch_CLS {

    public string SelectAccount {get; set;}
    
    public List<SelectOption> getAccountName() {
        List<SelectOption> opt = new List<SelectOption>();
        List<Account> lstAcc = [select Id, Name from Account order by Name];
        for(Account acc:lstAcc) {
            opt.add(new SelectOption(acc.Id, acc.Name));
        }
        return opt;
    }
    
    public List<SelectOption> getContactValue() {
        List<SelectOption> opt2 = new List<SelectOption>();
        List<Contact> lstCont = [select Id, Name from Contact where AccountId=:SelectAccount];
        for(Contact con:lstCont) {
            opt2.add(new SelectOption(con.Id, con.Name));
        }
        return opt2;
    }
}