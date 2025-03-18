/*
TrailHead = Apex Integration Services
			 (D) Apex Web Services

Apex Class: CaseManager
Test Class: CaseManagerTest
*/

@RestResource(urlMapping='/Cases/*')
global with sharing class CaseManager {
    
    // To READ the Case record.
    @HttpGet
    global static Case getCaseById() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case result =  [SELECT CaseNumber, Subject, Status, Origin, Priority FROM Case WHERE Id = :caseId];
        return result;
    }
    
    // To CREATE the Case record.
    @HttpPost
    global static ID createCase(String subject, String status, String origin, String priority) {
        Case thisCase = new Case(
            Subject=subject,
            Status=status,
            Origin=origin,
            Priority=priority);
        insert thisCase;
        return thisCase.Id;
    }
    
    // To DELETE the Case record.
    @HttpDelete
    global static void deleteCase() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        delete thisCase;
    }     
    
    // To UPSERT the Case record.
    @HttpPut
    global static ID upsertCase(String subject, String status, String origin, String priority, String id) {
        Case thisCase = new Case(Id=id,
                                Subject=subject,
                                Status=status,
                                Origin=origin,
                                Priority=priority);
        // Match case by Id, if present.
        // Otherwise, create new case.
        upsert thisCase;
        // Return the case ID.
        return thisCase.Id;
    }
    
    // To UPDATE the Case record.
    @HttpPatch
    global static ID updateCaseFields() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisCase.put(fieldName, params.get(fieldName));
        }
        update thisCase;
        return thisCase.Id;
    }    
    
}