Public class trialtest
{

    public String ctt { get; set; }

public list<contact> test()
{
 list<contact> ctt=[select id ,name from contact];
 return ctt;
}
}