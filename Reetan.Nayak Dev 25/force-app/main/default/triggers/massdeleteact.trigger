trigger massdeleteact on Account (after update) 
{
if(trigger.isupdate)
{

for(account act: trigger.new)
{
if(act.name=='Amit')
{
string str='select id from account where name =:'+act.name;
MassDeleteRecords md=new MassDeleteRecords (str);

}


}

}
}