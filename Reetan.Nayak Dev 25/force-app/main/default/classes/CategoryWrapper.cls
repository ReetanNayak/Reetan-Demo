public class CategoryWrapper {
 
    public string strFieldName{ get; set; }
    public string strFieldValue{ get; set;}
    public boolean valChecked { get; set; }
 
    public CategoryWrapper(){
    strFieldName = null;
    strFieldValue = null;  
    valChecked  = false; 
    }
 
    public CategoryWrapper(string strName, string strValue){
     strFieldName = strName;
     strFieldValue = strValue;
      valChecked =false; 
    }
    
    
    
  }