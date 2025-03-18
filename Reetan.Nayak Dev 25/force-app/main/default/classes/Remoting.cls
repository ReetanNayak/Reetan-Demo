public with sharing class Remoting {

Public apexpages.standardcontroller   bln{get; set;}
  
    public Remoting(ApexPages.StandardSetController controller) {
    controller.setPageSize(5);
    list<account> act=new list<account>();
    act= controller.getrecords();
system.debug('@@@@@@@@@@@@@@'+act);
    }

}