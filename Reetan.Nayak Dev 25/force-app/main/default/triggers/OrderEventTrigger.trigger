trigger OrderEventTrigger on Order_Event__e (after insert) {
    
    // List to hold all Orders to be created.
    List<Task> lstTask = new List<Task>();
    
    // Iterate through each notification.
    for(Order_Event__e event : Trigger.New){
        if(event.Has_Shipped__c == True){
            Task tsk = new Task();
            tsk.Status = 'New';
            tsk.Priority = 'Medium';
            tsk.Subject = 'Follow up on shipped order ' + event.Order_Number__c;
            tsk.OwnerId = event.CreatedById;
            lstTask.add(tsk);
            //insert tsk;
        }
    }
    if(lstTask.Size() > 0){
        insert lstTask;
    }
    
}