public class VFPagePane_CLS {

private Final Contact oContact;

//public Flow.Interview.GoldStandDiagnosev2 tierOneInterview {get;set;}

    public VFPagePane_CLS(ApexPages.StandardController stdController) {
        this.oContact = (Contact)stdController.getRecord();
    }

}