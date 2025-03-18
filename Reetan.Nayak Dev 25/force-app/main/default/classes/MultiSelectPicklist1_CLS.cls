public class MultiSelectPicklist1_CLS {

public Map<String, Schema.SObjectField> mapField {get; set;}
public List<String> accfield{get;set;}

    public MultiSelectPicklist1_CLS(){
        accfield=new List<String>();
        accfield.sort();
        mapField = Schema.SObjectType.Account.fields.getMap();  
        for(String str:mapField.KeySet() ) {
            accfield.add(mapField.get(str).getDescribe().getLabel());
        }
    }
}