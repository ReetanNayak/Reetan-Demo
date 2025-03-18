/**
* @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: Preetham Nagaraj (502277090) TCS/GEHC
* @date Original: 04 Sep 2013 Last Modified: 
* @description Class that will handle IB Asset Search 
*/
Public with Sharing Class IBAssetSearchController {
    //Placeholder on Search page for fields related to IB Product on IB Asset
    public string manufacturer {get;set;}    
    public string tierOne {get;set;}
    public string tierTwo {get;set;}
    public string tierThree {get;set;}

    //Placeholder on Search page for fields related to IB Product Country Attributes on IB Asset
    public string prodSeg{get;set;}    
    public string globalRegions{get;set;}
    public string countries{get;set;}
    public string subRegions{get;set;}
    
    //holds possible values of phase field on IB Asset. This field is a formula field on Object. Hence displaying as custom picklist
    public string phases {get;set;} 
    public string fromAge {get;set;}
    public string toAge  {get;set;}

    public string prodType {get; set;}
    
    //single instance that will hold all search fields
    public IB_Asset__c objAsset{get;set;}
    public IB_Asset__c objAsset2{get;set;}

    public IB_Product__c IBProd {get;set;}    
    
    //single instance that will hold all search fields
    public IB_Products_Subregions_Mapping__c objProdCountry{get;set;}
    
    //list of IB Assets returned on Search
    public List<IB_Asset__c> lstAsset {  
        get {  
            if(con != null)  
                return (List<IB_Asset__c>)con.getRecords();  
            else  
                return null ;  
        }  
        set;
    }  
    
    //Placeholder on Search page for Related Account of IB Asset
    public Account relatedAccount{get;set;}
    
    //variable that will make the Asset list panel visible on VF Page
    Public Boolean showIBAssets {get;set;}
    
    //declare the StandardSetController for Pagination
    public ApexPages.StandardSetController con{get; set;}  
    
        

    //    CONSTRUCTOR
    public IBAssetSearchController(ApexPages.StandardController controller) {
        objAsset = new IB_Asset__c();
        objAsset2 = new IB_Asset__c();
        objProdCountry = new IB_Products_Subregions_Mapping__c();
        lstAsset = new List<IB_Asset__c>();
        relatedAccount = new Account();
        IBProd = new IB_Product__c();
        showIBAssets = False;        
    }
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Manufacturer Type from IB Product
    */
    public List<SelectOption> getManufacturerType() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Product__c.Manufacturer_Type__c.getDescribe();
        List<Schema.PicklistEntry> mftTypes = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_None, Label.IB_Asset_Picklist_Value_None));
        
        for(Schema.PicklistEntry mftType : mftTypes) {
            options.add(new SelectOption(mftType.getLabel(), mftType.getValue()));
        }       
        return options;
    }    
    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get the Tier1 field from IB Product
    */
    public List<SelectOption> getTier1() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Product__c.Tier_1_P_L__c.getDescribe();
        List<Schema.PicklistEntry> tierOne = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry tr1 : TierOne) {
            options.add(new SelectOption(tr1.getLabel(), tr1.getValue()));
        }       
        return options;
    }    

    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will pickList values of field Tier2 from IB Product
    */
    public List<SelectOption> getTier2() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Product__c.Tier_2_P_L__c.getDescribe();
        List<Schema.PicklistEntry> tierTwo = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry tr2 : TierTwo) {
            options.add(new SelectOption(tr2.getLabel(), tr2.getValue()));
        }       
        return options;
    }  
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Tier3 from IB Product
    */
    public List<SelectOption> getTier3() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Product__c.Tier_3_P_L__c.getDescribe();
        List<Schema.PicklistEntry> tierThree = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry tr3 : TierThree) {
            options.add(new SelectOption(tr3.getLabel(), tr3.getValue()));
        }       
        return options;
    } 
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Product Segment from IB Product Country Attributes
    */
    public List<SelectOption> getProductSegment() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Products_Subregions_Mapping__c.Product_Segment__c.getDescribe();
        List<Schema.PicklistEntry> prodSeg = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry h : prodseg) {
            options.add(new SelectOption(h.getLabel(), h.getValue()));
        }       
        return options;
    }
    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Countries from IB Product Country Attributes
    */
    public List<SelectOption> getCountry() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Products_Subregions_Mapping__c.Country__c.getDescribe();
        List<Schema.PicklistEntry> countries = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        for(Schema.PicklistEntry country : Countries) {
            options.add(new SelectOption(country.getLabel(), country.getValue()));
        }       
        return options;
    } 
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Sub Region from IB Product Country Attributes
    */
    public List<SelectOption> getSubRegion() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Products_Subregions_Mapping__c.Sub_Region__c.getDescribe();
        List<Schema.PicklistEntry> subRegions = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry subRegion : SubRegions) {
            options.add(new SelectOption(subRegion.getLabel(), subRegion.getValue()));
        }       
        return options;
    } 
   
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Global Region from IB Product Country Attributes
    */
    public List<SelectOption> getGlobalRegion() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Products_Subregions_Mapping__c.Global_Region__c.getDescribe();
        List<Schema.PicklistEntry> globalRegions = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry globalRegion : GlobalRegions) {
            options.add(new SelectOption(globalRegion.getLabel(), globalRegion.getValue()));
        }       
        return options;
    }
        
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get Select options for Phase Field on IB Asset
    */
    public List<SelectOption> getPhase() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));     
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_Phase_1, Label.IB_Asset_Picklist_Value_Phase_1));
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_Phase_2, Label.IB_Asset_Picklist_Value_Phase_2));
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_Phase_3, Label.IB_Asset_Picklist_Value_Phase_3));
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_Phase_99, Label.IB_Asset_Picklist_Value_Phase_99 ));
        return options;    
    }
    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method will get pickList values of field Product Type from IB Product
    */
    public List<SelectOption> getProductType() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = IB_Product__c.Product_Type__c.getDescribe();
        List<Schema.PicklistEntry> prodType = fieldResult.getPicklistValues();
        options.add(new SelectOption(Label.IB_Asset_Picklist_Value_All, Label.IB_Asset_Picklist_Value_All));
        
        for(Schema.PicklistEntry pType : prodType) {
            options.add(new SelectOption(pType.getLabel(), pType.getValue()));
        }       
        return options;
    }    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will reset all filters
    */
    public void doReset() {
        objAsset = new IB_Asset__c();
        objAsset2 = new IB_Asset__c();
        objProdCountry = new IB_Products_Subregions_Mapping__c();
        lstAsset = new List<IB_Asset__c>();
        relatedAccount.ParentId = null;  
        tierOne = Label.IB_Asset_Picklist_Value_All;
        tierTwo = Label.IB_Asset_Picklist_Value_All;
        tierThree = Label.IB_Asset_Picklist_Value_All;
        manufacturer = Label.IB_Asset_Picklist_Value_None;
        prodSeg = Label.IB_Asset_Picklist_Value_All;
        globalRegions = Label.IB_Asset_Picklist_Value_All;
        countries = Label.IB_Asset_Picklist_Value_All;
        subRegions = Label.IB_Asset_Picklist_Value_All;
        phases = Label.IB_Asset_Picklist_Value_All;
        prodType = Label.IB_Asset_Picklist_Value_All; // added as part of DE230
        fromAge = '';
        toAge = '';
        showIBAssets = False;
    }    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will do search on IB Assets based on filters provided by User on Search Page
    */
    public PageReference doSearch() {
        string queryString = '';
        queryString = createQuery();
        con = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
        con.setPageSize(10);
        showIBAssets = true;
        return null;
    }    
    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: method that will prepare the query for fetching IB Asset records based on filters provided on VF Page
    */
    public String createQuery() {
    
        String query = 'Select Id, Name, Account__c, Country__c, IB_Region__c, Sub_Region__c, Care_Area__c, Status__c, Source__c, Sitename__c, SiteID__c, Install_Date__c, Warranty_End_Date__c, Renewal_Date__c, GIB_De_Install_Date__c, Age_Years__c, Lifecycle_Duration__c, Phase__c, Tier_1_P_L__c, Tier_2_P_L__c, Tier_3_P_L__c, Tier_4__c, Tier_5__c, IB_Asset_Owner__c,Equipment_Sales_Owner__c , Service_Sales_Owner__c, EquipmentSalesOwner__c, ServiceSalesOwner__c, Account_Zone__c, Account_Region__c, City__c, Installation_Zip_Postal_Code__c, Installation_State_Province__c,  Commercial_Product_Name__c, IB_Products_Country_Attributes__r.IB_Product__r.Manufacturer_Type__c, IB_Products_Country_Attributes__r.IB_Product__r.Product_Segment__c FROM IB_Asset__c';    
    
        String whereClause = '';
        
        //add Phase filter to query
        if(phases !=Label.IB_Asset_Picklist_Value_All) {
            whereClause += ' Phase__c = \''+phases+'\''; 
        }     

        //add Tier 1 filter to query
        if(tierOne !=Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Tier_1_P_L__c =\''+tierOne+'\'';
        }
        
        //add Tier 2 filter to query
        if(TierTwo  !=Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Tier_2_P_L__c =\''+tierTwo +'\'';
        }
        
        //add Tier 3 filter to query
        if(tierThree !=Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += 'Tier_3_P_L__c =\''+tierThree+'\'';
        }
        
        //add Tier 4 filter to query  
        if(objProdCountry.Tier_4_P_L__c!=null && objProdCountry.Tier_4_P_L__c!= '') {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Tier_4__c  =\''+objProdCountry.Tier_4_P_L__c+'\''; 
        } 
        
        //add Tier 5 filter to query  
        if(objProdCountry.Tier_5_P_L__c!=null && objProdCountry.Tier_5_P_L__c!= '') {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Tier_5__c  =\''+objProdCountry.Tier_5_P_L__c+'\''; 
        } 

        //add Care Area filter to query
        if(objAsset.Care_Area__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Care_Area__c =\''+objAsset.Care_Area__c+'\'';
        }
        
        //add Manufacturer filter to query
        if(manufacturer !=null && manufacturer !=Label.IB_Asset_Picklist_Value_None) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' IB_Products_Country_Attributes__r.IB_Product__r.Manufacturer_Type__c =\''+manufacturer+'\'';
        }

        //add Product Segment filter to query
        if(prodSeg != Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' IB_Products_Country_Attributes__r.Product_Segment__c =\''+ prodSeg+'\'';
        }

        //add From Install Date filter to query
        if(objAsset.Install_Date__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Install_Date__c >='+String.ValueOf(objAsset.Install_Date__c);
        }
        
        //add To Install Date filter to query
        if(objAsset2.Install_Date__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Install_Date__c  <='+String.ValueOf(objAsset2.Install_Date__c);
        }
        
        //add From Renewal Date filter to query
        if(objAsset.Renewal_Date__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Renewal_Date__c >='+String.ValueOf(objAsset.Renewal_Date__c);
        }
        
        //add To Renewal Date filter to query
        if(objAsset2.Renewal_Date__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Renewal_Date__c  <='+String.ValueOf(objAsset2.Renewal_Date__c);
        }

        //add Account filter to query
        if(relatedAccount.ParentId !=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Account__c=\''+relatedAccount.ParentId+'\'';
        }

        //add Equipment Sales Owner filter to query
        if(objAsset.EquipmentSalesOwner__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' EquipmentSalesOwner__c  =\''+objAsset.EquipmentSalesOwner__c+'\'';
        }  
        
        //add Service Sales Owner filter to query
        if(objAsset.ServiceSalesOwner__c!=null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' ServiceSalesOwner__c  =\''+objAsset.ServiceSalesOwner__c+'\'';
        }
        
        //add From Age in Years filter to query
        if(objAsset.Age_Years__c!=null && objAsset.Age_Years__c > 0.00) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Age_Years__c >= '+objAsset.Age_Years__c;
        }
        
        //add To Age in Years filter to query
        if(objAsset2.Age_Years__c !=null && objAsset2.Age_Years__c> 0.00) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Age_Years__c <= '+objAsset2.Age_Years__c;
        } 

         //add From Age in Years filter to query
        if(fromAge!=null && fromAge !='') {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Age_Years__c >= '+fromAge;
        }
        
        //add To Age in Years filter to query
        if(toAge !=null && toAge !='') {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Age_Years__c <= '+toAge;
        }       
        
        //add Status filter to query
        if(objAsset.Status__c!=null && objAsset.Status__c!='') {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Status__c = \''+objAsset.Status__c+'\'';
        }  

        //add countries filter to query
        if(countries!= Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Country__c =\''+countries+'\'';
        }
        
        //add globalRegions filter to query
        if(globalRegions!= Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' IB_Region__c = \''+globalRegions+'\'';
        }
        
        //add subRegions filter to query
        if(subRegions!= Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Sub_Region__c =  \''+subRegions+'\'';
        }     
        
        //add Account Zone filter to query
        if(objAsset.Account_Zone__c != '' && objAsset.Account_Zone__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Account_Zone__c  =\''+objAsset.Account_Zone__c+'\'';
        }       
        
        //add Account Region filter to query
        if(objAsset.Account_Region__c != '' && objAsset.Account_Region__c != null ) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Account_Region__c  =\''+objAsset.Account_Region__c+'\'';
        }       
        
        //add Installation City filter to query
        if(objAsset.City__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' City__c  =\''+objAsset.City__c+'\'';
        }       
        
        //add Installation ZIP Code filter to query
        if(objAsset.Installation_Zip_Postal_Code__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Installation_Zip_Postal_Code__c  =\''+objAsset.Installation_Zip_Postal_Code__c+'\'';
        }       
        
        //add Installation State filter to query
        if(objAsset.Installation_State_Province__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Installation_State_Province__c  =\''+objAsset.Installation_State_Province__c+'\'';
        }       
        
        //add Commercial Product Name filter to query
        if(objAsset.Commercial_Product_Name__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' Commercial_Product_Name__c  =\''+objAsset.Commercial_Product_Name__c+'\'';
        }      
        
        //add IB Product Name filter to query
        if(IBProd.Name != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            //whereClause += ' IB_Products_Country_Attributes__r.IB_Product__r.Name  =\''+IBProd.Name+'\'';
            whereClause += ' IB_Products_Country_Attributes__r.IB_Product__r.Name  like \'%' +IBProd.Name+ '%\'';
        }       
        
        //add IB Competitor Name(Manufacturer) filter to query
        if(IBProd.Competitor__c != null) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += ' IB_Products_Country_Attributes__r.IB_Product__r.Competitor__c  =\''+IBProd.Competitor__c+'\'';
        }                  
    
        //add Product Type filter to query
        if(prodType != Label.IB_Asset_Picklist_Value_All) {
            if(whereClause != '')
                whereClause +=' AND ';
            whereClause += 'IB_Products_Country_Attributes__r.IB_Product__r.Product_Type__c =\''+prodType+'\'';
        }          

        if(whereClause != '')
            query += ' WHERE ' + whereClause + ' Order By Name limit 10000';
        else
            query += ' Order By Name limit 10000';         
    
    return query;
    }    
    
    
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: indicates whether there are more records after the current page set.
    */
    public Boolean hasNext {
        get{
            return con.getHasNext();
        }
        set;
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: indicates whether there are more records before the current page set.
    */
    public Boolean hasPrevious {
        get{
            return con.getHasPrevious(); 
        }
        set;
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will get return the page number of the current page set
    */
    public Integer pageNumber {
        get{
            return con.getPageNumber();
        }
        set;
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will return the first page of records
    */
    public void first() {
        con.first();
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will return the last page of records
    */
    public void last() {
        con.last();
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will get return the previous page of records
    */
    public void previous() {
        con.previous();
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will return the next page of records
    */
    public void next() {
        con.next();
    }
 
    /**
    * @author Original: Teja Thomas (502207648)TCS/GEHC Last Modified: 
    * @date Original: 04 Sep 2013 Last Modified: 
    * @description: Method that will returns the PageReference of the original page, if known, or the home page.
    */
    public void cancel() {
        con.cancel();
    }    
    
}