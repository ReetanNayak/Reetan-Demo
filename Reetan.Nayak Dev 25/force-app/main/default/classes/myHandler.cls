global class myHandler implements Messaging.InboundEmailHandler 
{
private string strEmailbody;
Private string strtxtattachment;
Private blob csvbdy;
public string strdata;
String[] filelines = new String[]{};
global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) 
{
    strEmailbody= email.htmlbody;
    csvbdy   = email.binaryAttachments[0].body;
    strdata  =csvbdy.tostring();
    list<Lead> ld=new list<Lead>();
    filelines =filelines = strdata.split('\n');
    for (Integer i=1;i<filelines.size();i++)
    {
            String[] inputvalues = new String[]{};
            inputvalues = filelines[i].split(',');
            
            lead a = new lead ();
            a.lastName = inputvalues[0];
            a.company= inputvalues[1]; 
            a.email= inputvalues[2] ;    
            ld.add(a);
     }
    try{
        insert ld;
        }
        catch (Exception e)
        {
        }            
Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

return result;
}
}