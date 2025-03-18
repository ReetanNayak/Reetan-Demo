public class NewCaseListController {

    public List<Case> getNewCases(){
        List<Case> cc = [Select Id, CaseNumber from Case];
        return cc;
    }
}