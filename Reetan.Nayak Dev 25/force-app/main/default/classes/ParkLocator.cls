/*
WebService Class= ParkService, AsyncParkService
Apex Class= ParkLocator, ParkServiceMock, ParkLocatorTest
*/

public class ParkLocator {
    
    public static String[] country(String country){
        ParkService.ParksImplPort parkServ = new ParkService.ParksImplPort();
        return parkServ.byCountry(country);
    }

}