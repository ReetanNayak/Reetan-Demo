trigger AutoCreateFollowUpTasks on Task (after insert) {
    if(trigger.isinsert) {
    list<contact> ct=[select id,accountid,name from contact where id=:trigger.new[0].whoid];
        if(ct[0].accountid !=null) {
            task temptask=[select id ,whoid,subject from task where id=:trigger.new[0].id ];
            temptask.whatid=ct[0].accountid;
            update temptask;
        }
    }   
}