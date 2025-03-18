public class Reet_BeerSearchAuraService {
	@AuraEnabled
    public static List<sObject> searchDoBeer(String strParam){
        String lkParam = '%' + strParam + '%';
        String strQuery = 'Select Id, Name from Beer__c where Name : lkParam limit 10';
        List<SObject> lstObj = Database.query(strQuery);
        return lstObj;
    }
}