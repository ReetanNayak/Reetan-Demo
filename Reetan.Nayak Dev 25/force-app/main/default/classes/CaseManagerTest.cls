/*
Apex Class: CaseManager
Test Class: CaseManagerTest
*/

@IsTest
private class CaseManagerTest {
    
    // @HttpGet: To READ the Case record.
    @isTest static void testGetCaseById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        // request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Cases/'+ recordId;
        request.requestUri = 'https://reetan-dev-ed.salesforce.com/services/apexrest/Cases/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Case thisCase = CaseManager.getCaseById();
        // Verify results
        System.assert(thisCase != null);
        System.assertEquals('Test record', thisCase.Subject);
    }
    
    // @HttpPost: To CREATE the Case record.
    @isTest static void testCreateCase() {
        // Call the method to test
        ID thisCaseId = CaseManager.createCase('Ferocious chipmunk', 'New', 'Phone', 'Low');
        // Verify results
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Subject FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Subject, 'Ferocious chipmunk');
    }
    
    // @HttpDelete: To DELETE the Case record.
    @isTest static void testDeleteCase() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        // request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Cases/'+ recordId;
        request.requestUri = 'https://reetan-dev-ed.salesforce.com/services/apexrest/Cases/'+ recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        CaseManager.deleteCase();
        // Verify record is deleted
        List<Case> cases = [SELECT Id FROM Case WHERE Id=:recordId];
        System.assert(cases.size() == 0);
    }
    
    // @HttpPut: To UPSERT the Case record.
    @isTest static void testUpsertCase() {
        // 1. Insert new record
        ID case1Id = CaseManager.upsertCase('Ferocious chipmunk', 'New', 'Phone', 'Low', null);
        // Verify new record was created
        System.assert(Case1Id != null);
        Case case1 = [SELECT Id,Subject FROM Case WHERE Id=:case1Id];
        System.assert(case1 != null);
        System.assertEquals(case1.Subject, 'Ferocious chipmunk');
        
        // 2. Update status of existing record to Working
        ID case2Id = CaseManager.upsertCase('Ferocious chipmunk', 'Working', 'Phone', 'Low', case1Id);
        // Verify record was updated
        System.assertEquals(case1Id, case2Id);
        Case case2 = [SELECT Id,Status FROM Case WHERE Id=:case2Id];
        System.assert(case2 != null);
        System.assertEquals(case2.Status, 'Working');
    }  
    
    // @HttpPatch: To UPDATE the Case record.
    @isTest static void testUpdateCaseFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        // request.requestUri = 'https://yourInstance.salesforce.com/services/apexrest/Cases/'+ recordId;
		request.requestUri = 'https://reetan-dev-ed.salesforce.com/services/apexrest/Cases/'+ recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Working"}');
        RestContext.request = request;
        
        // Update status of existing record to Working
        ID thisCaseId = CaseManager.updateCaseFields();
        // Verify record was updated
        System.assert(thisCaseId != null);
        Case thisCase = [SELECT Id,Status FROM Case WHERE Id=:thisCaseId];
        System.assert(thisCase != null);
        System.assertEquals(thisCase.Status, 'Working');
    }  
    
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Case caseTest = new Case( Subject='Test record',
                                Status='New',
                                Origin='Phone',
                                Priority='Medium');
        insert caseTest;
        return caseTest.Id;
    }          
}