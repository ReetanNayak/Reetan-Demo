public class AccountWrapper {
 
    public Boolean checked{ get; set; }
    public Account acc { get; set;}
 
    public AccountWrapper(){
        acc = new Account();
        checked = false;
    }
 
    public AccountWrapper(Account a){
        acc = a;
        checked = false;
    }
 
    public static testMethod void testMe() {
 
        AccountWrapper aw = new AccountWrapper ();
        System.assertEquals(aw.checked,false);
 
        AccountWrapper aw2 = new AccountWrapper (new Account(name='Test1'));
        System.assertEquals(aw2.acc.name,'Test1');
        System.assertEquals(aw2.checked,false);
 
    }
}