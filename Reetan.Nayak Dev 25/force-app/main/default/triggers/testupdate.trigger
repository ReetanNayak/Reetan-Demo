trigger testupdate on contact (before update)
{ map<string,contact> mpdupect=new map<string,contact>();
  map<string,contact> mpdupectname=new map<string,contact>();  
    if(trigger.isupdate)
    {
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