/**
* @author Original: Bala Sadayappan (501998309) Wipro Last Modified: Nayan Behera (502019744) TCS/GEHC
* @date Original: 1 Sep 2011 Last Modified: 20 Jun 2012
* @description Class to contain global utility functions used throughout the application.
*/


public class GlobalUtility {

    public static  boolean run = true;
    
    public static Map<Id, Account> allOppRelatedAccount;
    
    //used in JSST forwad flow interface, in class JSSTOpportunityCreation to prevent recursive triggering of Opportunity Update DML
    public static boolean inFutureContext = false;
    public static integer IFcontrol = 0;
    
    /**
      * @author Original: Chaitanya Pattamatta (501988930) Wipro
      * @date Original: 1 Sep 2011
      * @description Method to run the trigger only once. Returns Boolean result to the calling trigger.
    */
    public static boolean runOnce() {
        if(run) {
            run=false;
            return true;
        }
        else{
            return run;
        }
    }

    /**
      * @author Original: Bala Sadayappan (501998309) Wipro
      * @date Original: 1 Sep 2011
      * @description Method to return a set of unique Ids given a list of SObjects
      * @param sobs SObjects to return the unique Ids for
    */
    public static set<Id> getUniqueIds(list<SObject> sobs) {
        set<Id> Ids = new set<Id>();
        for (SObject sob : sobs) {
            Ids.add(sob.Id);
        }
        return Ids;
    }

    /**
      * @author Original: Anil Male (501998308) Wipro Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
      * @date Original: 08 Dec 2011 Last Modified: 20 Jun 2012
      * @description Method to return a Admin Id Value
    */
    public static ID getSystemOwnerId(){
        //re-create custom setting test records and reference static profile name variables when running the test class
        CustomSettingsBuilder csb = new CustomSettingsBuilder();        
        return csb.getUtilGEHCAdminId();
    } 

    /**
      * @author Original: Mayank Jain(502207676) TCS
      * @date Original: 01 July 2013 
      * @description Method to return current user record 
    */
    public static User getUserRecord(){
        //re-create custom setting test records and reference static profile name variables when running the test class
        User usr = [Select id ,profile.name, name ,firstname , SSO__c,lastname, Global_Region__c, country from user where id =: userInfo.getUserId()];
        return usr;
    }

    /**
      * @author Original: Mayank Jain(502207676) TCS
      * @date Original: 25 Sep 2013 
      * @description Method to return current user record 
    */
    public static User getUserRecordArg(Id OwnerId){
        //re-create custom setting test records and reference static profile name variables when running the test class
        User usr = null;
        if(OwnerId != null){
          usr = [Select id ,profile.name,SSO__c, name ,LastName,FirstName,Global_Region__c, country from user where id =: OwnerId];
        }
        return usr;
    }

    /**
      * @author Original: Mayank Jain(502207676) TCS
      * @date Original: 15 oct 2013 
      * @description Method to return current user record for the arugement as SSO
    */
    public static User getUserRecordFromSSO(String  ssoStr){
        List<User> usr = new List<User>();
        //re-create custom setting test records and reference static profile name variables when running the test class
        if(ssoStr!=null && ssoStr!=''  ){
            usr = [Select id ,profile.name,SSO__c, name ,LastName,FirstName, Global_Region__c, country from user where SSO__c =: ssoStr];
        }
        if (usr.size() == 1) {
            return usr[0];
        }
        else
            return null;
    }

    /**
      * @author Original: Kapil Baliyan(502221916) TCS
      * @date Original: 16 oct 2013 
      * @description Method to return Record Type for the argument as Object and Record Type Name
    */
    public static RecordType getRecordType(String objNameStr, String recordTypeNameStr){
        RecordType recordType = [Select id, Name From RecordType where sObjectType =: objNameStr and isActive=true and Name =: recordTypeNameStr];
        return recordType;
    }
    
    /**
      * @author Original: Kapil Baliyan(502221916) TCS
      * @date Original: 16 oct 2013 
      * @description Method to return Account Detail(CurrencyIsoCode) for the argument as Account Id
    */
    public static Account getAccountDetails(Id id){
       // Account acc = [select Id, Name, CurrencyIsoCode from Account where Id =:id];
        Account acc = [select Id, Name from Account where Id =:id];
        return acc;
    }

