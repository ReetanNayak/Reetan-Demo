public class testcontrollersfapp {

   public  string accessToken { get; set; }
    public  string clientID { get; set; }
    public  string fbID { get; set; }
    
    public  string clientSecret { get; set; }
    public  string code { get; set; }
    public  string recordId { get; set; }
    public  string appName { get; set; }
    public  string facebookUname { get; set; }
    
    public testcontrollersfapp ()
    {
        System.debug('IN CONS');
        //get the sfdc record id of the app we are going to call.
        if(recordId == null)
        {
            System.debug('SETTING RECORDID');
            recordId = ApexPages.currentPage().getParameters().get('id'); 
        }
    }
    


public PageReference fnlogin()
    {
        Salesforceapp__c fapp;
        PageReference p = null;

        
        //first request
        if(ApexPages.currentPage().getParameters().containsKey('id'))
        {
            
           // storeCookie(ApexPages.currentPage().getParameters().get('id'));
            
            fapp = [select Client_id__c, client_secret__c from Salesforceapp__c where id = :recordId];
        
            
            String exPerms = '';
          /*  if(fapp.extendedPermissions__c != null && fapp.extendedPermissions__c != ''){
                exPerms = '&scope='+fapp.extendedPermissions__c;
            }*/
        
            //note: connect url in fb application connect setting should be: https://c.na3.visual.force.com/apex/
            // you need the trailing slash even though it bitches about it
            String rediruri = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/lgnPage';
            System.debug('host:'+rediruri);
                
            String authuri = 'https://ap1.salesforce.com/oauth/authorize?client_id='+
                            fapp.Client_id__c+'&redirect_uri='+rediruri+exPerms+'&x_rid='+recordID;
        
             p = new PageReference(authuri);
             
        }
        else if(ApexPages.currentPage().getParameters().containsKey('client_secret')) //final req
        {
            System.debug('FINAL STEP:');
        }
        else if(ApexPages.currentPage().getParameters().containsKey('code')) //second req
        {
            
            
            String rid = getRecordIdFromCookie();
            System.debug('URI: '+ApexPages.currentPage().getUrl()); 
            
            fapp = [select Name, Client_id__c, Access_Token__c, client_secret__c,extendedPermissions__c,Code__c from Salesforceapp__c where id = :rid];
            fapp.Code__c = ApexPages.currentPage().getParameters().get('code');
            
                String exPerms = '';
           /* if(fapp.extendedPermissions__c != null && fapp.extendedPermissions__c != ''){
                exPerms = '&scope='+fapp.extendedPermissions__c;
            }
            */
            String rediruri = 'https://'+ApexPages.currentPage().getHeaders().get('Host')+'/apex/lgnPage';
            System.debug('&&&&&&&&&&'+rediruri);
            String authuri = 'https://ap1.salesforce.com/oauth/access_token?client_id='+
                            fapp.Client_id__c+'&redirect_uri='+rediruri+exPerms+'&client_secret='+fapp.client_secret__c+'&code='+fapp.Code__c;                    
            System.debug('URL IS:'+authuri);
            
            doFinalHttpRequest(authuri, fapp);
            recordId = rid;
            appName = fapp.Name;
            
            //p = Page.FacebookOAuthRedirect;
        
        }
      return p;
        
    }
    
    
    private void doFinalHttpRequest(String uri, Salesforceapp__c fapp)
    {
        Http h = new Http();
    
        HttpRequest req = new HttpRequest();
        req.setEndpoint(uri);
        req.setMethod('GET');
    
        HttpResponse res = h.send(req);
    
    
        String resp = res.getBody();
        System.debug('FINAL RESP IS:'+resp); 
        //token string in format of access_token=XXXXX&expires - we want the first value
        String accesstoken = '';
        if(resp.indexOf('&') > -1){
            accesstoken = resp.substring(13, resp.indexOf('&'));
        }
        else {
            accesstoken = resp.substring(13,resp.length());
        }
        fapp.Access_Token__c = accesstoken;
        System.debug('Access token:'+accesstoken);
        update fapp;
    }
    private String getRecordIdFromCookie()
    {
        if(ApexPages.currentPage().getCookies().containsKey('recordid'))
            System.debug('--->there is a cookie here!!!');
            
        Cookie c = ApexPages.currentPage().getCookies().get('recordid');
        
        System.debug('GETTING A COOKIE FROM CURRENT PAGE:'+ApexPages.currentPage()+' with value'+c.getValue());
        return c.getValue();
    } private void storeCookie(String recordid)
    {
        System.debug('CURRENT PAGE SETTING A COOKIE:'+ApexPages.currentPage()+ ' with value='+recordid);
        
        Cookie c = new Cookie('recordid',recordid,null,-1,false);
        ApexPages.currentPage().setCookies(new Cookie[]{c});
    }

}