public class OpportunitySearchPageController {

    public String convertCurrencyWithApexCode { get; set; }
    
    public Boolean dosearch {get; set;}
    public Opportunity  opppro {get;set;}
    public String queryString {get;set;}
    public String FromDate {get;set;}
    public String ToDate {get;set;}
    public OpportunityLineItem opplineitem {get;set;}
    public Account acc {get;set;}
   // public Default_Opportunity_Product__c DefOpp {get;set;}
    //public Map <String,Default_Opportunity_Product__c> DefoppMap{get;set;}
    public Product2 opppr {get;set;}
    public Map <String,Country_List__c> CountryListMap{get;set;}
    public List<cOpportunity>  opportunityList{get;set;} 
    public String countryName {get; set;}
    Public Set<Id> listAccId=new Set<Id>();
    public String zone{ get; set; }
    public String dateSearch{ get; set; }
    public String dateFieldSearch{ get; set; }
    public Boolean checkCurrentOwner{ get; set; }
    public Map <String,Region_List__c> RegionListMap{get;set;}
    public Map <String,Zone_List__c> ZoneListMap{get;set;}
    public Map <String,Product_Portfolio__c> PortfolioListMap{get;set;}
    public Map <String,Modality__c> ModalityListMap{get;set;}
    public Map <String,Order_Status__c> orderStatusListMap{get;set;}
    public String regionName {get; set;}
    public String zoneName {get; set;}
    public String portfolioName {get; set;}
    public String orderStatus {get; set;}
    public String modalityName {get; set;}
    public String countryString{get; set;}
    public String modalityString {get; set;}
    public String regionString {get; set;}
    public String zoneString {get; set;}
    public String portfolioString {get; set;}
    public String innerWhereClause ='';
    public String countTest {get; set;}
    public String pageSize {get; set;}
    public ApexPages.StandardSetController con{get; set;}
   /* Getter for the Region value */
    public String getRegion() { return this.regionString; }

    /* Setter for the Region value */
    public void setRegion(String s) { this.regionString = s; }

    /* Getter for the Zone value */
    public String getZone() { return this.zoneString; }
 
    /* Setter for the Zone value */
    public void setZone(String s) { this.zoneString = s; }


