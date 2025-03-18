public class OverrideCaseNewActionController {
    
    Public Case cas{get;set;}
    Public String objecttype{get;set;}
    Public Boolean doRedirect{get;set;}
    
    Public string recordId;
    Public string recAccId;
    Public string recContId;
    Public string caseRecTypeId;
    
    Public OverrideCaseNewActionController(Apexpages.StandardController sc) {
        cas = new Case();
        doRedirect = false;
        recordId = Apexpages.currentPage().getparameters().get('id');
        recAccId = Apexpages.currentPage().getparameters().get('def_account_id');
        recContId = Apexpages.currentPage().getparameters().get('def_contact_id');
        
        caseRecTypeId = Apexpages.currentPage().getparameters().get('RecordType');
        
        System.debug('recordId... '+ recordId);
        System.debug('recAccId... '+ recAccId);
        System.debug('recContId... '+ recContId);

        if(recContId != NULL && recContId.startsWith('003')) {
            cas.ContactId = recContId;
            cas.AccountId = recAccId;
            cas.status = 'New';
            cas.origin = 'Phone';
            cas.Subject = 'Test Cont Demo';
            if(caseRecTypeId != NULL){
                cas.RecordTypeId = caseRecTypeId;
            }            
            doRedirect = true;
        }
        
        else if(recAccId != NULL && recAccId.startsWith('001')) {
            cas.accountid = recAccId;
            cas.status = 'New';
            cas.origin = 'Phone';
            cas.Subject = 'Test Acc Demo';
            if(caseRecTypeId != NULL){
                cas.RecordTypeId = caseRecTypeId;
            }             
            doRedirect = true;
        }
        
        else if(recordId==null || recordId=='') {
            system.debug('recordId 1..' + recordId);
            cas.status = 'New';
            cas.origin = 'Phone';
            cas.Subject = 'Test Demo';
            if(caseRecTypeId != NULL){
                cas.RecordTypeId = caseRecTypeId;
            }             

            doRedirect = true;
        }        
        system.debug('recordId 4..' + recordId);
        //createCase();
    }
    
    
    Public pagereference createCase(){
        
        system.debug('Hello');
        Insert cas;
        system.debug(cas.id);
        PageReference RetCasePage = new PageReference('/'+cas.id);
        RetCasePage.setRedirect(true);
        return RetCasePage;
    }
}