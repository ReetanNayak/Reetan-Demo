/*
Apex Integration Services = 2. Apex REST Callouts

Apex Class: AnimalLocator
Mock Class: AnimalLocatorMock
Test Class: AnimalLocatorTest 
*/


public class AnimalLocator {
    public static String getAnimalNameByIdIn(Integer Id){
        
        HTTP ht = new HTTP();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/'+Id);
        req.setMethod('GET');
        
        HttpResponse resp = ht.send(req);
        system.debug('******response Code... '+resp.getStatusCode());
        system.debug('******response Body... '+resp.getBody()); 
        String animalName;

        if(resp.getStatusCode() == 200){
            // Deserializes the JSON string into collections of primitive data types.
            Map<String, Object> mapRes = (Map<String, Object>) JSON.deserializeUntyped(resp.getBody());
            //List<Object> objList = (List<Object>) mapRes.get('animal');
            Map<String, Object> mapAnimals = (Map<String, Object>) mapRes.get('animal');
            System.debug('Check the Animals.... '+ mapAnimals);
            
            //animalName=(String)mapAnimals.get('name');
            animalName = string.valueOf(mapAnimals.get('name'));
            System.debug('Check animalName value... '+animalName);
        }
        return animalName;
    }
}