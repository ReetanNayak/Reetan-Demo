trigger preventdupe on contact(before insert ,before update)
{

map<string,contact> mpconemail=new map<string,contact>();
map<string,contact> mpcon=new map<string,contact>();
If(trigger.isinsert)
{
for(integer i=0; i<system.trigger.new.size(); i++)
{
    
      system.debug('acd0'+trigger.new[i]);
        if(system.trigger.new[i].email != null)
        {
           system.debug('acd1');
            mpconemail.put(system.trigger.new[i].email,system.trigger.new[i]);
            mpcon.put(system.trigger.new[i].lastname,system.trigger.new[i]);
        }
        else if(system.trigger.new[i].lastname !=null || system.trigger.new[i].lastname!='')
        { system.debug('acd2');
   
              mpcon.put(system.trigger.new[i].lastname,system.trigger.new[i]);
        }
    
    
  

}

system.debug('hhhhhhhhhhhhhhhhhh'+mpconemail.keyset());

for(contact ctt :[select id,name,email,lastname from contact where( email IN :mpconemail.keyset() ) OR (Lastname IN:mpcon.keyset())])
{
    for(integer i=0;i<trigger.new.size();i++)
    {

         if(trigger.new[i].email !=null)
        {
              if(trigger.new[i].email==ctt.email)
              {
                trigger.new[i].adderror('Already existed Contact');
              }
              else if(trigger.new[i].lastname==ctt.lastname)
              {
               trigger.new[i].adderror('Already existed Contact');
              }
          
         }
         else if(trigger.new[i].lastname==ctt.lastname)
         {
                trigger.new[i].adderror('Already existed Contact');
         }
     
     
    }
 
 }
}



}