public with sharing class CustomAccountLookup_CLS {
 
  public User user{get;set;} // new account to create
  public List<User> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
 
  public CustomAccountLookup_CLS() {
    user = new User();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    runSearch();  
  }
 
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
 
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString);               
  } 
 
  // run the search and return the records found. 
  private List<User> performSearch(string searchString) {
 
    String soql = 'select id, name from User';
    if(searchString != '' && searchString != null)
      soql = soql +  ' where name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 
 
  }
 
  // save the new account record
 /* public PageReference saveAccount() {
    insert account;
    // reset the account
    account = new Account();
    return null;
  }*/
 
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
 
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
 
}