trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    
    List<Task> tskList = new List<Task>();

    //for(Opportunity opp : [Select id, Name, StageName from Opportunity where ID IN: Trigger.New]){
    for(Opportunity opp : Trigger.New){
        if(Trigger.isInsert){
            if(opp.StageName == 'Closed Won') {
				tskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
			}
        }
        
        if(Trigger.isUpdate){
            if( opp.StageName == 'Closed Won' && opp.StageName != trigger.oldMap.get(opp.Id).StageName ){
                Task t = new Task();
                t.Subject = 'Follow Up Test Task';
                t.WhatId = opp.Id;
                tskList.add(t);
            }
        }
    }  
    
    if(tskList.size() > 0){
        insert tskList; 
    } 

} 

// ================
/*
trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Task> taskList = new List<Task>();
    
    for(Opportunity opp : Trigger.new) {
		
		//Only create Follow Up Task only once when Opp StageName is to 'Closed Won' on Create
		if(Trigger.isInsert) {
			if(Opp.StageName == 'Closed Won') {
				taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
			}
		}
		
		//Only create Follow Up Task only once when Opp StageName changed to 'Closed Won' on Update
		if(Trigger.isUpdate) {
			if(Opp.StageName == 'Closed Won' && Opp.StageName != Trigger.oldMap.get(opp.Id).StageName) {
				// taskList.add(new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id));
				Task t = new Task();
                t.Subject = 'Follow Up Test Task';
                t.WhatId = opp.Id;
                taskList.add(t);
			}
		}       
    }

    if(taskList.size()>0) {        
        insert taskList;        
    }    
} */