trigger testundel on Account (after undelete)
{ 
list<account> act=new list<account>();
list<task> tsk=new list<task>();
for(account actt : trigger.new)
{
task temptask=new task(whatid=actt.id,ownerid=actt.OwnerId, subject='call', description='make mail');
tsk.add(temptask);

}

insert tsk;
}