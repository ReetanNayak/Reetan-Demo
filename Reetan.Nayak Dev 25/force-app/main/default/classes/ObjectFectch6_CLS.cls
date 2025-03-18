public class ObjectFectch6_CLS {
    public List<InrPair> InrField {get; set;}
    public string str;
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
    
    public ObjectFectch6_CLS() {
        str = ApexPages.CurrentPage().getParameters().get('objVal');
        try{
            InrField = new List<InrPair>();
            if(str != 'blank') {
                Map <String, Schema.SObjectField> fieldMap = schemaMap.get(str).getDescribe().fields.getMap();
                for(Schema.SObjectField sfield : fieldMap.Values()) {
                    schema.DescribeFieldResult dfield = sfield.getDescribe();
                    InrPair fld = new InrPair();
                        fld.label = dfield.getLabel();
                        fld.name = dfield.getName();
                        fld.type = string.valueof(dfield.getType());
                        fld.cust = string.valueof(dfield.isCustom());     
                       // fld.digit = dfield.getLocalName();
                        fld.digit = string.valueof(dfield.getRelationshipName());
                    InrField.add(fld);
                }        
            }
         }catch(Exception e) {}   
    }
    
    public class InrPair {
        public String label {get; set;}
        public String name {get; set;}
        public string type {get; set;}
        public string cust {get; set;}
        public string digit {get; set;}
    }

}