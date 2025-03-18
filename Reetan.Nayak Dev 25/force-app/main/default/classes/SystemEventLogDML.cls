/**
* @author Jesfer Baculod (502068421) Cloud Sherpas/GEHC
* @date Original: 27 Aug 2012, Last Modified: 06 Sept 2012
* @description Global utility class that gives the ability to create system logs for application support.
*/
public class SystemEventLogDML{
  
  /**
  * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
  * @date Original: 27 Aug 2012, Last Modified: 06 Sept 2012
  * @description Helper Method that creates a system event log on every unhandled exceptions found while running a certain class/method
  * @param src Class/Function that writes the system event log
  * @param msg Details of the log itself
  * @param stats  Error code/Event code/Status code that identifies the log message 
  * @param evtType Type of system event log (Error, Debug, Info)
  * @param ruser Running User
  */
  
  public System_Event_Log__c generateSysLog(string src, string msg, string stats, EventType evtType, Id ruser){
    System_Event_Log__c slog = new System_Event_Log__c();
    slog.Event_Type__c = evtType.name();
    slog.Log_Source__c = src;
    slog.Status_Code__c = stats;
    slog.OwnerId = ruser;
    slog.Message__c = msg;
    return slog;
  }
  
  public enum EventType { ERROR, DEBUG, INFO } 
  
  public list <EventType> EvtType = new EventType[]{
    EventType.ERROR, //EvtType[0]
    EventType.DEBUG, //EvtType[1]
    EventType.INFO //EvtType[2]
  };
  
}