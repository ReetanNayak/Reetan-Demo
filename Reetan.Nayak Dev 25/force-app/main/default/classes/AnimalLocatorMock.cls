/*
Apex Integration Services = 2. Apex REST Callouts

Apex Class: AnimalLocator
Mock Class: AnimalLocatorMock
Test Class: AnimalLocatorTest 
*/

@isTest
global class AnimalLocatorMock implements HttpCalloutMock{
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        //response.setBody('{"animal": ["Tiger", "Lion", "Elephant", "Kangaroo", "Zebra"]}');
        //response.setBody('{"animals":[{"id":12345,"name":"Elephant"},{"id":12346,"name":"Kangaroo"},{"id":12347,"name":"Zebra"}]}');
        response.setBody('{"animal":{"id":1,"name":"Elephant","eats":"Kangaroo","says":"Zebra"}}');

        response.setStatusCode(200);
        return response; 
    }
}