    /**
      * @author Original: Kapil Baliyan(502221916) TCS
      * @date Original: 12 Mar 2014 
      * @description Method to return Account Detail(CurrencyIsoCode) for the argument as Account Id
    */
    public static PricebookEntry getPricebookDetails(String pBookName, String productName, String currencyCode){
      /*  PricebookEntry pbEntry = [select Id, Name, CurrencyIsoCode, Pricebook2Id, Product2Id from PricebookEntry 
                                    where IsActive=True and Pricebook2.Name = :pBookName and Product2.Name = :productName
                                        and CurrencyIsoCode = :currencyCode];    */

        PricebookEntry pbEntry = [select Id, Name, Pricebook2Id, Product2Id from PricebookEntry 
                                    where IsActive=True and Pricebook2.Name = :pBookName and Product2.Name = :productName ];
        return pbEntry;
    }
    
    /**
    * @author Original: GEHC Japan IT
    * @date Original:17 Dec 2013
    * @description to check whether is Japan user
    * @param
    */
     public boolean isJapanUser(){
        boolean isJapan=false;
        String usrProfileName = [select u.Profile.Name from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        if(usrProfileName.contains('JAPAN')){
            isJapan=true;
        }
        return isJapan;
    } 
    
    /**
    * @author Original: Birlasoft Consultant
    * @date Original:23 May 2014
    * @description to check opportunity is Japan
    * @param
    */
     public void populateRelatedAccountMap(List<Opportunity> newOppty){
        if(allOppRelatedAccount == null){
            Set<Id> AccountId = new Set<Id>();
            for(Opportunity oppty : newOppty){
                if(oppty.Accountid != null){
                    AccountId.add(oppty.AccountId);
                }
            }
            allOppRelatedAccount = new Map<Id,Account>([Select Id, Global_Region__c, Sub_Region__c, LS_Account__c from Account where id in :AccountId]);
        }
        
    }    

    /**
    * @author Original: GEHC Japan IT
    * @date Original:17 Dec 2013
    * @description to check Global region, region
    * @param
    */
    public List<Opportunity> isJapanOpportunity(List<Opportunity> opptyList){
        List<Opportunity> opjapan =  new List<Opportunity>();
       // Map<Id,Id> optyAccountMap = new  Map<Id,Id>();
        populateRelatedAccountMap(opptyList);
        for(Opportunity opp:opptyList){
            if(allOppRelatedAccount.containsKey(opp.AccountID) != null){
                if(allOppRelatedAccount.get(opp.AccountID).Global_Region__c == 'APAC' && allOppRelatedAccount.get(opp.AccountID).Sub_Region__c == 'Japan' && allOppRelatedAccount.get(opp.AccountID).LS_Account__c != true){
                    opjapan.add(opp);
                }
            }
        }
        return opjapan;
    }
    
    /**
    * @author Original: Birlasoft Consultant
    * @date Original:27 May 2014
    * @description to return Non Japan Opportunities
    * @param
    */
    public List<Opportunity> isNonJapanOppty(List<Opportunity> opptyList){
        List<Opportunity> nonjapanoppList =  new List<Opportunity>();
       // Map<Id,Id> optyAccountMap = new  Map<Id,Id>();
        populateRelatedAccountMap(opptyList);
        for(Opportunity opp:opptyList){
            if(allOppRelatedAccount.containsKey(opp.AccountID) != null){
                if(allOppRelatedAccount.get(opp.AccountID).Global_Region__c != 'APAC' && allOppRelatedAccount.get(opp.AccountID).Sub_Region__c != 'Japan' && allOppRelatedAccount.get(opp.AccountID).LS_Account__c == true){
                    nonjapanoppList.add(opp);
                }
            }
        }
        return nonjapanoppList;
    }

    /**
    * @author Original: TJ Madsen
    * @date Original:10 Jan 2014
    * @description Class to send fiscal quarter information
    * @param
    */    
    public Class FiscalQuarter{
        public String year = '';
        public Integer quarter = 0;

        public String getFormatted(String format){
          if(format == 'Japan'){
            return year+'/'+quarter+'Q';
          }else{
            return year+'/Q'+quarter;
          }
        }
    }

    /**
    * @author Original: GEHC Japan IT
    * @date Original:17 Dec 2013
    * @description to check whether is Japan user
    * @param
    */
    public static FiscalQuarter getFiscalQuarter(date dateInfo){
          FiscalQuarter fq = new FiscalQuarter();
          fq.quarter =  [Select Number From Period Where type = 'Quarter' and StartDate <= :dateInfo AND EndDate >= :dateInfo].Number;
          fq.year =  String.valueOf(dateInfo.year());
          return fq;
    }

}