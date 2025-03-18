/**
* @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
* @date Original: 12 Mar 2012 Last Modified: 02 Oct 2012 
* @description Class to handle display of Account, Contact, Opportunity and Activity records marked as favorite for the current user.  
*/
public class MyFavoritesController {

    //boolean variables to show/hide pagination sections
    public boolean showAccPagi {get;set;}
    public boolean showConPagi {get;set;}
    public boolean showOppPagi {get;set;}
    public boolean showLeadPagi {get;set;}

    //Lists used for storing Account,Contact and Opportunity, Lead favorites
    public list <Account>  faccList      {get; set;}
    public list <Contact>  fconList      {get; set;}
    public list <Opportunity> foppList      {get; set;}
    public list <Lead> fleadList      {get; set;}
    
    public list <Favorites__c>  favlist;
    public list <Favorites__c>  flist;
    public list <Favorites__c>  delfavlist;
    public list  <sobjwrapper>           sobjwrAccList; 
    public list  <sobjwrapper>           sobjwrConList; 
    public list  <sobjwrapper>           sobjwrOppList; 
    public list  <sobjwrapper>           sobjwrLeadList;
    
    //Store Account,Contact, Opportunity, Lead Ids
    set <string> accSet              {get; set;} 
    set <string> conSet              {get; set;} 
    set <string> oppSet              {get; set;} 
    set <string> leadSet              {get; set;}
    
    
    //Strings used for Dynamic Querying
    string accquery                {get; set;}
    string conquery                {get; set;}
    string oppquery                {get; set;}
    string leadquery                {get; set;}
    
    
    //Render variables
    public string accrend            {get; set;}
    public string conrend            {get; set;}
    public string opprend            {get; set;}
    public string leadrend            {get; set;}
    
    public string showdelete          {get; set;}
    public string showaccd            {get; set;}
    public string showcond            {get; set;}
    public string showoppd            {get; set;}
    public string showleadd            {get; set;}
    
    public string showmsg            {get; set;}
    public string favmsg            {get; set;}
    public string accsize            {get; set;}
    public string consize            {get; set;}
    public string oppsize            {get; set;}
    public string leadsize            {get; set;}
    
    
    //Pagination variables
    public string AccMaxPageNumber        {get; set;}
    public string ConMaxPageNumber        {get; set;}
    public string OppMaxPageNumber        {get; set;}
    public string LeadMaxPageNumber        {get; set;}
    
    public integer selectedpage          {get; set;}
    integer recordsPerPage               {get; set;}
    
    //Sort variables
    public string sortField;
    public string sortimg            {get; set;}
    public string sortObject          {get; set;}
    public string accsortField          {get; set;}
    public string consortField          {get; set;}
    public string oppsortField          {get; set;}
    public string leadsortField          {get; set;}
    
    string accpreviousSortField;
    string conpreviousSortField;    
    string opppreviousSortField;
    string leadpreviousSortField;
    
    public string accsortOrder;          
    public string consortOrder;          
    public string oppsortOrder;
    public string leadsortOrder;
    
    list <sobject> sortList            {get; set;}
    map <String,String> sortImgMap;
    ApexPages.StandardSetController sobjpg     {get;set;}
    
    //Used Map values for deleting favorites
    map <String,Favorites__c> FavMap;
    
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 28 Mar 2012 Last Modfied: 05 July 2012 
    * @description Class Constructor  
    */
    
