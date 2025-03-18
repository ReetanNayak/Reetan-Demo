/**
* @author Original: Robby Angeles (502068421) Cloud Sherpas/GEHC Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
* @date Original: 14 Mar 2012, Last Modified 02 Oct 2012
* @description Class that facilitates marking of Account, Contact and Opportunity records as Favorite via Favorites custom object.
*/
global class MarkFavorites {
  
  /**
  * @author Original: Robby Angeles (502068421) Cloud Sherpas/GEHC Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
  * @date Original: 14 Mar 2012, Last Modified 20 Jun 2012
  * @description Method that dynamically queries the Favorites custom object to check if a record is already marked by the user as favorite and if not creates a new favorites record based of the record id, object type and logged in user id.
  * @param recId ID of record to be added as a Favorite.
    * @param objType sObject type of the record being added as a Favorite.
    * @return String Success or error message of the nethod.
  */

  webservice static String markRecordAsFavorite(String recId, String objType){
    String retVal = '';
    
    System_Event_Log__c sLog;
    SystemEventLogDML sLogDML = new SystemEventLogDML();
    
    try{
      String qStr = 'Select Id From Favorites__c Where ';
      
      List<Favorites__c> favList = new List<Favorites__c>();
      
      if(objType == 'Account'){
        qStr = qStr + ' Account__c = \'' + recId + '\' And Type__c = \'Account\'';
      }
      else if(objType == 'Contact'){
        qStr = qStr + ' Contact__c = \'' + recId + '\' And Type__c = \'Contact\'';
      }
      else if(objType == 'Opportunity'){
        qStr = qStr + ' Opportunity__c = \'' + recId + '\' And Type__c = \'Opportunity\'';
      }
      else if(objType == 'Lead'){
        qStr = qStr + ' Lead__c = \'' + recId + '\' And Type__c = \'Lead\'';
      }   
      qStr += ' And User__c = \'' + UserInfo.getUserId() + '\'';
      favList = database.query(qStr);
      if(favList.size() == 1){
        return 'exists';
      }
      else if(favList.size() == 0){
        
        Favorites__c fav = new Favorites__c();  
        fav.User__c = UserInfo.getUserId();
        if(objType == 'Account'){
          fav.Account__c = recId;
          fav.Type__c     = 'Account';
        }
        else if(objType == 'Contact'){
          fav.Contact__c = recId;
          fav.Type__c     = 'Contact';
        }
        else if(objType == 'Opportunity'){
          fav.Opportunity__c = recId;
          fav.Type__c     = 'Opportunity';
        }
        else if(objType == 'Lead'){
          fav.Lead__c = recId;
          fav.Type__c     = 'Lead';
        }       
        insert fav;
        return 'success';
      }
    }
    catch(Exception e){
      //log the exception on the system event log object
            sLog = sLogDML.generateSysLog('MarkFavorites.markRecordAsFavorite', e.getMessage(), '', slogDml.EvtType[0], UserInfo.getUserId());
            insert sLog;
            
      return 'An error was encountered while updating this record: ' + e.getMessage();
    }
    return 'An error was encountered while updating this record.';
  }
  
}