public with sharing class OpportunityForecastingGridController {       

    // a user-defined class that will serialize to the JSON expected by the ExtJS DirectProxy api methods
    public class CRUDResponse {
        public Boolean success;
        public String errorMessage;
        public List<SObject> records;
        public Integer total;
        CRUDResponse() {
            records = new List<SObject>();
            success = true;
        }
    }
    
    // a user-defined class that will serialize to the JSON expected by the ExtJS DirectProxy api methods
    public class ListResponse {
        public Boolean success;
        public String errorMessage;
        public List<Map<String,String>> records;
        public Integer total;
        ListResponse() {
            records = new List<Map<String,String>>();
            success = true;
        }
    }    
    
    // Unfortunately JS Remoting member functions must be static, so cannot access non-static class members,
    // which means we cannot cache query results in this controller but must respond to each request anew
    public class QueryObj {
        public List<Map<String, String> > filterParams;
        public List<Map<String, String> > filters;
        public Boolean myTeam;
        public Boolean showClosed;
        public String filter;
        public Integer start;
        public Integer recordCount;
        public List<Map<String, String> > sortParams;
    }
    
    public class CellEditObj {
        public List<Map<String, String> > records;
    }
    
    public class SearchQueryObj {
        public Integer start;
        public Integer recordCount;
        public String searchStr;
        public String obj;
        public String field;
    }    
    
/*  REETAN
    private static Map<String, Decimal> getCurrencyMap(){
        Map<String, Decimal> CurrencyTypeMap = new Map<String, Decimal>();
        for(CurrencyType ct : [SELECT Id, ISOCode, ConversionRate, IsActive FROM CurrencyType WHERE IsActive=TRUE Limit 1000]) {
            CurrencyTypeMap.put(ct.ISOCode,ct.ConversionRate);
        }  
        return CurrencyTypeMap;
    }
    REETAN    */
    
    public static String getGlobalRegion(){
        SObject user = [select Id, Global_Region__c from User where id = :UserInfo.getUserId() LIMIT 1];
        return String.valueOf(user.get('Global_Region__c'));
    }


    // return account list for filter autocomplete
    @RemoteAction
    public static CRUDResponse getObjAutocomplete(SearchQueryObj sqobj){
        String qstr = 'SELECT id, name from '+ sqobj.obj +' ';
        if(sqobj.searchStr != null && sqobj.searchStr != ''){
            String search = String.escapeSingleQuotes(sqobj.searchStr);
            qstr +=  ' WHERE name LIKE \'%'+search+'%\' ';
            qstr += ' LIMIT 15';
        }
        else{
            qstr += ' LIMIT 0';
        }       
        List<SObject> results = Database.query(qstr);      
        SObject firstItem = new Account();
        firstItem.put('Name', sqobj.searchStr);
        firstItem.put('Id', sqobj.searchStr);
        results.add(0, firstItem);
        CRUDResponse tmp = new CRUDResponse();
        tmp.records = results;
        //tmp.errorMessage = qstr;
        return tmp;
    }
    
    // return account list for filter autocomplete
    @RemoteAction
    public static ListResponse getFieldAutocomplete(SearchQueryObj sqobj){
        String obj = String.escapeSingleQuotes(sqobj.obj);
        Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjToken = objTypeMap.get(obj);
        Map<String, Schema.SObjectField> fieldMap = sobjToken.getDescribe().fields.getMap();
        String field = String.escapeSingleQuotes(sqobj.field);
        String search;
        List<Map<String, String>> results = new List<Map<String, String>>();      
        Map<String, String> firstItemresultMap = new Map<String, String>();        
        if(sqobj.searchStr!= null){
            search = String.escapeSingleQuotes(sqobj.searchStr);
            firstItemresultMap.put('id',search);
            firstItemresultMap.put('text',search);
            results.add(firstItemresultMap);
        }      
        if (field != 'Id' && fieldMap.get(field).getDescribe().getType() == Schema.DisplayType.Picklist) {
            List<Schema.PicklistEntry> r = fieldMap.get(field).getDescribe().getPicklistValues();
            System.debug('***TJ*** Size:'+r.size());
            for(Integer i = 0;i<r.size();i++){
                String temp = r[i].getValue();
                if((temp != null && search == null ) ||(temp != null  && temp.containsIgnoreCase(search))){                   
                    Map<String, String> resultMap = new Map<String, String>();
                    resultMap.put('id',temp);
                    resultMap.put('text',temp);
                    results.add(resultMap);
                }
            }
        }
        else{
            String Query = 'Select '+field+' From '+obj;
            if(field == 'Region__c' || field == 'Zone__c' || field == 'Country_Long_Name__c' || field == 'Global_Sub_Region__c') {
                //Condition added if Global Region of User is Global then display all values which are there in custom setting
               if(GlobalUtility.getUserRecord().Global_Region__c !='Global')
                  Query = Query + ' Where Global_Region__c = \''+ GlobalUtility.getUserRecord().Global_Region__c +'\'';
            }
            System.debug('***TJ*** Size:'+ Query);
            Query += ' ORDER BY'+' ' + field ;
            Query = Query + ' limit 3000' ;
            List<SObject> tmpR = Database.query(Query);           
            System.debug('***TJ*** Size:'+tmpR );

            for(SObject so:tmpR){   
                String temp = String.valueOf(so.get(field));
                //if(search != null){
                if((temp != null && search == null ) ||(temp != null  && temp.containsIgnoreCase(search))){                   
                    Map<String, String> resultMap = new Map<String, String>();
                    resultMap.put('id',temp);
                    resultMap.put('text',temp);
                    results.add(resultMap);
                }
            }
        }       
        ListResponse tmp = new ListResponse();
        tmp.records = results;     
        return tmp;
    }    


    // turn grid's page load/sort request into SOQL and return data
    @ReadOnly
    @RemoteAction
    public static ListResponse getAggregates(QueryObj qobj) {
        RecordType RecTypeObj = [SELECT Id,Name FROM RecordType WHERE Name = 'Term Opportunity'];
   //     Map<String, Decimal> CurrencyTypeMap = getCurrencyMap();
        ListResponse resp = new ListResponse();
        //Object for query
        String obj = 'Opportunity';      
        //Filter parameterrs from column headers
        List<Map<String, String>> columnFilterParams = null;
        if (qobj.filter != null) {
            //Parse grid column filters from JSON text into objects
            columnFilterParams = parseFilterResponse(qobj.filter);
        }
        //Filter parameters from grid store
        List<Map<String, String>> storeFilterParams = qobj.filterParams;
        List<Map<String, String>> extraFilterParams = qobj.filters;       
        Map<String,String> whereString = generateWhere(storeFilterParams, columnFilterParams, extraFilterParams,true, true);
        //Field String for query
        String fields = 'Id,CurrencyIsoCode,Amount,Forecast_Category__c,Manager_Forecast_Category__c,Manager_Flag__c,Account.Global_Region__c,China_Amount__c,Expiring_Contract_Amount__c,Japan_AppliProduct__c,Is_Top_X__c ';
        String  qstr = 'SELECT ' + fields + ' FROM ' + obj;
        // Get user's role ID and parent role ID
        List <UserRole> usrrolelst = null;
        // Get users falling into those roles
        List <User> usrlst = null;
        if(qobj.myTeam == null || qobj.myTeam){
            usrrolelst = [select id from UserRole where id=:userinfo.getUserRoleId() or ParentRoleId=:userinfo.getUserRoleId() Limit 1000];
            usrlst = [select id from user where UserRoleId in :usrrolelst Limit 1000];
            qstr += ' WHERE ownerid IN :usrlst AND CloseDate!=null AND  Order_Source__c != \'' + 'Partner Stock' + '\' AND Forecast_Category__c!=null AND RecordTypeId !=\''+RecTypeObj.Id+'\''; 
        }else{
            qstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null AND Order_Source__c != \'' + 'Partner Stock' + '\' AND RecordTypeId !=\''+RecTypeObj.Id+'\''; 
        }
        if(whereString.get('OpportunityLineItems').length() > 1){
            qstr += ' AND Id IN (Select OpportunityId from OpportunityLineItem '+whereString.get('OpportunityLineItems')+') ';
        }        
        qstr += whereString.get('Opportunity');
        //Build Response Grid
        Map<String, Map<String, Decimal>> responseMap = new Map<String,Map<String, Decimal>>();      
        Map<String, Decimal> closed = new Map<String, Decimal>();
        closed.put('Quantity', 0);
        closed.put('Mgr_Forecast', 0);
        closed.put('Mgr_Won', 0);
        closed.put('Mgr_Committed', 0);
        closed.put('Mgr_Committed_At_Risk', 0);
        closed.put('Mgr_Upside', 0);
        closed.put('Mgr_Upside_High', 0);
        closed.put('Mgr_Upside_Low', 0);
        closed.put('Mgr_None', 0);
        closed.put('Total', 0);
        responseMap.put('Closed', closed);
        Map<String, Decimal> committed = new Map<String, Decimal>();
        committed.put('Quantity', 0);
        committed.put('Mgr_Forecast', 0);
        committed.put('Mgr_Won', 0);
        committed.put('Mgr_Committed', 0);
        committed.put('Mgr_Committed_At_Risk', 0);
        committed.put('Mgr_Upside', 0);
        committed.put('Mgr_Upside_High', 0);
        committed.put('Mgr_Upside_Low', 0);
        committed.put('Mgr_None', 0);
        committed.put('Total', 0);
        responseMap.put('Committed', committed);     
        Map<String, Decimal> upside = new Map<String, Decimal>();
        upside.put('Quantity', 0);
        upside.put('Mgr_Forecast', 0);
        upside.put('Mgr_Won', 0);
        upside.put('Mgr_Committed', 0);
        upside.put('Mgr_Committed_At_Risk', 0);
        upside.put('Mgr_Upside', 0);
        upside.put('Mgr_Upside_High', 0);
        upside.put('Mgr_Upside_Low', 0);
        upside.put('Mgr_None', 0);
        upside.put('Total', 0);
        responseMap.put('Upside', upside);      
        Map<String, Decimal> open = new Map<String, Decimal>();
        open.put('Quantity', 0);
        open.put('Mgr_Forecast', 0);
        open.put('Mgr_Won', 0);
        open.put('Mgr_Committed', 0);
        open.put('Mgr_Committed_At_Risk', 0);
        open.put('Mgr_Upside', 0);
        open.put('Mgr_Upside_High', 0);
        open.put('Mgr_Upside_Low', 0);
        open.put('Mgr_None', 0);
        open.put('Total', 0);
        responseMap.put('Open', open);
        try {
            for (Opportunity rlit : Database.query(qstr)) {             
                    String orderForecastCat = String.valueOf(rlit.get('Forecast_Category__c'));
                    Decimal amount = 0;
                    System.debug('swap' + rlit.getSobject('Account') + rlit.get('Id'));
                  /*    REETAN
                    if(rlit.getSobject('Account')!= null && String.valueOf(rlit.getSobject('Account').get('Global_Region__c')) == 'CHINA' && rlit.get('China_Amount__c') != null && rlit.get('CurrencyIsoCode') != null && CurrencyTypeMap.containsKey(String.valueOf(rlit.get('CurrencyIsoCode')))){                       
                            amount = Decimal.valueOf(String.valueOf(rlit.get('China_Amount__c')));
                    //        amount = amount/CurrencyTypeMap.get(String.valueOf(rlit.get('CurrencyIsoCode')));
                    }                    
                    else{
                        if(rlit.get('Amount') != null && rlit.get('CurrencyIsoCode') != null && CurrencyTypeMap.containsKey(String.valueOf(rlit.get('CurrencyIsoCode')))){
                            amount = Decimal.valueOf(String.valueOf(rlit.get('Amount')));
                            amount = amount/CurrencyTypeMap.get(String.valueOf(rlit.get('CurrencyIsoCode')));                        
                        }    
                    }
                    REETAN    */ 
                    if(orderForecastCat == 'Closed' || orderForecastCat == 'Open' || orderForecastCat == 'Upside' || orderForecastCat == 'Committed'){
                        String mgrForecastCat = String.valueOf(rlit.get('Manager_Forecast_Category__c'));
                        String mgrFlag = String.valueOf(rlit.get('Manager_Flag__c')); 
                        responseMap.get(orderForecastCat).put('Quantity',responseMap.get(orderForecastCat).get('Quantity') + 1);
                        responseMap.get(orderForecastCat).put('Total',responseMap.get(orderForecastCat).get('Total') + amount);
                        if(mgrForecastCat == 'Won'){
                            responseMap.get(orderForecastCat).put('Mgr_Forecast',responseMap.get(orderForecastCat).get('Mgr_Forecast') + amount);
                            responseMap.get(orderForecastCat).put('Mgr_Won',responseMap.get(orderForecastCat).get('Mgr_Won') + amount);
                        }
                        else if(mgrForecastCat == 'Committed'){
                            responseMap.get(orderForecastCat).put('Mgr_Forecast',responseMap.get(orderForecastCat).get('Mgr_Forecast') + amount);
                            responseMap.get(orderForecastCat).put('Mgr_Committed',responseMap.get(orderForecastCat).get('Mgr_Committed') + amount);
                            if(mgrFlag == 'At Risk'){
                                responseMap.get(orderForecastCat).put('Mgr_Committed_At_Risk',responseMap.get(orderForecastCat).get('Mgr_Committed_At_Risk') + amount);
                            }
                        }
                        else if(mgrForecastCat == 'Upside'){
                            responseMap.get(orderForecastCat).put('Mgr_Upside',responseMap.get(orderForecastCat).get('Mgr_Upside') + amount);
                            if(mgrFlag == 'High'){
                                responseMap.get(orderForecastCat).put('Mgr_Upside_High',responseMap.get(orderForecastCat).get('Mgr_Upside_High') + amount);
                            }else if(mgrFlag == 'Low'){
                                responseMap.get(orderForecastCat).put('Mgr_Upside_Low',responseMap.get(orderForecastCat).get('Mgr_Upside_Low') + amount);
                            }
                        }
                        else{
                            responseMap.get(orderForecastCat).put('Mgr_None',responseMap.get(orderForecastCat).get('Mgr_None') + amount);
                        }
                    }
                
            }
        } catch (Exception e) {
            resp.success = false;
            resp.records = null;
            resp.errorMessage = e.getMessage() + '  QUERY:'+qstr;  //debugging - remove before prod
            return resp;
        }
        Map<String,String> closedRow = new Map<String, String>();
        closedRow.put('Order_Forecast_Category', 'Closed');
        closedRow.put('Quantity', String.valueOf(responseMap.get('Closed').get('Quantity')));
        closedRow.put('Mgr_Forecast', String.valueOf(responseMap.get('Closed').get('Mgr_Forecast')));
        closedRow.put('Mgr_Won', String.valueOf(responseMap.get('Closed').get('Mgr_Won')));
        closedRow.put('Mgr_Closed', String.valueOf(responseMap.get('Closed').get('Mgr_Committed')));
        closedRow.put('Mgr_Committed_At_Risk', String.valueOf(responseMap.get('Closed').get('Mgr_Committed_At_Risk')));
        closedRow.put('Mgr_Upside', String.valueOf(responseMap.get('Closed').get('Mgr_Upside')));
        closedRow.put('Mgr_Upside_High', String.valueOf(responseMap.get('Closed').get('Mgr_Upside_High')));
        closedRow.put('Mgr_Upside_Low', String.valueOf(responseMap.get('Closed').get('Mgr_Upside_Low')));
        closedRow.put('Mgr_None', String.valueOf(responseMap.get('Closed').get('Mgr_None')));
        closedRow.put('Total', String.valueOf(responseMap.get('Closed').get('Total')));
        resp.records.add(closedRow);
        Map<String,String> committedRow = new Map<String, String>();
        committedRow.put('Order_Forecast_Category', 'Committed');
        committedRow.put('Quantity', String.valueOf(responseMap.get('Committed').get('Quantity')));
        committedRow.put('Mgr_Forecast', String.valueOf(responseMap.get('Committed').get('Mgr_Forecast')));
        committedRow.put('Mgr_Won', String.valueOf(responseMap.get('Committed').get('Mgr_Won')));
        committedRow.put('Mgr_Committed', String.valueOf(responseMap.get('Committed').get('Mgr_Committed')));
        committedRow.put('Mgr_Committed_At_Risk', String.valueOf(responseMap.get('Committed').get('Mgr_Committed_At_Risk')));
        committedRow.put('Mgr_Upside', String.valueOf(responseMap.get('Committed').get('Mgr_Upside')));
        committedRow.put('Mgr_Upside_High', String.valueOf(responseMap.get('Committed').get('Mgr_Upside_High')));
        committedRow.put('Mgr_Upside_Low', String.valueOf(responseMap.get('Committed').get('Mgr_Upside_Low')));
        committedRow.put('Mgr_None', String.valueOf(responseMap.get('Committed').get('Mgr_None')));
        committedRow.put('Total', String.valueOf(responseMap.get('Committed').get('Total')));
        resp.records.add(committedRow);
        Map<String,String> upsideRow = new Map<String, String>();
        upsideRow.put('Order_Forecast_Category', 'Upside');
        upsideRow.put('Quantity', String.valueOf(responseMap.get('Upside').get('Quantity')));
        upsideRow.put('Mgr_Forecast', String.valueOf(responseMap.get('Upside').get('Mgr_Forecast')));
        upsideRow.put('Mgr_Won', String.valueOf(responseMap.get('Upside').get('Mgr_Won')));
        upsideRow.put('Mgr_Committed', String.valueOf(responseMap.get('Upside').get('Mgr_Committed')));
        upsideRow.put('Mgr_Committed_At_Risk', String.valueOf(responseMap.get('Upside').get('Mgr_Committed_At_Risk')));
        upsideRow.put('Mgr_Upside', String.valueOf(responseMap.get('Upside').get('Mgr_Upside')));
        upsideRow.put('Mgr_Upside_High', String.valueOf(responseMap.get('Upside').get('Mgr_Upside_High')));
        upsideRow.put('Mgr_Upside_Low', String.valueOf(responseMap.get('Upside').get('Mgr_Upside_Low')));
        upsideRow.put('Mgr_None', String.valueOf(responseMap.get('Upside').get('Mgr_None')));
        upsideRow.put('Total', String.valueOf(responseMap.get('Upside').get('Total')));
        resp.records.add(upsideRow);
        Map<String,String> openRow = new Map<String, String>();
        openRow.put('Order_Forecast_Category', 'Open');
        openRow.put('Quantity', String.valueOf(responseMap.get('Open').get('Quantity')));
        openRow.put('Mgr_Forecast', String.valueOf(responseMap.get('Open').get('Mgr_Forecast')));
        openRow.put('Mgr_Won', String.valueOf(responseMap.get('Open').get('Mgr_Won')));
        openRow.put('Mgr_Committed', String.valueOf(responseMap.get('Open').get('Mgr_Committed')));
        openRow.put('Mgr_Committed_At_Risk', String.valueOf(responseMap.get('Open').get('Mgr_Committed_At_Risk')));
        openRow.put('Mgr_Upside', String.valueOf(responseMap.get('Open').get('Mgr_Upside')));
        openRow.put('Mgr_Upside_High', String.valueOf(responseMap.get('Open').get('Mgr_Upside_High')));
        openRow.put('Mgr_Upside_Low', String.valueOf(responseMap.get('Open').get('Mgr_Upside_Low')));
        openRow.put('Mgr_None', String.valueOf(responseMap.get('Open').get('Mgr_None')));
        openRow.put('Total', String.valueOf(responseMap.get('Open').get('Total')));
        resp.records.add(openRow);
        resp.errorMessage = '  QUERY:'+qstr;  //debugging - remove before prod
        return resp;
    }


    // turn grid's page load/sort request into SOQL and return data
    @ReadOnly
    @RemoteAction
    public static CRUDResponse query(QueryObj qobj) {
        RecordType RecTypeObj = [SELECT Id,Name FROM RecordType WHERE Name = 'Term Opportunity'];
        /* <REETAN>     Map<String, Decimal> CurrencyTypeMap = getCurrencyMap();    <REETAN> */
        CRUDResponse resp = new CRUDResponse();
        //Object for query
        String obj = 'Opportunity';    
        //Filter parameterrs from column headers
        List<Map<String, String>> columnFilterParams = null;
        if (qobj.filter != null) {
            //Parse grid column filters from JSON text into objects
            columnFilterParams = parseFilterResponse(qobj.filter);
        }
        System.debug('@@SWAP' + columnFilterParams );
        //Filter parameters from grid store
        List<Map<String, String>> storeFilterParams = qobj.filterParams;
        List<Map<String, String>> extraFilterParams = qobj.filters;
        System.debug('@@SWAP' + storeFilterParams + '3' + extraFilterParams );
        Map<String, String> whereString = generateWhere(storeFilterParams, columnFilterParams, extraFilterParams, qobj.showClosed, false);
        //Field String for query
        String fields = 'Id,Custom_Sort_2__c,Owner.Name,Name,Account.Id,Account.Name,Account.Zone__c,Manager_Forecast_Last_Modified_Date__c,Manager_Forecast_Last_Modified_By__c,Account.Region__c,Account.Global_Region__c,China_Amount__c,ParentOpportunity__c, ParentOpportunity__r.Name,CurrencyIsoCode,Amount,CloseDate,Estimated_Sales_Date__c,Forecast_Category__c,Manager_Forecast_Category__c,Manager_Flag__c,Order_at_Risk__c,Comments__c,Is_Top_X__c,(Select Id, Modality__c,CurrencyIsoCode,Totalprice, Business_Category__c, Product_Name__c, Domain_Name__c, Quantity  from OpportunityLineItems ) ';
        // construct two queries: 1. Count query  2. Field query
        String countstr = 'SELECT COUNT() FROM ' + obj;
        String  qstr = 'SELECT ' + fields + ' FROM ' + obj;
        // Get user's role ID and parent role ID
        List <UserRole> usrrolelst = null;
        // Get users falling into those roles
        List <User> usrlst = null;
        if(qobj.myTeam){
            usrrolelst = [select id from UserRole where id=:userinfo.getUserRoleId() or ParentRoleId=:userinfo.getUserRoleId() Limit 1000];
            usrlst = [select id from user where UserRoleId in :usrrolelst Limit 1000];
            countstr += ' WHERE ownerid IN :usrlst AND  CloseDate!=null AND Forecast_Category__c!=null AND Order_Source__c != \'' + 'Partner Stock' + '\' AND RecordTypeId != \''+RecTypeObj.Id+ '\'';
            qstr += ' WHERE ownerid IN :usrlst AND  CloseDate!=null AND Forecast_Category__c!=null AND Order_Source__c != \'' + 'Partner Stock' + '\' AND RecordTypeId != \''+RecTypeObj.Id+ '\''; 
        }else{
            countstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null AND Order_Source__c != \'' + 'Partner Stock' + '\' AND RecordTypeId != \''+RecTypeObj.Id+ '\'';
            qstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null AND Order_Source__c != \'' + 'Partner Stock' + '\' AND RecordTypeId != \''+RecTypeObj.Id+ '\''; 
        }
        if(whereString.get('OpportunityLineItems').length() > 1){
            countstr += ' AND Id IN (Select OpportunityId from OpportunityLineItem '+whereString.get('OpportunityLineItems')+') ';
            qstr += ' AND Id IN (Select OpportunityId from OpportunityLineItem '+whereString.get('OpportunityLineItems')+') ';
        }
        countstr += whereString.get('Opportunity');
        System.debug('@@SWAP' + countstr);
        resp.total = Database.countQuery(countstr);   // ExtJS grid needs the true total here
        qstr += whereString.get('Opportunity');     
        if (qobj.sortParams != null) {
            qstr += ' ORDER BY ';          
            qstr += qobj.sortParams[0].get('property');          
            // SOQL only supports a single direction, so ignoring others. Probably should return error instead.
            qstr += ' ' + qobj.sortParams[0].get('direction') + ' NULLS LAST ';
        }else{
            qstr += ' ORDER BY Amount DESC NULLS LAST ';
        }       
        // data reduction: LIMIT and OFFSET
        // calculate the index of the first record returned by the query
        // OFFSET has some tricky limitations.  First, the maximum value is 2000, so if the first desired record
        // is beyond that point we will have to access some records we don't want.  Second, the use of OFFSET
        // causes the maximum number of records returned to be 200 - this appears to be undocumented.
        Integer startrec = 0;
        if (qobj.recordCount > 200) {
            // cannot use OFFSET; start at zero and include records before our desired region
            Integer reclimit = qobj.start + qobj.recordCount;
            qstr += ' LIMIT ' + String.valueOf(reclimit);
        } else {
            startrec = Math.min(qobj.start, 2000);
            // record count to get is the sum of the mandatory unwanted records (those over 2000) and those we want
            Integer reclimit = (qobj.start - startrec) + qobj.recordCount;
            qstr += ' LIMIT ' + String.valueOf(reclimit);
            qstr += ' OFFSET ' + String.valueOf(startrec);
        }       
        Integer current_result = startrec;        // initialize with the true offset
        try {
            for (Opportunity rlit : Database.query(qstr)) {               
                    if ((current_result >= qobj.start) && (current_result < (qobj.start + qobj.recordCount))) {
                        
                        Decimal amount = 0;
                        Decimal ExpiringContractAmount = 0;
                        String currencyIsoCode = '';
                        /*    <REETAN>
                        if(rlit.getSobject('Account') != null && String.valueOf(rlit.getSobject('Account').get('Global_Region__c')) == 'CHINA' && rlit.get('China_Amount__c') != null && rlit.get('CurrencyIsoCode') != null && CurrencyTypeMap.containsKey(String.valueOf(rlit.get('CurrencyIsoCode')))){                          
                                amount = Decimal.valueOf(String.valueOf(rlit.get('China_Amount__c')));
                                amount = amount/CurrencyTypeMap.get(String.valueOf(rlit.get('CurrencyIsoCode')));
                                ExpiringContractAmount= Decimal.valueOf(String.valueOf(rlit.get('China_Amount__c')));                          
                                rlit.put('Amount', amount);
                                rlit.put('Expiring_Contract_Amount__c', ExpiringContractAmount);
                                resp.records.add(rlit);
                        }
                        else{
                            if(rlit.get('Amount') != null && rlit.get('CurrencyIsoCode') != null && CurrencyTypeMap.containsKey(String.valueOf(rlit.get('CurrencyIsoCode')))){
                                amount = Decimal.valueOf(String.valueOf(rlit.get('Amount')));
                                amount = amount/CurrencyTypeMap.get(String.valueOf(rlit.get('CurrencyIsoCode')));
                                ExpiringContractAmount = Decimal.valueOf(String.valueOf(rlit.get('Amount')));
                            }
                        currencyIsoCode = String.valueOf(rlit.get('CurrencyIsoCode'));
                        system.debug('###currencyIsoCode: '+currencyIsoCode);    
                        rlit.put('Amount', amount);
                        rlit.put('Expiring_Contract_Amount__c', ExpiringContractAmount);
                        rlit.put('CurrencyIsoCode', currencyIsoCode);
                        resp.records.add(rlit);
                        }
                        <REETAN>    */
                    }
                    current_result++ ;               
            }
        } catch (Exception e) {
            resp.success = false;
            resp.records = null;
            resp.errorMessage = e.getMessage() + '  QUERY:'+qstr;  //debugging - remove before prod
            return resp;
        }
        resp.errorMessage = '  QUERY:'+qstr;  //debugging - remove before prod
        return resp;
    }


    // "update" and "delete" are keywords so must pick something else
    // Ken Thompson is supposed to have said that if he could redo anything about Unix,
    // he'd spell "creat" with an extra "e".  So in that spirit:
    @RemoteAction
    public static CRUDResponse updat(CellEditObj ceo) {
        CRUDResponse resp = new CRUDResponse();
        Boolean Flag = False ;
        Map<String, String> recmap = ceo.records[0]; // [Id,"10002332222"][Manager_Forecast_Category__c  Upside]
        Set <String> KeySet = recmap.keySet();  
        if(KeySet.contains('Manager_Flag__c') || KeySet.contains('Manager_Forecast_Category__c')){
           Flag = True;
        }
        Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjToken = objTypeMap.get('Opportunity');
        SObject sobj = sobjToken.newSObject(recmap.get('Id'));
        Map<String, Schema.SObjectField> fieldMap = sobjToken.getDescribe().fields.getMap();
        for (String k : recmap.keySet()) {
            Boolean emptyValue = (recmap.get(k) == null) || (recmap.get(k) == '') ||
                                 (fieldMap.get(k).getDescribe().getType() != Schema.DisplayType.string) &&
                                 (recmap.get(k) == 'null');

                if (k != 'Id') {
                    if (emptyValue) {
                        sobj.put(k, null);
                    } 
                    else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.date) {
                        // Date fields appear to need to be set from Date values, not strings, so:
                        sobj.put(k, Date.valueOf(recmap.get(k)));
                    } 
                    else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.boolean) {
                        sobj.put(k, Boolean.valueOf(recmap.get(k)));
                    } 
                    else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.integer) {
                        sobj.put(k, Integer.valueOf(recmap.get(k)));
                    } 
                    else if (fieldMap.get(k).getDescribe().getType() == Schema.DisplayType.double) {
                        sobj.put(k, Double.valueOf(recmap.get(k)));
                    }
                    else
                         sobj.put(k, recmap.get(k));
                     // TODO: handle other types, esp. Currency
                }
        }
        try {
            update sobj;
            /*    <REETAN>
            if(Flag == True){
             OpportunityDML UpdateChildOpp = New OpportunityDML(); 
             UpdateChildOpp.UpdateChildOpportunity(sobj);
            }
            <REETAN>    */
        } 
        catch (Exception e) {
            resp.success = false;
            resp.errorMessage = 'update: failed with error ' + e.getMessage();
            return resp;
        }
        return resp;
    }


    /*    generateWhere    */
    static Map<String,String> generateWhere(List<Map<String, String> > storeFilters, List<Map<String, String> > gridFilters, List<Map<String, String> > extraFilters, Boolean showClosed, Boolean forAggregate){
        Map<String, String> whereResponse = new Map<String, String>();
        String optyWhereString = '';
        String optyLineItemWhereString = '';  
        if(showClosed){
            optyWhereString += ' AND (Forecast_Category__c != \'Omitted\')';   
        }
        else{
            optyWhereString += ' AND (Forecast_Category__c != \'Closed\' AND Forecast_Category__c != \'Omitted\')';
        }               
        // Process store filters
        if (storeFilters != null) {         
            // collect sort fields/directions
            for (Integer i = 0; i < storeFilters.size(); i++) {
                String val = storeFilters[i].get('value');
                String field = storeFilters[i].get('property');
                if(val != null && val != '' && field != null){
                    val = String.escapeSingleQuotes(val);
                    field = String.escapeSingleQuotes(field);
                    if(field == 'CloseDate'){
                        Date endDate = null;
                        Date startDate = null;
                        if(val == 'this' || val == 'This Quarter'){
                            endDate =  [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
                            startDate =  [Select StartDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].StartDate;
                        }
                        else if(val == 'next' || val == 'Next Quarter'){
                            endDate =  [Select EndDate From Period Where type = 'Quarter' and StartDate = NEXT_FISCAL_QUARTER].EndDate;
                            startDate =  [Select StartDate From Period Where type = 'Quarter' and StartDate = NEXT_FISCAL_QUARTER].StartDate;
                        }
                        else if(val == 'last' || val == 'Last Quarter'){
                            endDate =  [Select EndDate From Period Where type = 'Quarter' and StartDate = LAST_FISCAL_QUARTER].EndDate;
                            startDate =  [Select StartDate From Period Where type = 'Quarter' and StartDate = LAST_FISCAL_QUARTER].StartDate;
                        }
                        optyWhereString += ' AND ';
                        optyWhereString += ' CloseDate >= ';
                        optyWhereString += ' '+String.valueOf(startDate);
                        optyWhereString += ' AND ';
                        optyWhereString += ' CloseDate <= ';
                        optyWhereString += ' '+String.valueOf(endDate);
                        optyWhereString += ' AND ';
                        optyWhereString += ' CALENDAR_Year(CloseDate)= ';
                        optyWhereString += ' '+startDate.year();
                    }
                    else if(field.contains('OpportunityLineItems.')){
                        field = field.replace('OpportunityLineItems.', '');
                        if(field =='Tier_1_P_L__c'||field =='Tier_2_P_L__c'||field =='Tier_3_P_L__c'||field =='Tier_4_P_L__c'){
                            optyLineItemWhereString += ' AND ';
                            optyLineItemWhereString += field;
                            optyLineItemWhereString += ' = \'';
                            optyLineItemWhereString += val;
                            optyLineItemWhereString += '\' ';
                        }
                        else{
                            optyLineItemWhereString += ' AND ';
                            optyLineItemWhereString += field;
                            optyLineItemWhereString += ' LIKE \'%';
                            optyLineItemWhereString += val;
                            optyLineItemWhereString += '%\' ';
                        }
                    }
                    else if(field == 'Account.Zone__c' || field == 'Account.Region__c' || field == 'Account.Sub_Region__c' || field == 'Account.Country_Name__c'){
                        optyWhereString += ' AND ';
                        optyWhereString += field;
                        optyWhereString += ' = \'';
                        optyWhereString += val;
                        optyWhereString += '\' ';
                    }
                    else{
                        optyWhereString += ' AND ';
                        optyWhereString += field;
                        optyWhereString += ' LIKE \'%';
                        optyWhereString += val;
                        optyWhereString += '%\' ';
                    }
                }
            }
        }   
        // Process grid filters
        if (gridFilters != null) {
            for (Integer i = 0; i < gridFilters.size(); i++) {
               String ffield = String.escapeSingleQuotes(gridFilters[i].get('field'));
               String fvalue = gridFilters[i].get('value'); 
                if(ffield.contains('OpportunityLineItems.')){
                        ffield = ffield.replace('OpportunityLineItems.', '');
                        if(ffield =='Tier_1_P_L__c'||ffield =='Tier_2_P_L__c'||ffield =='Tier_3_P_L__c'||ffield =='Tier_4_P_L__c'){
                            optyLineItemWhereString += ' AND ';
                            optyLineItemWhereString += ffield;
                            optyLineItemWhereString += ' IN ';
                            optyLineItemWhereString += fvalue;
                            //optyLineItemWhereString += '\' ';
                            system.debug( '@@SWAP ' + i);
                        }
                 }
                 else
                    optyWhereString += processGridFilter(gridFilters[i], forAggregate);
            }
        }
        if(optyLineItemWhereString.length() > 1){
            optyLineItemWhereString = optyLineItemWhereString.replaceFirst('AND', 'WHERE');
        }        
        // Process extra filters
        if (extraFilters != null) {
            for (Integer i = 0; i < extraFilters.size(); i++) {
                optyWhereString += processGridFilter(extraFilters[i], forAggregate);
            }
        }
        whereResponse.put('Opportunity', optyWhereString);
        whereResponse.put('OpportunityLineItems', optyLineItemWhereString);
        return whereResponse;
    }

    /*    processGridFilter    */
    static String processGridFilter( Map<String, String> filterParam, Boolean forAggregate){
        String returnString = '';
        String ftype = String.escapeSingleQuotes(filterParam.get('type'));
        String ffield = String.escapeSingleQuotes(filterParam.get('field'));
        String fvalue = filterParam.get('value');
        system.debug('@@@ftype'+ftype);
        system.debug('@@@ffield'+ffield);
        system.debug('@@@fvalue'+fvalue);
        if(ftype == 'boolean'){
            fvalue = String.escapeSingleQuotes(filterParam.get('value'));
            returnString += ' AND ';
            returnString += ffield + ' = ' + fvalue + ' ';
        }
        else if(ftype == 'string' && fvalue != ''){
            fvalue = String.escapeSingleQuotes(filterParam.get('value'));
            returnString += ' AND ';
            returnString += ffield + ' LIKE \'%' + fvalue + '%\' ';
        }
        else if(ftype == 'combo' && fvalue != ''){
            fvalue = String.escapeSingleQuotes(filterParam.get('value'));
            returnString += ' AND ';
            returnString += ffield + ' LIKE \'%' + fvalue + '%\' ';
        }
        else if(ftype == 'list' && fvalue != '' && fvalue != '()'){
            if(!forAggregate || ffield != 'Forecast_Category__c' || ffield != 'Manager_Forecast_Category__c' || ffield != 'Manager_Flag__c' ){
                returnString += ' AND ';
                returnString += ffield + ' IN ' + fvalue + ' ';
            }
        }
        else if(ftype == 'numeric'){
            if(ffield == 'Expiring_Contract_Amount__c'){
               ffield = 'Amount';
            }
            fvalue = String.escapeSingleQuotes(filterParam.get('value'));
            String comp = String.escapeSingleQuotes(filterParam.get('comparison'));
            returnString += ' AND ';
            if(comp == 'gt'){
                returnString += ffield + ' >= ' + fvalue + ' ';
            }
            else if(comp == 'lt'){
                returnString += ffield + ' <= ' + fvalue + ' ';
            }
            else if(comp == 'eq'){
                returnString += ffield + ' = ' + fvalue + ' ';
            }
        }
        else if(ftype == 'date'){
            fvalue = String.escapeSingleQuotes(filterParam.get('value'));
            String comp = String.escapeSingleQuotes(filterParam.get('comparison'));
            Date searchDate = null;
            Datetime dt = null;
            String dateString = null;
            try{
                searchDate = Date.parse(fvalue);
                dt = Datetime.parse(fvalue + ' 12:00 AM');
                dateString = dt.format('yyyy-MM-dd');
            }catch(Exception e){} 
            if(searchDate != null && dt != null && dateString != null){
                returnString += ' AND ';
                if(comp == 'gt'){
                    returnString += ffield + ' >= ' + dateString + ' ';
                }else if(comp == 'lt'){
                    returnString += ffield + ' <= ' + dateString + ' ';
                }else if(comp == 'eq'){
                    returnString += ffield + ' = ' + dateString + ' ';
                }
            }
        }
        return returnString;
    }

    /*    parseFilterResponse    */
    static List<Map<String, String> > parseFilterResponse(String input) {        
        JSONParser parser = JSON.createParser(input);
        System.debug('**TJ** Entered Parser');
        List<Map<String, String>> rtrn = new List<Map<String, String>>();       
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                Map<String, String> tmap = new Map<String, String>();
                while (parser.nextToken() != null) {
                    if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
                        String field = parser.getText();
                        parser.nextToken();
                        String value = '';
                        if(parser.getCurrentToken() == JSONToken.START_ARRAY){
                            System.debug('**TJ** Entered list processer');
                            while (parser.nextToken() != null) {
                                System.debug('**TJ** LIST PROCESSOR LOOP!');
                                if (parser.getCurrentToken() == JSONToken.VALUE_FALSE ||
                                    parser.getCurrentToken() == JSONToken.VALUE_NULL ||
                                    parser.getCurrentToken() == JSONToken.VALUE_NUMBER_FLOAT ||
                                    parser.getCurrentToken() == JSONToken.VALUE_NUMBER_INT ||
                                    parser.getCurrentToken() == JSONToken.VALUE_STRING ||
                                    parser.getCurrentToken() == JSONToken.VALUE_TRUE
                                    ) {
                                    if(value != ''){
                                        value += ', ';
                                    }
                                    if(parser.getText() == 'null'){
                                        System.debug('**TJ** LIST PROCESSOR FOUND NULL');
                                        value += '\'\'';
                                    }else{
                                        System.debug('**TJ** LIST PROCESSOR FOUND VALUE');
                                        value += '\''+String.escapeSingleQuotes(parser.getText())+'\'';
                                    }
                                    
                                }else if(parser.getCurrentToken() == JSONToken.END_ARRAY){
                                    break;
                                }
                            }
                            value = '('+value+')';
                        }else{
                            value = parser.getText();
                        }
                        tmap.put(field, value);                       
                    }
                    else{
                       rtrn.add(tmap);
                       break;
                    }
                }
                rtrn.add(tmap);
            }
        }
        return rtrn;
    }   

}