    public MyFavoritesController(){
    
      showAccPagi = false;
      showConPagi = false;
      showOppPagi = false;
      showLeadPagi = false;   
    
      fList = new List<Favorites__c>();
      accSet = new Set <String>();
      conSet = new Set <String>(); 
      oppSet = new Set <String>();
      leadSet = new Set <String>();
      
      showdelete = showmsg = 'false';
      accrend = conrend = opprend = leadrend = 'false';
      
      showaccd = showcond = showoppd = showleadd = 'false';
      accsize = consize = oppsize = leadsize = '';
      accquery = conquery = oppquery = leadquery = '';
      selectedpage = 0;
      sortimg = ''; 
      favmsg = Label.MyFavorites_Info_Message_NoFavorites;
        recordsPerPage    = 5;
      faccList = new List <Account>();
      fconList = new List <Contact>();
      foppList = new List <Opportunity>();
      fleadList = new List <Lead>();
      
      FavMap = new Map <String,Favorites__c>();
      sortImgMap = new Map <String,String>();
      sobjwrAccList = new List <sobjwrapper>();
      sobjwrConList = new List <sobjwrapper>();
      sobjwrOppList = new List <sobjwrapper>();
      sobjwrLeadList = new List <sobjwrapper>();
      
      accsortField = consortField = oppsortField = leadsortField = 'Name';
      accpreviousSortField = conpreviousSortField = opppreviouSsortField = leadpreviouSsortField = null;
      accsortOrder = consortOrder = oppsortOrder = leadsortOrder = 'asc';
            
      //List of current User's favorites
            fList = [Select Account__c, Contact__c, Opportunity__c, Lead__c, Type__c,
                    Account__r.Name, Contact__r.Name, Opportunity__r.Name, Lead__r.Name
                 From   Favorites__c
                 Where  User__c = :UserInfo.getuserId()
                 Order  By Type__c, LastModifiedDate desc  
                ];
      
      if (fList.size() > 0){
        showdelete = 'true';
        for(Favorites__c f:fList){
                if(f.Type__c == 'Account'){
                  accSet.add(f.Account__c);
                  FavMap.put(f.Account__c,f);            
                }
                else if(f.Type__c == 'Contact'){
                  conSet.add(f.Contact__c);
                  FavMap.put(f.Contact__c,f);
                }
                else if(f.Type__c == 'Opportunity'){
                    oppSet.add(f.Opportunity__c);
                    FavMap.put(f.Opportunity__c,f);
                }
                else if(f.Type__c == 'Lead'){
                    leadSet.add(f.Lead__c);
                    FavMap.put(f.Lead__c,f);
                }               
              }
      }
      else { showmsg = 'true'; }
      
      if (accSet.size() > 0){
      
        //Get all fields from account object dynamically and add it to FieldSets
        List<Schema.FieldSetMember> accountFields = Schema.SObjectType.Account.fieldSets.myFavorites_ACC.getFields();
        system.debug('Check accountFields '+ accountFields);
        
        String theQuery = 'SELECT ';
        
        //Construct the field list for the select clause
        for(Schema.FieldSetMember s : accountFields){
             theQuery += s.getFieldPath() + ',';
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1); //trim last comma
        theQuery += ' FROM Account Where Id in : accSet '; //complete query
        system.debug('Check theQuery '+ theQuery);
        
        accQuery = theQuery;
        system.debug('Check accQuery '+ accQuery);
        
        faccList = Database.query(theQuery); //query Accounts
        system.debug('Check faccList '+ faccList);
        
        accrend = 'true';
        for (Account acc : faccList){
          sobjwrAccList.add(new sobjwrapper(acc,null,null,null));
        }
        accsize = String.valueof(sobjwrAccList.size());
        //if number of account records is greater than the defined pagination size, render the account pagination controls
        if(sobjwrAccList.size() > recordsPerPage)
          showAccPagi = true;
        
      }
      
      
      if (conSet.size() > 0){
        
        //Get all fields from contact object dynamically and add it to FieldSets
        List<Schema.FieldSetMember> contactFields = Schema.SObjectType.Contact.fieldSets.myFavorites_CON.getFields();
        String theQuery = 'SELECT Name, '; //construct query
        
        //Construct the field list for the select clause
        for(Schema.FieldSetMember s : contactFields){
             theQuery += s.getFieldPath() + ',';
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1); //trim last comma
        theQuery += ' FROM Contact Where Id in : conSet '; //complete query
        conQuery = theQuery;
        fconList = Database.query(theQuery); //query contacts
        
        conrend = 'true';
        for (Contact con : fconList){
          sobjwrConList.add(new sobjwrapper(null,con,null,null));
        }
        consize = String.valueof(sobjwrConList.size());
        //if number of contact records is greater than the defined pagination size, render the contact pagination controls
        if(sobjwrConList.size() > recordsPerPage)
          showConPagi = true;
      }
      
      
      if (oppSet.size() > 0){
        
        //Get all fields from opportunity object dynamically and add it to FieldSets
        List<Schema.FieldSetMember> opportunityFields = Schema.SObjectType.Opportunity.fieldSets.myFavorites_OPP.getFields();
        String theQuery = 'SELECT '; //construct query
        
        //Construct the field list for the select clause
        for(Schema.FieldSetMember s : opportunityFields){
             theQuery += s.getFieldPath() + ',';
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1); //trim last comma
        theQuery += ' FROM Opportunity Where Id in : oppSet '; //complete query
        oppQuery = theQuery;
        foppList = Database.query(theQuery); //query opportunity records
        
        opprend = 'true';
        for (Opportunity opp : foppList){
          sobjwrOppList.add(new sobjwrapper(null,null,opp,null));
        }
        oppsize = String.valueof(sobjwrOppList.size());
        //if number of opportunity records is greater than the defined pagination size, render the opportunity pagination controls
        if(sobjwrOppList.size() > recordsPerPage)
          showOppPagi = true;
      }
      

      if (leadSet.size() > 0){
        
        //Get all fields from Lead object dynamically and add it to FieldSets
        List<Schema.FieldSetMember> leadFields = Schema.SObjectType.Lead.fieldSets.myFavorites_LEAD.getFields();
        String theQuery = 'SELECT '; //construct query
        
        //Construct the field list for the select clause
        for(Schema.FieldSetMember s : leadFields){
             theQuery += s.getFieldPath() + ',';
        }
        
        theQuery = theQuery.subString(0, theQuery.length() - 1); //trim last comma
        theQuery += ' FROM Lead Where Id in : leadSet '; //complete query
        leadQuery = theQuery;
        fleadList = Database.query(theQuery); //query Lead records
        
        leadrend = 'true';
        for (Lead led : fleadList){
          sobjwrLeadList.add(new sobjwrapper(null,null,null,led));
        }
        leadsize = String.valueof(sobjwrLeadList.size());
        //if number of Lead records is greater than the defined pagination size, render the Lead pagination controls
        if(sobjwrLeadList.size() > recordsPerPage)
          showLeadPagi = true;
      }   
      
      
      acclast(); accfirst(); conlast(); confirst(); opplast(); oppfirst(); leadlast(); leadfirst(); 
      getAccPageSelect(); getConPageSelect(); getOppPageSelect(); getLeadPageSelect();
      
      if (facclist != null && facclist.size() != 0){
        sortObject = 'Account';
        dosort();
      }
      if (fconlist != null && fconlist.size() != 0){
        sortObject = 'Contact';
        dosort();
      }
      if (fopplist != null && fopplist.size() != 0){
        sortObject = 'Opportunity';
        dosort();
      }
      if (fleadlist != null && fleadlist.size() != 0){
        sortObject = 'Lead';
        dosort();
      }  
      
    }
    
    
    
