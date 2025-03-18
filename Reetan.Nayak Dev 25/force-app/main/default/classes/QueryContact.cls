public class QueryContact {
  public static Id getContactID(String lastName, String title) {
    try {
      Contact myContact = Database.query(
        'SELECT ID FROM Contact WHERE lastName = :lastName AND title = :title LIMIT 1'
      );
      return myContact.Id;
    } catch (Exception ex) {
      return null;
    }
  }
  public static Id getContactIDWithBinds(Map<String, Object> bindVars) {
    //do not modify any code above this line
    //implement the logic that will use bindVars to retrieve the contact's ID
    
    String queryString = 'Select Id, Name from Contact where LastName =: lastName AND Title =:title limit 1';
      List<Contact> lstCont = Database.queryWithBinds(queryString, bindVars, AccessLevel.USER_MODE);
      
      if(!lstCont.isEmpty()){
          return lstCont[0].Id;
      }
      else{
        return null;  
      }
      
      //return Database.queryWithBinds(queryString, bindVars, AccessLevel.USER_MODE);
        
    //return null;
    }
}