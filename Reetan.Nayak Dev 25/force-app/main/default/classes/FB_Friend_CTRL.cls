public with sharing class FB_Friend_CTRL {

   public String UserIddata { get; set; }
   public String graphuri = 'https://graph.facebook.com/';
   Public string fbaccesstoken;
   string clientId='';
   public void getfrnsdata() 
    {clientId=[select id,clientID__c from FacebookApp__c where id='a0390000001LoR8'][0].clientID__c;
    FacebookApp__c fapp = [select AccessToken__c, lastModifiedDate from FacebookApp__c where clientID__c =:this.clientId];
    fbaccesstoken=fapp.AccessToken__c;
    
       String endpoint = graphuri+UserIddata+'?friends=name'+'&access_token='+fbaccesstoken;
       Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            HttpResponse res = h.send(req);
            String response = res.getBody();
            JSONParser parser = JSON.createParser(res.getBody());
System.debug('@@@@@@@@@@@@@2'+response);
            
    }

    
    
    
    
}