    /** ---- ACCOUNT PAGINATION ---- **/
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Pagination for Accounts 
    */
    
    public ApexPages.StandardSetController accpg {
      get {
      if(accpg == null) {
        accpg = new ApexPages.StandardSetController(facclist);
        // sets the number of records in each page set
        accpg.setPageSize(recordsPerPage);
      }
      return accpg;
      }
      set;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Gets the current page number of the Account table
    */
    
    public Integer accpageNumber {
      get {
        return accpg.getPageNumber();
      }
      set;
    }
   
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the first page of the Account table.
    */
    
     public void accfirst() {
       accpg.first();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the last page of the Account table.
    */
     
     public void acclast() {
       accpg.last();
       AccmaxPageNumber = String.valueof(accpg.getPageNumber());
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description String for returning the maximum page number of the Account table.
    */
     
     public String getAccmaxPageNumber(){
       return AccmaxPageNumber;
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the previous page of the current page of the Account table.
    */
     
     public void accprevious() {
       accpg.previous();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the next page of the current page of the Account table.
    */
     
     public void accnext() {
       accpg.next();
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for setting the page number based on the selected pagenumber from the picklist of the Account table.
    */
     
     public void accsetPageNumber(){
       accpg.setpageNumber(selectedpage);
     }
     
     
     
     /** ---- CONTACT PAGINATION ---- **/
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Pagination for Contacts  
    */
    
    public ApexPages.StandardSetController conpg {
      get {
      if(conpg == null) {
        conpg = new ApexPages.StandardSetController(fconlist);
        // sets the number of records in each page set
        conpg.setPageSize(recordsPerPage);
      }
      return conpg;
      }
      set;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Gets the current page number of the Contact table
    */
    
    public Integer conpageNumber {
      get {
        return conpg.getPageNumber();
      }
      set;
    }
   
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the first page of the Contact table.
    */
    
     public void confirst() {
       conpg.first();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the last page of the Contact table.
    */
    
     public void conlast() {
       conpg.last();
       ConMaxPageNumber = String.valueof(conpg.getPageNumber());
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description String for returning the maximum page number of the Contact table.
    */
    
     public String getConmaxPageNumber(){
       return ConmaxPageNumber;
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the previous page of the current page of the Account table.
    */
    
     public void conprevious() {
       conpg.previous();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the next page of the current page of the Account table.
    */
    
     public void connext() {
       conpg.next();
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for setting the page number based on the selected pagenumber from the picklist of the Account table.
    */
    
     public void consetPageNumber(){
       conpg.setpageNumber(selectedpage);
     }
     
     
     
     /** ---- OPPORTUNITY PAGINATION ---- **/
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Pagination for Opportunity  
    */
    
    public ApexPages.StandardSetController opppg {
      get {
      if(opppg == null) {
        opppg = new ApexPages.StandardSetController(fopplist);
        // sets the number of records in each page set
        opppg.setPageSize(recordsPerPage);
      }
      return opppg;
      }
      set;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Gets the current page number of the Opportunity table
    */
    
    public Integer opppageNumber {
      get {
        return opppg.getPageNumber();
      }
      set;
    }
   
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the first page of the Opportunity table.
    */
    
     public void oppfirst() {
       opppg.first();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the last page of the Opportunity table.
    */
    
     public void opplast() {
       opppg.last();
       OppMaxPageNumber = String.valueof(opppg.getPageNumber());
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description String for returning the maximum page number of the Opportunity table.
    */
     
     public String getOppmaxPageNumber(){
       return OppmaxPageNumber;
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the previous page of the current page of the Opportunity table.
    */
    
     public void oppprevious() {
       opppg.previous();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the next page of the current page of the Opportunity table.
    */
    
     public void oppnext() {
       opppg.next();
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for setting the page number based on the selected pagenumber from the picklist of the Opportunity table.
    */
    
     public void oppsetPageNumber(){
       opppg.setpageNumber(selectedpage);
     }
     
     
     
     /** ---- LEAD PAGINATION ---- **/
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Pagination for LEAD  
    */
    
    public ApexPages.StandardSetController leadpg {
      get {
      if(leadpg == null) {
        leadpg = new ApexPages.StandardSetController(fleadlist);
        // sets the number of records in each page set
        leadpg.setPageSize(recordsPerPage);
      }
      return leadpg;
      }
      set;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Gets the current page number of the LEAD table
    */
    
    public Integer leadpageNumber {
      get {
        return leadpg.getPageNumber();
      }
      set;
    }
   
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the first page of the LEAD table.
    */
    
     public void leadfirst() {
       leadpg.first();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the last page of the LEAD table.
    */
    
     public void leadlast() {
       leadpg.last();
       LeadMaxPageNumber = String.valueof(leadpg.getPageNumber());
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description String for returning the maximum page number of the LEAD table.
    */
     
     public String getLeadmaxPageNumber(){
       return LeadmaxPageNumber;
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the previous page of the current page of the LEAD table.
    */
    
     public void leadprevious() {
       leadpg.previous();
     }
   
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for returning the next page of the current page of the LEAD table.
    */
    
     public void leadnext() {
       leadpg.next();
     }
     
     /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description Method for setting the page number based on the selected pagenumber from the picklist of the LEAD table.
    */
    
     public void leadsetPageNumber(){
       leadpg.setpageNumber(selectedpage);
     }   
     
     
     
     
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 02 Oct 2012 
    * @description Method used for Sorting field columns for Accounts, Contacts and Opportunities  
    */
    
    public void doSort(){
     System_Event_Log__c sLog;
     SystemEventLogDML sLogDML = new SystemEventLogDML();
     
     try {  
      String order = 'asc';
      String theQuery = '';
      Integer pnum = 0;
      accsortOrder = consortOrder = oppsortOrder = leadsortOrder = 'asc';
          
          //Sort Account table
          if (sortObject == 'Account'){
            sortField = accsortField;
            if(accpreviousSortField == sortField){
                  accsortOrder = 'desc';
                  accpreviousSortField = null;
            }else{
                  accpreviousSortField = sortField;
                  accsortOrder = order;
            }
            order = accsortOrder;
            sortList = new list <Account>();
            theQuery = accquery + 'Order By '+sortField+' '+order;
            facclist = database.query(thequery);
            sortList = faccList;
          }
          
          //Sort Contact table
          else if (sortObject == 'Contact'){
            sortField = consortField;
            if(conpreviousSortField == sortField){
                  consortOrder = 'desc';
                  conpreviousSortField = null;
            }else{
                  conpreviousSortField = sortField;
                  consortOrder = order;
            }
            order = consortOrder;
            sortList = new list <Contact>();
            theQuery = conquery + 'Order By '+sortField+' '+order;
            fconList = database.query(thequery);
            sortList = fconList;
          }
          
          //Sort Opportunity table
          else if (sortObject == 'Opportunity'){
            sortField = oppsortField;
            if(opppreviousSortField == sortField){
                  oppsortOrder = 'desc';
                  opppreviousSortField = null;
            }else{
                  opppreviousSortField = sortField;
                  oppsortOrder = order;
            }
            
            order = oppsortOrder;
            sortList = new list <Opportunity>();
            theQuery = oppquery + 'Order By '+sortField+' '+order;
            theQuery = oppquery;
            foppList = database.query(thequery);
            sortList = foppList;
          }
          
          //Sort Lead table
          else if (sortObject == 'Lead'){
            sortField = leadsortField;
            if(leadpreviousSortField == sortField){
                  leadsortOrder = 'desc';
                  leadpreviousSortField = null;
            }else{
                  leadpreviousSortField = sortField;
                  leadsortOrder = order;
            }
            
            order = leadsortOrder;
            sortList = new list <Lead>();
            theQuery = leadquery + 'Order By '+sortField+' '+order;
            theQuery = leadquery;
            fleadList = database.query(thequery);
            sortList = fleadList;
          } 
          
          
          //Display Visual Indicators (arrows on column headers)
          CustomSettingsBuilder csbuilder = new CustomSettingsBuilder();
          if (order == 'asc'){
            sortimg = csbuilder.getAscSortImageURL();
          } 
          else if (order == 'desc'){
            sortimg = csbuilder.getDescSortImageURL();
          }
          
          //Sort table by Reference IDs (e.g. Opportunity's AccountID sort by Account.Name not by ID)
          superSort.sortList(sortList,sortField,order);
      sobjpg = new ApexPages.StandardSetController(sortList);
      sobjpg.setPageSize(recordsPerPage);
      
        //Sort StandardSetController of Account
            if (sortObject == 'Account'){
                pnum = accpg.getPageNumber();
                accpg = null;
                accpg = sobjpg;
                accpg.setpageNumber(pnum);
            }
          
          //Sort StandardSetController of Contact
          else if (sortObject == 'Contact'){
            pnum = conpg.getPageNumber();
            conpg = null;
            conpg = sobjpg;
            conpg.setpageNumber(pnum);
          }
          
          //Sort StandardSetController of Opportunity
          else if (sortObject == 'Opportunity'){
            pnum = opppg.getPageNumber();
            opppg = null;
            opppg = sobjpg;
            opppg.setpageNumber(pnum);
          }
          
          //Sort StandardSetController of Lead
          else if (sortObject == 'Lead'){
            pnum = leadpg.getPageNumber();
            leadpg = null;
            leadpg = sobjpg;
            leadpg.setpageNumber(pnum);
          }      
     }
     catch(Exception e){
      //log the exception on the system event log object
            sLog = sLogDML.generateSysLog('MyFavoritesController.doSort', e.getMessage(), '', slogDml.EvtType[0], UserInfo.getUserId());
            insert sLog;
      
      ApexPages.addMessages(e);
       }
          
    }
    
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 5 Apr 2012 Last Modified: 02 Oct 2012 
    * @description method for deleting all of the selected favorites 
    */
    
    public PageReference DeleteFavorite(){
      System_Event_Log__c sLog;
      SystemEventLogDML sLogDML = new SystemEventLogDML();
      
      try{
      delFavList = new list <Favorites__c>();
      //Add selected Account records on the list to be deleted
      if (sobjwrAccList != null){
        if (sobjwrAccList.size() > 0){
          for (sobjwrapper swa : sobjwrAccList){
            if (swa.isSelected){
              if (FavMap.containskey(swa.acc.Id)){
                delFavList.add(FavMap.get(swa.acc.Id));
              }
            }
          }
          for (Integer x=0; x < sobjwrAccList.size(); x++){
            if (sobjwrAccList[x].isSelected){
              if ( FavMap.containskey(sobjwrAccList[x].acc.Id) ){
                sobjwrAccList.remove(x);
                x--;
              }
            }
          }
          accsize = String.valueof(sobjwrAccList.size());
        }
      }
      
      //Add selected Contact records on the list to be deleted
      if (sobjwrConList != null){
        if (sobjwrConList.size() > 0){
          for (sobjwrapper swc : sobjwrConList){
            if (swc.isSelected){
              if (FavMap.containskey(swc.con.Id)){
                delFavList.add(FavMap.get(swc.con.Id));
              }
            }
          }
          for (Integer x=0; x < sobjwrConList.size(); x++){
            if (sobjwrConList[x].isSelected){
              if ( FavMap.containskey(sobjwrConList[x].con.Id) ){
                sobjwrConList.remove(x);
                x--;
              }
            }
          }
          consize = String.valueof(sobjwrConList.size());
        }
      }
      
      //Add selected Opportunity records on the list to be deleted
      if (sobjwrOppList != null){
        if (sobjwrOppList.size() > 0){
          for (sobjwrapper swo : sobjwrOppList){
            if (swo.isSelected){
              if (FavMap.containskey(swo.opp.Id)){
                delFavList.add(FavMap.get(swo.opp.Id));
              }
            }
          }
          for (Integer x=0; x < sobjwrOppList.size(); x++){
            if (sobjwrOppList[x].isSelected){
              if ( FavMap.containskey(sobjwrOppList[x].opp.Id) ){
                sobjwrOppList.remove(x);
                x--;
              }  
            }
          }
          oppsize = String.valueof(sobjwrOppList.size());
        }
      }
      
      //Add selected Lead records on the list to be deleted
      if (sobjwrLeadList != null){
        if (sobjwrLeadList.size() > 0){
          for (sobjwrapper swo : sobjwrLeadList){
            if (swo.isSelected){
              if (FavMap.containskey(swo.led.Id)){
                delFavList.add(FavMap.get(swo.led.Id));
              }
            }
          }
          for (Integer x=0; x < sobjwrLeadList.size(); x++){
            if (sobjwrLeadList[x].isSelected){
              if ( FavMap.containskey(sobjwrLeadList[x].led.Id) ){
                sobjwrLeadList.remove(x);
                x--;
              }  
            }
          }
          leadsize = String.valueof(sobjwrLeadList.size());
        }
      }   
      
      //Delete selected records as Favorite
      if (delFavList.size() > 0){
        delete delFavList;
          //Hide Account section on page if there are no more Account favorites presents
          if (sobjwrAccList.size() == 0 && sobjwrAccList != null){
            accrend = 'false';
          }
          //Hide Contact section on page if there are no more Contact favorites presents
          if (sobjwrConList.size() == 0 && sobjwrConList != null){
            conrend = 'false';
          }
          //Hide Opportunity section on page if there are no more Opportunity favorites presents
          if (sobjwrOppList.size() == 0 && sobjwrOppList != null){
            opprend = 'false';
          }
          //Hide Lead section on page if there are no more Lead favorites presents
          if (sobjwrLeadList.size() == 0 && sobjwrLeadList != null){
            leadrend = 'false';
          }       
          
          
          favlist = [Select Id 
                 From Favorites__c 
                 Where User__c = :UserInfo.getuserId()
                       ];
          
          //Show a message if there are no more records marked as favorites                          
                if (favlist.size() == 0){
                  showdelete = 'false';
                  showmsg = 'true';
                }
                          
      }
       }
      catch(Exception e){
      //log the exception on the system event log object
            sLog = sLogDML.generateSysLog('MyFavoritesController.deleteFavorite', e.getMessage(), '', slogDml.EvtType[0], UserInfo.getUserId());
            insert sLog;
        
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                  '['+e.getLineNumber()+']'+e);
      ApexPages.addMessage(msg);
        
      } 
      PageReference pageref = Page.MyFavorites;
      pageref.setRedirect(true);
        return pageref;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description picklist for selecting page for favorite Accounts
    */
    
    public list<SelectOption> getAccPageSelect(){
          list<SelectOption> pageList = new List<Selectoption>();
          for(Integer i=1;i<=Integer.valueof(AccmaxPageNumber);i++){
            pageList.add(new SelectOption(String.valueOf(i) , String.valueOf(i)));
          }
          return pageList;
      }
      
      /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description picklist for selecting page for favorite Contacts
    */
      
      public list<SelectOption> getConPageSelect(){
          list<SelectOption> pageList = new List<Selectoption>();
          for(Integer i=1;i<=Integer.valueof(ConmaxPageNumber);i++){
            pageList.add(new SelectOption(String.valueOf(i) , String.valueOf(i)));
          }
          return pageList;
      }
      
      /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description picklist for selecting page for favorite Opportunities
    */
    
      public list<SelectOption> getOppPageSelect(){
          list<SelectOption> pageList = new List<Selectoption>();
          for(Integer i=1;i<=Integer.valueof(OppmaxPageNumber);i++){
            pageList.add(new SelectOption(String.valueOf(i) , String.valueOf(i)));
          }
          return pageList;
      }
      

      /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description picklist for selecting page for favorite Leads
    */
    
      public list<SelectOption> getLeadPageSelect(){
          list<SelectOption> pageList = new List<Selectoption>();
          for(Integer i=1;i<=Integer.valueof(LeadmaxPageNumber);i++){
            pageList.add(new SelectOption(String.valueOf(i) , String.valueOf(i)));
          }
          return pageList;
      }       
      
      
      
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description gets list of all the User's favorite Accounts
    */
    
    public list <sobjwrapper> getsobjwrAccList(){
        sobjwrAccList = new List<sobjwrapper>();
      for (Account acc : (List<Account>)accpg.getRecords()){
        sobjwrAccList.add(new sobjwrapper(acc,null,null,null));
      } 
      return sobjwrAccList;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description gets list of all the User's favorite Contacts
    */
    
    public list <sobjwrapper> getsobjwrConList(){
      sobjwrConList = new list<sobjwrapper>();
      for (Contact con : (list<Contact>)conpg.getRecords()){
        sobjwrConList.add(new sobjwrapper(null,con,null,null));
      } 
      return sobjwrConList;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description gets list of all the User's favorite Opportunities
    */
    
    public list <sobjwrapper> getsobjwrOppList(){
      sobjwrOppList = new list<sobjwrapper>();
      for (Opportunity opp : (list<Opportunity>)opppg.getRecords()){
        sobjwrOppList.add(new sobjwrapper(null,null,opp,null));
      } 
      return sobjwrOppList;
    }
    
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 10 Apr 2012 Last Modified: 05 July 2012 
    * @description gets list of all the User's favorite Opportunities
    */
    
    public list <sobjwrapper> getsobjwrLeadList(){
      sobjwrLeadList = new list<sobjwrapper>();
      for (Lead led : (list<Lead>)leadpg.getRecords()){
        sobjwrLeadList.add(new sobjwrapper(null,null,null,led));
      } 
      return sobjwrLeadList;
    }   
    
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC  Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 28 Mar 2012 Last Modified: 05 July 2012 
    * @description wrapper class for Accounts, Contacts and Opportunity 
    */
    
    public class sobjwrapper {
      public  Account acc    {get; set;}
      public  Contact con    {get; set;}
      public  Opportunity opp {get; set;}
      public  Lead led {get; set;}
      
      public  Boolean  isSelected {get; set;}
      public sobjwrapper(Account acct, Contact cont, Opportunity oppt, Lead Ld){
        acc = acct;
        con = cont;
        opp = oppt;
        led = Ld;
        isSelected = false;
      }
    }
    
    
}