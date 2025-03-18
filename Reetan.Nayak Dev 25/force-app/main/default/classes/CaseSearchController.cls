public inherited sharing class CaseSearchController {
 
    @AuraEnabled(Cacheable = true)
    public static list<Case> retriveCases(String strCaseName) {
        strCaseName = '%' + strCaseName + '%';
        list<Case> lstCases = [Select Id, Casenumber, Subject, Origin, Type, Reason from Case WHERE Subject LIKE :strCaseName];

        if(lstCases.isEmpty()) {
            throw new AuraHandledException('No Record Found..');
        }
        return lstCases; 
    }
}