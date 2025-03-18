public class ObjectFetch1_CLS {
    public List<FieldDetails> filedDet{get;set;}
    public string str;
    
    public ObjectFetch1_CLS() {
        str = ApexPages.CurrentPage().getParameters().get('objName');
        try{
         filedDet = new List<FieldDetails>();
         Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
         if(str != 'blank') {
             Map<String, Schema.SObjectField> fieldMap = schemaMap.get(str).getDescribe().fields.getMap();
             for(String fieldName: fieldMap.keySet()) {
                 FieldDetails fd=new FieldDetails();
                 fd.name=fieldName;
                 fd.label=String.valueOf(fieldMap.get(fieldName).getDescribe().getLabel());
                 fd.type=String.valueOf(fieldMap.get(fieldName).getDescribe().getType());
                 filedDet.add(fd);
             }         
        }
        }catch(Exception ee){}
    }

   public class FieldDetails{
       public String name{get;set;}
       public String label{get;set;}
       public String type{get;set;}
   }
}