trigger leadDuplicatePreventer on contact(before insert, before update) 
                               {

    Map<String, contact> leadMap = new Map<String, contact>();
    for (contact con : System.Trigger.new) {
        
        // Make sure we don't treat an email address that  
    
        // isn't changing during an update as a duplicate.
        If(con.Email!=null)  
    {
        if ((con.Email != null) &&(System.Trigger.isInsert ||(con.Email != System.Trigger.oldMap.get(con.Id).Email))) 
                    {
        
            // Make sure another new lead isn't also a duplicate  
    
            if (leadMap.containsKey(con.Email)) 
            {
                con.Email.addError('Another new lead has the '
                                    + 'same email address.');
            } else 
            {
                leadMap.put(con.Email,con);
            }
       }
       }
      else if(con.lastname!=null)
       {
       if ((con.lastname != null) &&(System.Trigger.isInsert ||(con.lastname != System.Trigger.oldMap.get(con.Id).lastname))) 
                    {
        
            // Make sure another new lead isn't also a duplicate  
    
            if (leadMap.containsKey(con.lastname)) 
            {
                con.Email.addError('Another new lead has the '
                                    + 'same email address.');
            } else 
            {
                leadMap.put(con.lastname,con);
            }
       }
       
       
       }
       
    }
    
     
    
    for (contact ct : [SELECT Email FROM contact
                      WHERE Email IN :leadMap.KeySet()]) {
        contact newLead = leadMap.get(ct.Email);
        newLead.Email.addError('A lead with this email  '+ 'address or lastname already exists.');
    }
}