trigger trg_mrglead on Lead (after insert) 
{
lead temlead=[select id, Company,lastname from Lead where Company='Navatar' limit 1];
list<Lead> ld=new list<Lead>();
For(Integer i=0; i<trigger.new.size(); i++)
if(trigger.new[i].Company=='Navatar' || trigger.new[i].LastName=='sharma')
{
ld.add(trigger.new[i]);
}
else
  merge temlead ld;

}