    // CONSTRUCTOR
    public OpportunitySearchPageController() {
        // opppro = new Opportunity();
        CountryListMap = Country_List__c.getAll();
        RegionListMap = Region_List__c.getAll();
        ZoneListMap = Zone_List__c.getAll();
        PortfolioListMap = Product_Portfolio__c.getAll();
        orderStatusListMap = Order_Status__c.getAll();
        //DefoppMap = Default_Opportunity_Product__c.getAll();
        ModalityListMap = Modality__c.getAll();    

        if(con == null){ 
            con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id, Name, AccountId, Product_Portfolio__c, Account.Zone__c, Account.Region__c, Account.Country_Name_2__c, Order_Status__c, Order_at_Risk__c, CloseDate, Owner.Name, (select Modality__c, Product_Name__c, TotalPrice, Quantity, CurrencyIsoCode__c  from OpportunityLineItems)  from Opportunity Where Pricebook2Id != null AND HasOpportunityLineItem = true Order by Name limit 50]));
            // con = new ApexPages.StandardSetController(Database.getQueryLocator([select Id, Name, AccountId, Product_Portfolio__c, Account.Zone__c,Account.Region__c, Account.Country_Name_2__c, Order_Status__c, Order_at_Risk__c, CloseDate, Owner.Name, (select Modality__c, Product_Name__c, TotalPrice, Quantity, CurrencyIsoCode from OpportunityLineItems)  from Opportunity Where Pricebook2Id != null AND HasOpportunityLineItem = true Order by Name limit 50]));
            con.setPageSize(25);
        }    
    }
    
    
    /*
    @author Original: Robin Singh(502207646) TCS/GEHC     
    @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    @description Display picklist "Range" on VF Page.
    */
    public List<selectOption> getDateFilter() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); 
        options.add(new selectOption('THIS_YEAR', 'Current FY')); 
        options.add(new selectOption('NEXT_YEAR', 'Next FY'));
        options.add(new selectOption('LAST_YEAR', 'Previous FY'));
        options.add(new selectOption('THIS_QUARTER', 'Current  Quarter')); 
        options.add(new selectOption('NEXT_QUARTER', 'Next Quarter'));
        options.add(new selectOption('LAST_QUARTER', 'Previous Quarter'));
        return options;
    }    
    
    
    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC     
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Display picklist "Selected Date" on VF Page.
    */
    public List<selectOption> getDateField() {
        List<selectOption> options = new List<selectOption>(); //new list for holding all of the picklist options
        options.add(new selectOption('', '- None -')); 
        options.add(new selectOption('CloseDate', 'Estimated order date')); 
        options.add(new selectOption('Estimated_Sales_Date__c', 'Estimated Sales Date'));
        options.add(new selectOption('Tender_Result_Date__c', 'Tender Result Date')); 
        options.add(new selectOption('Tender_Due_Date__c', 'Tender Due Date'));
        options.add(new selectOption('Tender_Announcement_Date__c', 'Tender Announcement Date'));
        return options;
    }    
    
    
    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of Countries that the user can select to
    */
    public List<SelectOption> getCountriesSelectList() {
        list <SelectOption> options = new List<SelectOption>();

        //Sort all Countries by Country Long Name
        list <String> countryNames = new list<String>();
        for(Country_List__c c: CountryListMap.values()) {
            countryNames.add(c.Country_Long_Name__c);
        }
        countryNames.sort();
        
        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        for (String countryName : countryNames) {
            options.add(new SelectOption(countryName, countryName));
        }
        return options;
    }  
    
    
    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of Order Status that the user can select to.
    */
    public List<SelectOption> getorderStatustList() {
        list <SelectOption> options = new List<SelectOption>();

        //Sort all Countries by Country Long Name
        list <String> orderNames = new list<String>();
        for(Order_Status__c c: orderStatusListMap.values()) {
            orderNames.add(c.Name);
        }
        orderNames.sort();

        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        for (String orderName : orderNames ) {
            options.add(new SelectOption(orderName , orderName));
        }
        return options;
    }
      
      
    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of products that the user can select to
    */
    public List<SelectOption> getPortfolioSelectList() {
        list <SelectOption> options = new List<SelectOption>();
        //Sort all Countries by Country Long Name
        list <String> portfolioNames = new list<String>();
        for(Product_Portfolio__c p: portfolioListMap.values()) {
            portfolioNames.add(p.Portfolio_Name__c);
        }
        portfolioNames.sort();

        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        for(String PortfolioName : portfolioNames) {
            options.add(new SelectOption(PortfolioName, PortfolioName));
        }
        return options;
    }

    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of Modality that the user can select to
    */
    public List<SelectOption> getModalitySelectList() {
        list <SelectOption> options = new List<SelectOption>();
        //Sort all Countries by Country Long Name
        list <String> ModalityNames = new list<String>();
        for(Modality__c m: ModalityListMap.values()) {
            ModalityNames.add(m.Modality_Name__c);
        }
        ModalityNames.sort();

        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        for(String ModalityName : ModalityNames) {
            options.add(new SelectOption(ModalityName, ModalityName));
        }
        return options;
    }
    
    
    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of Region that the user can select to
    */
    public List<SelectOption> getRegionSelectList() {
        list <SelectOption> options = new List<SelectOption>();
        //Sort all Countries by Country Long Name
        list <String> RegionNames = new list<String>();
        for(Region_List__c c: [select Region_name__c from Region_List__c order by Name]) {
            RegionNames.add(c.Region_name__c);
        }
        RegionNames.sort();

        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        for (String RegionName : RegionNames) {
            options.add(new SelectOption(RegionName, RegionName));
        }
        return options;
    }    
    

    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Getter method for having the list of Zone that the user can select to
    */
    public List<SelectOption> getZoneSelectList() {
        list <SelectOption> options = new List<SelectOption>();
        //Sort all Countries by Country Long Name
        list <String> ZoneNames = new list<String>();
        for(Zone_List__c c: [select Zone_Name__c from Zone_List__c c where c.Region_Code__c = :regionString]) { 
            ZoneNames.add(c.Zone_Name__c);
        }
        ZoneNames.sort();

        //Create the Select Options
        options.add(new SelectOption('','---Select---'));
        if(regionString != NULL) {
            for(String ZoneName : ZoneNames) {
                options.add(new SelectOption(ZoneName, ZoneName));
            }   
        }
        return options;
    }


    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Search method
    */
    public void dosearch(){
        queryString = createQuery();
        //System.assertequals(queryString, null);

        con = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        if(ModalityString != null || PortfolioString != null){
            pageSize =  String.ValueOf(opportunityList.size()); 
        }
        else {
            pageSize = String.ValueOf(con.getResultSize());
        }
        
        if(ModalityString != null){
            con.setPageSize(50);
        }
        else {
            con.setPageSize(10);
        }
    } 


    /**
    * @author Original: Robin Singh(502207646) TCS/GEHC 
    * @date Original: 11 Apr 2013  Last Modified: 04 July 2013
    * @description Search based on input by user.
    */ 
    public String createQuery() {   
       //system.assertEquals(true, false);
        system.debug('###inside createquery ');
        string query = '';
        string innerQuery ='';
        innerWhereClause = '';
        String whereClause = '';

        //add ownerId filter to query
        if(checkCurrentOwner == True){
            if(whereClause != '' && whereClause!=null){
                whereClause +=' AND';
                whereClause += ' OwnerId  = \''+UserInfo.getUserId()+'\'';
            }
            else{
                whereClause += ' OwnerId =\''+ UserInfo.getUserId()+'\'';
            }
        }    

        //add Country names filter to query
        if( countryString != null && countryString != '' ){
            if(whereClause != '' && whereClause!=null){
                whereClause +=' AND ';
                whereClause += ' Account.Country_Name_2__c = \''+countryString+'\'';
            }
            else{
                whereClause += ' Account.Country_Name_2__c = \''+countryString+'\'';
            }
        }
        
        //add Zone names filter to query
         if( ZoneString!= null && ZoneString != ''){
            if(whereClause != '' && whereClause!=null){
                whereClause +=' AND ';
                whereClause += ' Account.Zone__c = \''+ZoneString+'\'';
            }
            else{
                whereClause += ' Account.Zone__c = \''+ZoneString+'\'';
            }
        }
        
        //add Region names filter to query
        if( RegionString!= null && RegionString != ''){ 
             if(whereClause != '' && whereClause!= null){
                whereClause +=' AND ';
                whereClause += ' Account.Region__c = \''+RegionString+'\'';
            }
            else{
                whereClause += ' Account.Region__c = \''+RegionString+'\'';
            } 
        }
        
        //add order status filter to query
        if(orderStatus != null && orderStatus != ''){ 
             if(whereClause != '' && whereClause!= null){
                whereClause +=' AND ';
                whereClause += ' Order_Status__c = \''+ orderStatus  +'\'';
            }
            else{
                whereClause += ' Order_Status__c =\''+ orderStatus  + '\'';
            } 
        }        

        if( fromDate!= null && fromDate != ''){
                Date dT  =  Date.parse(fromDate);
               String fromDateOnly = String.valueOf(date.newinstance(dT.year(), dT.month(), dT.day()));
            if(whereClause!= '' && whereClause!= null){
                whereClause +=' AND ';
                whereClause += ' closeDate >= '+ fromDateOnly ;
            }
            else{
                whereClause += ' closeDate >= '+ fromDateOnly ;
            }
        }
        
        if( toDate!= null && fromDate != ''){
        Date sdT  =  Date.parse(ToDate);
            String toDateOnly = String.valueOf(date.newinstance(sdT.year(), sdT.month(), sdT.day())); 
             if(whereClause != '' && whereClause!= null){
                whereClause +=' AND ';
                whereClause += ' closedate <= '+toDateOnly;
            }
            else{
                whereClause += ' closedate <= '+toDateOnly;
            }           
        }      
        
        if(dateSearch != null && dateFieldSearch != null){ 
           if(whereClause != '' && whereClause!= null){
                whereClause +=' AND ';
                whereClause +=  dateFieldSearch +' = ' + dateSearch +' ';
            }
            else{
                whereClause +=  dateFieldSearch +' = ' + dateSearch +' ';
            }
        }

        //add modality filter to query
        if( ModalityString!= null && ModalityString != ''){       
             if(innerWhereClause != '' && innerWhereClause!=null){
                innerWhereClause +=' AND ';
                innerWhereClause += ' OpportunityLineItem.Modality__c = \''+ModalityString+'\'';
            }
            else{ 
                innerWhereClause += ' OpportunityLineItem.Modality__c = \''+ModalityString+'\'';
            } 
        }
        
        //add products names filter to query
        if( PortfolioString!= null && PortfolioString != ''){
            if(whereClause != '' && whereClause!=null){
                whereClause +=' AND ';
               whereClause += 'Product_Portfolio__c = \''+PortfolioString+'\'';
            }
            else{
                whereClause += 'Product_Portfolio__c = \''+PortfolioString+'\'';
            } 
        }
        
        
    //    innerQuery = 'select Modality__c, PricebookEntry.Name, Product_Name__c, Quantity, TotalPrice, CurrencyIsoCode from OpportunityLineItems';
        innerQuery = 'select Modality__c, PricebookEntry.Name, Product_Name__c, Quantity, TotalPrice  from OpportunityLineItems';
            
        if(innerWhereClause != '' && innerWhereClause!= null){
            innerQuery += ' WHERE ' + innerWhereClause + ' limit 10000';
            system.debug(innerQuery);
        }
        
      //  query = 'select Id, Name, From__c, To__c, AccountId, Account.Region__c, Account.Zone__c, Account.Country_Name_2__c, Order_Status__c, Order_at_Risk__c, CloseDate, Owner.Name, Product_Portfolio__c,('+innerQuery+') from Opportunity';
        query = 'select Id, Name, AccountId, Account.Region__c, Account.Zone__c, Account.Country_Name_2__c, Order_Status__c, Order_at_Risk__c, CloseDate, Owner.Name, Product_Portfolio__c,('+innerQuery+') from Opportunity';

        if(innerWhereClause != '' && innerWhereClause!= null){
            if( whereClause != '' && whereClause!= null ){
                query += ' Where ' + whereClause + 'AND Pricebook2Id != null AND HasOpportunityLineItem = true Order by Name limit 10000';
            }
            else{
                query+= ' Where Pricebook2Id != null AND HasOpportunityLineItem = true Order by Name limit 10000';
            }
        }
        else if( whereClause != '' && whereClause != null){
            query += ' Where ' + whereClause + ' Order by Name limit 10000';        
        }
        else if( whereClause == '' || whereClause == null){
            query += ' limit 10000';        
        }
        //System.assertequals(query, null);        
    
    return query;    
    }              
    
    
    public Double getconvertCurrencyWithApexCode(String oCurrency, String nCurrency){
        /*  list<CurrencyType> c = [SELECT ISOCode, ConversionRate FROM CurrencyType WHERE IsActive=TRUE];
        for(integer i = 0; i< c.size(); i++){
            if(opppro.CurrencyISOCode == c[i].ISOCode){
                opplineitem.TotalPrice = opplineitem.TotalPrice / c[i].ConversionRate;
            }
        }
        return opplineitem.TotalPrice;
        }    */

        Set<String> isoCodes = new Set<String>();
        Map<String,Double> conversion_rates = new Map<String,Double>();

        //isoCodes.add(oCurrency);
        isoCodes.add(nCurrency);

        /*  for(CurrencyType curr: [SELECT IsoCode,ConversionRate FROM CurrencyType WHERE IsoCode in: isoCodes]){          
            conversion_rates.put(curr.IsoCode,curr.ConversionRate);        
        }   

        //Convert incoming Opportuntiy Amount into USD...
        Double conversionRate = conversion_rates.get(oCurrency);
        opplineitem.TotalPrice = opplineitem.TotalPrice /conversionRate;    */

        //convert amount as per new currency. 
        if(nCurrency != 'USD'){
            Double conversionRate = conversion_rates.get(nCurrency);
            opplineitem.TotalPrice = opplineitem.TotalPrice * conversionRate;
        }

    return opplineitem.TotalPrice;
    }
    

    public List<cOpportunity> getOpportunities(){
        List<OpportunityLineItem> oppLineLst;
        opportunityList = new List<cOpportunity>();

        oppLineLst = new List<OpportunityLineItem>();
      //  oppLineLst = [Select convertCurrency(TotalPrice),id,CurrencyIsoCode From OpportunityLineItem LIMIT 50];
        for(Opportunity o : (List<Opportunity>)con.getRecords()) {
            if(ModalityString != null || PortfolioString != null){
                if(o.OpportunityLineItems.size() > 0){
                    opportunityList.add(new cOpportunity(o));
                }
            }
            else{
                opportunityList.add(new cOpportunity(o));
            }
        }

    return opportunityList;
    }
  

    // WRAPPER Class
    public Class cOpportunity{
        public Product2 opppr1 {get;set;}
        public Opportunity opp {get;set;}
        public Account acc1 {get;set;}
        public Boolean selected{get;set;}
        public String convertPrice {get;set;}
        //public Integer convertPrice {get;set;}
        List<OpportunityLineItem> oppLineLst;
        
        cOpportunity(Opportunity o){
            convertPrice = ''; 
            opp=o;
            selected=false;
            //oppLineLst = new   List<OpportunityLineItem>();
            //oppLineLst = [Select convertCurrency(TotalPrice),id,CurrencyIsoCode From OpportunityLineItem where OpportunityId =: o.Id];
           
            for(OpportunityLineItem ol :o.OpportunityLineItems){
               // Double conversionRate = [SELECT conversionrate,IsoCode FROM currencytype WHERE isocode =:ol.CurrencyIsoCode LIMIT 50].conversionRate;
                Double conversionRate = [SELECT ConversionRate__c, IsoCode__c FROM CurrencyType__c WHERE IsoCode__c =:ol.CurrencyIsoCode__c LIMIT 50].ConversionRate__c;
                
                //  if(!convertPrice.contains(String.ValueOf(ol.TotalPrice * conversionRate)))
                if(ol.CurrencyIsoCode__c != 'USD'){
                    convertPrice +=   '\r\n'+ (ol.TotalPrice * (1/conversionRate)).setscale(2)+'\r\n';
                    //convertPrice = String.ValueOf((ol.TotalPrice * (1/conversionRate)).setscale(2));
                }
                else{
                    convertPrice +=   '\r\n'+ (ol.TotalPrice).setscale(2) +'\r\n';
                    //convertPrice = String.ValueOf((ol.TotalPrice).setscale(2));
                }
            }
        }
    } 


    public Boolean hasNext {
        get {
            return con.getHasNext();
        }
        set;
    }
    
    public Boolean hasPrevious{
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    public Integer pageNumber {
        get {
            return con.getPageNumber();
        }
        set;
    }
    
    public void first() {
        con.first();
    }
    
    public void  last() {
        con.last();
    }
    
    public void previous() {
        con.previous();
    }
    
    public void next(){ 
        con.next();
    }

}