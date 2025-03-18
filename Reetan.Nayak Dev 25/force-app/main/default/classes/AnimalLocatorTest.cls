/*
Apex Integration Services = 2. Apex REST Callouts

Apex Class: AnimalLocator
Mock Class: AnimalLocatorMock
Test Class: AnimalLocatorTest 
*/

@isTest
private class AnimalLocatorTest {
    @isTest static void testAnimalLocatorMock(){
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        String animalName = AnimalLocator.getAnimalNameByIdIn(1);
        System.assertEquals('Elephant', animalName);
        /*String animalName = AnimalLocator.getAnimalNameByIdIn(1);
        string expectedResult = 'chicken';
        System.assertEquals(animalName, expectedResult);*/
        System.assertNotEquals(null,animalName,'The callout returned a null response.');

    }
}