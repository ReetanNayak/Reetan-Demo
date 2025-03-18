public class FacultyHomeController {

    //  Sign Out Page
    public PageReference doSignOut() {
        PageReference pgref1=new PageReference('/apex/LoginPage');
        pgref1.setRedirect(true);
        return pgref1;
    }
    static testMethod void FacHomeCon(){
    FacultyHomeController fac=new FacultyHomeController();
        fac.doSignOut();
    }
}