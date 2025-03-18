/*
WebService Class= ParkService, AsyncParkService
Apex Class= ParkLocator, ParkServiceMock, ParkLocatorTest
*/

@isTest
Private class ParkLocatorTest {
    
    @isTest static void testParkLocator(){
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new ParkServiceMock());        
        String cout = 'United States';
        String[] result = ParkLocator.country(cout);
        System.assertEquals(new List<String>{'Germany', 'India', 'Japan', 'United States'}, result);
        //System.assertEquals(new List<String>{'Garner State Park', 'Fowler Park', 'Hoosier National Forest Park'}, result);
    }

}