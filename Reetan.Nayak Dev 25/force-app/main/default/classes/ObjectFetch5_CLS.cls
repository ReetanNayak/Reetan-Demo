public class ObjectFetch5_CLS {
    public String selectedObject {get; set;}
    public List <InrPair> InrField {get; set;}
    public List <SelectOption> objectNames {get; set;}
    public Boolean showTable {get; set;}
    public Boolean showButton {get; set;}
    public Boolean displayPB2 {get; set;}
    
    
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
       
    public ObjectFetch5_CLS() {
        objectNames = initObjNames();
        InrField = new List<InrPair>();
        showTable = false;
        showButton = false;
        displayPB2 = false;
    }

    private List<SelectOption> initObjNames() {
        List<SelectOption> objNames = new List<SelectOption>();
     //   objNames.add(new SelectOption('blank', '--Select Object--'));
        List<Schema.SobjectType> obj = Schema.getGlobalDescribe().Values();
        for(Schema.SobjectType ss:obj) {
            objNames.add(new SelectOption(ss.getDescribe().getName(), ss.getDescribe().getName()));
            objNames.sort();
        }
        return objNames;
    }


/*    private List<SelectOption> initObjNames() {
        List<SelectOption> objNames = new List<SelectOption>();
        objNames.add(new SelectOption('blank', '--Select Object--'));
        List<String> str = new List<String>(schemaMap.keySet());
        str.sort();
        for(String ss : str) {
            objNames.add(new SelectOption(ss,ss));
        }
        return objNames;
    }    */



// Find the InrField for the selected object

    public void showFields() {
     //   InrField.clear();
        if(selectedObject != 'blank') {
            Map <String, Schema.SObjectField> fieldMap = schemaMap.get(selectedObject).getDescribe().fields.getMap();
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
            showTable = true;
            showButton = true;
            displayPB2 = true;
         } 
         else {
            showTable = false; 
            showButton = false;
            displayPB2 = false;
         }  
    }
        
    public PageReference exportData() {
        PageReference pf = new PageReference('/apex/ObjectFetch6');
        pf.getParameters().put('objVal', selectedObject);
        pf.setRedirect(true);
        return pf;
        // return Page.ObjectFetch5;
    }    

    public class InrPair {
        public String label {get; set;}
        public String name {get; set;}
        public string type {get; set;}
        public string cust {get; set;}
        public string digit {get; set;}
    }
}