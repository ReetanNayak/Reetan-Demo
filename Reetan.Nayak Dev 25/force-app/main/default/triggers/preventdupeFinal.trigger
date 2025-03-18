trigger preventdupeFinal on contact(before insert ,before update)
{

map<string,contact> mpdupect=new map<string,contact>();
map<string,contact> mpdupectname=new map<string,contact>();
    for(contact ct: System.trigger.new)
    { 
      if(ct.email != null)
      {
          mpdupect.put(ct.email,ct); 
          mpdupectname.put(ct.lastname,ct); 
      }
      else 
      {
        mpdupectname.put(ct.lastname,ct); 
         
      }
    
    }
    
    If(trigger.isinsert)
    {
    

    system.debug('hhhhhhhhhhhhhhhhhh'+mpdupectname.keyset());

    for(contact ctt :[select id,name,email,lastname from contact where( email IN :mpdupect.keyset() ) OR (Lastname IN:mpdupectname.keyset())])
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
    if(trigger.isupdate)
    {
    
    
    for(Contact ct:[select id,name,lastname,email from contact where Email in :mpdupect.keyset() OR LastName IN: mpdupectname.keyset()])
    
    {
    for(integer i=0;i<trigger.new.size();i++)
    {
    if(trigger.new[i].email !=null)
    {
    If( (trigger.oldmap.get(system.trigger.new[i].id).email != trigger.new[i].email)&& ct.Email==trigger.new[i].email)
    {
    trigger.new[i].adderror('Duplicate');
    }
    else if((trigger.oldmap.get(system.trigger.new[i].id).lastname != trigger.new[i].lastname) && (ct.lastname == Trigger.new[i].lastname)) 
    { 
    trigger.new[i].adderror('Duplicate');
    }
    }
    else  if((trigger.oldmap.get(system.trigger.new[i].id).lastname != trigger.new[i].lastname) && (ct.lastname == Trigger.new[i].lastname)) 
    { 
    trigger.new[i].adderror('Duplicate');
    }
    else 
    {
    
    }
    
    
    }}
    }



}