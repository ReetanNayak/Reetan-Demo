trigger sharingObjectA on ObjectA__c (before insert,after update) 
{
    if(trigger.isInsert || trigger.isupdate)
    {
        list<ObjectA__Share> jobShares  = new List<ObjectA__Share>();
        list<Group> gp=[Select g.Id, g.Name from Group g where g.name='SharingGroup'];
        
        for(ObjectA__c obja: trigger.new)
        {
            ObjectA__Share shrObja=new ObjectA__Share();
            if(obja.Status__c !='Open')
            {
            shrObja.ParentId=obja.id;
            shrObja.UserOrGroupId=gp[0].id;
            shrObja.AccessLevel = 'Edit';
            jobShares.add(shrObja);
            }
            else
            {
            shrObja.ParentId=obja.id;
            shrObja.UserOrGroupId=gp[0].id;
            shrObja.AccessLevel = 'Read';
            jobShares.add(shrObja);
            }


       }
       list<Database.SaveResult> drs=Database.insert(jobShares,false);

    }

}