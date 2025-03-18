public with sharing class IBAssetSearchNewController {

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
    // which means we cannot cache  results in this controller but must respond to each request anew
    public class QueryObj {
        public List<Map<String, String> > filterParams;
        public List<Map<String, String> > filters;
        public Boolean myTeam;
        public Boolean showMyOpp;
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
    
/*    private static Map<String, Decimal> getCurrencyMap(){
        Map<String, Decimal> CurrencyTypeMap = new Map<String, Decimal>();
        for(CurrencyType ct : [SELECT Id, ISOCode, ConversionRate, IsActive FROM CurrencyType WHERE IsActive=TRUE Limit 1000]) {
            CurrencyTypeMap.put(ct.ISOCode,ct.ConversionRate);
        }  
        return CurrencyTypeMap;
    }    */

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
            qstr +=  ' ORDER BY Name DESC ';
            qstr += ' LIMIT 15';
        }else{
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
        System.debug('@@sqobj'+sqobj);
        
        String obj = String.escapeSingleQuotes(sqobj.obj);
        Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        
        System.debug('@@objTypeMap '+objTypeMap );
        Schema.SObjectType sobjToken = objTypeMap.get(obj);
        System.debug('@@sobjToken '+sobjToken );
        Map<String, Schema.SObjectField> fieldMap = sobjToken.getDescribe().fields.getMap();
        System.debug('@@fieldMap '+fieldMap );
        String field = String.escapeSingleQuotes(sqobj.field);
        system.debug('Check the ZONE.... ' + field);

        String search = String.escapeSingleQuotes(sqobj.searchStr);
        
        System.debug('@@search '+search );
        List<Map<String, String>> results = new List<Map<String, String>>();
        
        Map<String, String> firstItemresultMap = new Map<String, String>();
        firstItemresultMap.put('id',search);
        firstItemresultMap.put('text',search);
        results.add(firstItemresultMap);
                    

        System.debug('***TJ*** Type:'+fieldMap.get(field).getDescribe().getType());
        if (field != 'Id' && fieldMap.get(field).getDescribe().getType() == Schema.DisplayType.Picklist) {
            List<Schema.PicklistEntry> r = fieldMap.get(field).getDescribe().getPicklistValues();
            System.debug('***TJ*** Size:'+r.size());
            for(Integer i = 0;i<r.size();i++){
                String temp = r[i].getValue();
                if(temp != null && temp.containsIgnoreCase(search)){
                    System.debug('***TJ*** Match Value:'+temp);
                    Map<String, String> resultMap = new Map<String, String>();
                    resultMap.put('id',temp);
                    resultMap.put('text',temp);
                    results.add(resultMap);
                }
            }
        }
        
        else{
            List<SObject> tmpR;
            if(obj=='User') {
                tmpR  = Database.query('Select '+field+' From '+obj+' Where isActive=true limit 3000');
            }
            else {            
                tmpR = Database.query('Select '+field+' From '+obj+' limit 3000');
            }
            System.debug('***TJ*** '+tmpR.size());
            for(SObject so:tmpR){   
                String temp = String.valueOf(so.get(field));
                if(temp != null && temp.containsIgnoreCase(search)){
                    System.debug('***TJ*** Match Value:'+temp);
                    Map<String, String> resultMap = new Map<String, String>();
                    resultMap.put('id',temp);
                    resultMap.put('text',temp);
                    results.add(resultMap);
                    
                }
            }
        }
        //results.add(resultMap);

        ListResponse tmp = new ListResponse();
        tmp.records = results;
        //tmp.errorMessage = qstr;
        System.debug('@@tmp'+tmp);
        return tmp;
    }



    // turn grid's page load/sort request into SOQL and return data
    @RemoteAction
    public static CRUDResponse query(QueryObj qobj) {
    //    Map<String, Decimal> CurrencyTypeMap = getCurrencyMap();
        
        CRUDResponse resp = new CRUDResponse();

        //Object for query
        String obj = 'IB_Asset__c';
        String  qstr = '';
        String countstr ='';
        
        //Filter parameterrs from column headers
        List<Map<String, String>> columnFilterParams = null;
        if (qobj.filter != null) {
            //Parse grid column filters from JSON text into objects
            columnFilterParams = parseFilterResponse(qobj.filter);
        }

        //Filter parameters from grid store
        List<Map<String, String>> storeFilterParams = qobj.filterParams;
        System.debug('@@storeFilterParams '+storeFilterParams );
        
        List<Map<String, String>> extraFilterParams = qobj.filters;
        System.debug('@@extraFilterParams '+extraFilterParams );
        
        Map<String, String> whereString = generateWhere(storeFilterParams, columnFilterParams, extraFilterParams, qobj.showMyOpp, false);
        System.debug('@@Preetham whereString '+ whereString + whereString.get('IB_Asset__c') );
        
        //Field String for query
        //String fields = 'Id,Custom_Sort_2__c,StageName, Estimated_Sales_Date__c,Sales_Forecast_Category__c,Forecast_Category__c,Owner.Name,Name,Account.Id,Account.Name,Zone__c,China_Amount__c,Region__c,Account.Global_Region__c,CurrencyIsoCode,Amount,CloseDate,Order_at_Risk__c,Order_Status__c,Country_Name__c,Product_Portfolio__c,(Select Id, Modality__c,CurrencyIsoCode,Totalprice, Product_Name__c, Quantity  from OpportunityLineItems ) ';
        
        String fields = 'Id,  Name, Account__r.Name, Country__c, IB_Region__c, Sub_Region__c, Care_Area__c, Status__c, Source__c, Sitename__c, SiteID__c, Install_Date__c, Warranty_End_Date__c, Renewal_Date__c, GIB_De_Install_Date__c, Age_Years__c, Lifecycle_Duration__c, Phase__c, Tier_1_P_L__c, Tier_2_P_L__c, Tier_3_P_L__c, Tier_4__c, Tier_5__c, IB_Asset_Owner__c,Equipment_Sales_Owner__c , Service_Sales_Owner__c, EquipmentSalesOwner__r.Name, ServiceSalesOwner__r.Name, Account_Zone__c, Account_Region__c, City__c, Installation_Zip_Postal_Code__c, Installation_State_Province__c,  Commercial_Product_Name__c, IB_Products_Country_Attributes__r.IB_Product__r.Manufacturer_Type__c, IB_Products_Country_Attributes__r.Product_Segment__c, IB_Products_Country_Attributes__r.IB_Product__r.Product_Type__c ';
        
        // construct two queries: 1. Count query  2. Field query
        if(whereString.get('IB_Asset__c')=='' || whereString.get('IB_Asset__c')==null){
            countstr = 'SELECT COUNT() FROM ' + obj;
            qstr = 'SELECT ' + fields + ' FROM ' + obj;
        }
        else{
            countstr = 'SELECT COUNT() FROM ' + obj+ ' WHERE';
            qstr = 'SELECT ' + fields + ' FROM ' + obj+ ' WHERE';  
        }
        System.debug('@@countstr1'+countstr +'@@'+qstr ) ;  
            
        /* -----Code of not used ---------
        // Get user's role ID and parent role ID
        List <UserRole> usrrolelst = null;
        // Get users falling into those roles
        List <User> usrlst = null;
        if(qobj.myTeam){
            usrrolelst = [select id from UserRole where id=:userinfo.getUserRoleId() or ParentRoleId=:userinfo.getUserRoleId() Limit 1000];
            usrlst = [select id from user where UserRoleId in :usrrolelst Limit 1000];
            countstr += ' WHERE ownerid IN :usrlst AND  CloseDate!=null AND Forecast_Category__c!=null ';
            qstr += ' WHERE ownerid IN :usrlst AND  CloseDate!=null AND Forecast_Category__c!=null '; 
        }else{
            countstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null ';
            qstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null '; 
        }*/
       
        //countstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null ';
        //qstr += ' WHERE CloseDate!=null AND Forecast_Category__c!=null '; 
        
        System.debug('@@countstr2'+countstr +'@@'+qstr ) ;  
        
        if(whereString.get('IB_Asset__c')== '' || whereString.get('IB_Asset__c')==null) {
            countstr +='';
            qstr += '';
        }
        else { 
            system.debug('inside where');
            countstr += whereString.get('IB_Asset__c');
            qstr += whereString.get('IB_Asset__c');
        }
        if(countstr.contains('WHERE AND')){
            countstr = countstr.replaceFirst('WHERE AND', 'WHERE');
            qstr = qstr.replaceFirst('WHERE AND', 'WHERE');
        }
        
        System.debug('@@countstr 3'+countstr );
        
        resp.total = Database.countQuery(countstr);   // ExtJS grid needs the true total here

        System.debug('@@qstr '+qstr );
        
        if (qobj.sortParams != null) {
            qstr += ' ORDER BY ';
            // collect sort fields/directions
            qstr += qobj.sortParams[0].get('property');
            /* if(qobj.sortParams[0].get('property') != 'Amount'){
              qstr += ', Amount';
            }
            for (Integer i = 1; i < qobj.sortParams.size(); i++) {
                qstr += ',' + qobj.sortParams[i].get('property');
            }   */
            // SOQL only supports a single direction, so ignoring others. Probably should return error instead.
            qstr += ' ' + qobj.sortParams[0].get('direction') + ' NULLS LAST ';
        }
        else{
            qstr += ' ORDER BY Name DESC NULLS LAST ';
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
        } 
        else {
            startrec = Math.min(qobj.start, 2000);
            // record count to get is the sum of the mandatory unwanted records (those over 2000) and those we want
            Integer reclimit = (qobj.start - startrec) + qobj.recordCount;
            qstr += ' LIMIT ' + String.valueOf(reclimit);
            qstr += ' OFFSET ' + String.valueOf(startrec);
        }
        
        system.debug('Preetham qstr' + qstr);
        Integer current_result = startrec;        // initialize with the true offset
        try {
            for (List<SObject> rlit : Database.query(qstr)) {
             system.debug('++++++++++++ ' + rlit);
                for (SObject rit : rlit) {
                
                 system.debug('++++++++++++ ' + qstr);
                    if ((current_result >= qobj.start) && (current_result < (qobj.start + qobj.recordCount))) {
                      
                        resp.records.add(rit);
                    }
                    current_result++;
                }
            }
        } 
        catch (Exception e) {
            resp.success = false;
            resp.records = null;
            resp.errorMessage = e.getMessage() + '  QUERY:'+qstr;  //debugging - remove before prod
            return resp;
        }

        system.debug('Preetham Resp:' + resp );
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
        system.debug('1111' + recmap);                                     

        Set <String> KeySet = recmap.keySet();  
        system.debug('22222' + recmap);                                     

        if(KeySet.contains('StageName')|| KeySet.contains('Estimated_Sales_Date__c')|| KeySet.contains('Sales_Forecast_Category__c')
                || KeySet.contains('Forecast_Category__c') || KeySet.contains('CloseDate') || KeySet.contains('Name') ){
            Flag = True;
        }

        Map<String, Schema.SObjectType> objTypeMap = Schema.getGlobalDescribe();
        Schema.SObjectType sobjToken = objTypeMap.get('Opportunity');
        SObject sobj = sobjToken.newSObject(recmap.get('Id'));
        system.debug('33333' + sobj);    

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
            //update sobj;
            if(Flag == True){
                system.debug('44444 true' +recmap.get('Id')  );
                //OpportunityDML UpdateChildOpp = New OpportunityDML(); 
                //UpdateChildOpp.UpdateChildOpportunity(sobj);
                //UpdateChildOpp.UpdateChildOpportunity(recmap.get('Id'));
            }
        } 
        catch (Exception e) {
            resp.success = false;
            resp.errorMessage = 'update: failed with error ' + e.getMessage();
            return resp;
        }

        return resp;
        //return refreshObjects(crudData, sobj);
    } 
    
    
    static Map<String,String> generateWhere(List<Map<String, String> > storeFilters, List<Map<String, String> > gridFilters, List<Map<String, String> > extraFilters, Boolean showMyOpp, Boolean forAggregate) 
    {
        Map<String, String> whereResponse = new Map<String, String>();
        String IBWhereString = '';
          
        // Process store filters
        Date searchDate = null;
        Datetime dt = null;
        String dateString = null;
        
        if (storeFilters != null) {
            // collect sort fields/directions
            for (Integer i = 0; i < storeFilters.size(); i++) {
                String val = storeFilters[i].get('value');
                
                String field = storeFilters[i].get('property');
                if(val != null && val != '' && field != null) {
                    val = String.escapeSingleQuotes(val);
                    field = String.escapeSingleQuotes(field);
                    System.debug('@@val'+val+'@@'+field);
                    
                    if(field == 'Account.Name') {
                        IBWhereString += ' AND ';
                        IBWhereString += ' Account__r.Name';                        
                        IBWhereString += ' LIKE \'%' +val+ '%\' ';                                             
                    }
                    else if(field == 'fromage'){
                        IBWhereString += ' AND ';
                        IBWhereString += ' Age_Years__c >= ';
                        IBWhereString += ' '+val;
                    }
                    else if(field == 'toage') {
                        IBWhereString += ' AND ';
                        IBWhereString += ' Age_Years__c <= ';
                        IBWhereString += ' '+val; 
                    }
                    else if(field == 'fromInstallDate'){
                        IBWhereString += ' AND ';
                        IBWhereString += ' Install_Date__c >= ';
                        IBWhereString += ' '+val.substring(0, 10);                    
                    }
                    else if(field == 'toInstallDate'){
                        IBWhereString += ' AND ';
                        IBWhereString += ' Install_Date__c <= ';
                        IBWhereString += ' '+val.substring(0, 10);    
                    }
                    else if(field == 'fromRenewalDate'){
                        IBWhereString += ' AND ';
                        IBWhereString += ' Renewal_Date__c >= ';
                        IBWhereString += ' '+val.substring(0, 10);
                    }
                    else if(field == 'toRenewalDate'){
                        IBWhereString += ' AND ';
                        IBWhereString += ' Renewal_Date__c <= ';
                        IBWhereString += ' '+val.substring(0, 10);    
                    } 
                    else{
                        IBWhereString += ' AND ';
                        IBWhereString += field;
                        IBWhereString += ' LIKE \'%';
                        IBWhereString += val;
                        IBWhereString += '%\' ';
                    }
                }
            }
        }   
        
        System.debug('@@IBWhereString 1'+IBWhereString );
        
        // Process grid filters
        if (gridFilters != null) {
            for (Integer i = 0; i < gridFilters.size(); i++) {
                IBWhereString += processGridFilter(gridFilters[i], forAggregate);
            }
        }

        // Process extra filters
        if (extraFilters != null) {
            for (Integer i = 0; i < extraFilters.size(); i++) {
                IBWhereString += processGridFilter(extraFilters[i], forAggregate);
            }
        }
        whereResponse.put('IB_Asset__c', IBWhereString);
        
        return whereResponse;
    } 
    


    static String processGridFilter( Map<String, String> filterParam, Boolean forAggregate) {

        String returnString = '';

        String ftype = String.escapeSingleQuotes(filterParam.get('type'));
        String ffield = String.escapeSingleQuotes(filterParam.get('field'));
        String fvalue = filterParam.get('value');
        
        if(ftype == 'string' && fvalue != ''){
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
                returnString += ' AND ';
                returnString += ffield + ' IN ' + fvalue + ' ';
        }
        else if(ftype == 'numeric'){
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
            }
            catch(Exception e){} 
            if(searchDate != null && dt != null && dateString != null){
                returnString += ' AND ';
                if(comp == 'gt'){
                    returnString += ffield + ' >= ' + dateString + ' ';
                }
                else if(comp == 'lt'){
                    returnString += ffield + ' <= ' + dateString + ' ';
                }
                else if(comp == 'eq'){
                    returnString += ffield + ' = ' + dateString + ' ';
                }
            }
        }

        return returnString;
    }
    
    

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
                                    }
                                    else{
                                        System.debug('**TJ** LIST PROCESSOR FOUND VALUE');
                                        value += '\''+String.escapeSingleQuotes(parser.getText())+'\'';
                                    }
                                }
                                else if(parser.getCurrentToken() == JSONToken.END_ARRAY){
                                    break;
                                }
                            }
                            value = '('+value+')';
                        }
                        else{
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