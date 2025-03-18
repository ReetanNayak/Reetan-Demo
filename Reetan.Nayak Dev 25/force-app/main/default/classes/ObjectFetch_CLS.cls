public class ObjectFetch_CLS {
    public String ObjValues { get; set; }
   // public List<SelectOption> Categ{get;set;}
    public List<FieldDetails> filedDet{get;set;}
    public Boolean showTable{get; set;}
    public Boolean showButton{get; set;}
    
    public ObjectFetch_CLS() {
        showTable = false;
        showButton = false;
    }
    
    public List<SelectOption> getObjItems() {
        List<SelectOption> opt = new List<SelectOption>();
        opt.add(new SelectOption('blank', '--Select Object--'));
        List<Schema.SobjectType> obj = Schema.getGlobalDescribe().Values();
        for(Schema.SobjectType ss:obj) {
            opt.add(new SelectOption(ss.getDescribe().getName(), ss.getDescribe().getName()));
            opt.sort();
        }
        return opt;
    }
    
    public void fieldDescribe(){
         filedDet = new List<FieldDetails>();
         Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         if(ObjValues != 'blank') {
             Map<String, Schema.SObjectField> fieldMap = schemaMap.get(ObjValues).getDescribe().fields.getMap();
             for(String fieldName: fieldMap.keySet()) {
                 FieldDetails fd=new FieldDetails();
                     fd.name = fieldName;
                     fd.label = String.valueOf(fieldMap.get(fieldName).getDescribe().getLabel());
                     fd.type = String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                     filedDet.add(fd);
             } 
            showTable = true; 
            showButton = true;
        }
        else{
            showTable = false; 
            showButton = false;
        }    
    }
    
    
    public PageReference showExport() {
        system.debug('.........PFFFFFFFF ');
        PageReference pf = new PageReference('/apex/ObjectFetch1');
        pf.getParameters().put('objName', ObjValues);
        pf.setRedirect(true);
        system.debug('PFFFFFFFF ');
        return pf;
    }
   
   public class FieldDetails{
       public String name{get;set;}
       public String label{get;set;}
       public String type{get;set;}
   }

}