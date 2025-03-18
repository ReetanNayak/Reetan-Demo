/** 
* @author Original: developerForce.com, Last Modified: GlobalOne - Jesfer Baculod GEHC  
* @date Original: 11 Apr 2012, Last Modified: 17 Apr 2012 
* @description Class for sorting lists: (http://wiki.developerforce.com/page/Sorting_Tables)   
*/ 
public class superSort {

    /*This method takes 3 arguments, the List of objects to sort, the field to sort, 
    and the order, asc or desc*/
    
    /** 
  * @author Original: developerForce.com, Last Modified: GlobalOne - Jesfer Baculod GEHC  
  * @date Original: 11 Apr 2012, Last Modified: 17 Apr 2012 
  * @description method that will be called to sort lists by clicking the header columns from the VF page
  * @param items A collection of object to be sorted (Account, Contact, Opportunity)
  * @param sortField the column field that will be sorted
  * @param order tells what order the sort will be (ascending or descending)   
  */ 
    
    public static void sortList(List<sObject> items, String sortField, String order){
        /*I must give credit where it is due as the sorting algorithm I am using is the 
        one supplied by Andrew Waite here: http://blog.sforce.com/sforce/2008/09/sorting-collect.html */
        
        Boolean isSortFieldReference = false;
        Map<Id,String> referenceName;
         
        /*Determine the type of the field that needs to be sorted, if it is a 
        reference we will want sort by the name of the related object, not the 
        ID itself*/
        if(items[0].getSObjectType().getDescribe().fields.getMap().get(sortField).getDescribe().getType().Name() == 'REFERENCE'){
            isSortFieldReference = true;
            referenceName = new Map<Id,String>();
            
            /*Determine the type of this object and populate the Id to Name map*/
            Set<Id> referenceIds = new Set<Id>();
            for(sObject s : items){
               referenceIds.add((Id)s.get(sortField));
            }
           
            List<Schema.Sobjecttype> objType = items[0].getSObjectType().getDescribe().fields.getMap().get(sortField).getDescribe().getReferenceTo();
            String objectType = objType[0].getDescribe().getName();

            //Query the related objects for the name and populate the Id -> Name map
            String queryString = 'select Id, Name from ' + objectType + ' where ID IN :referenceIDs';
            for(sObject s : Database.query(queryString )){
                if (s.get('Name') == null) {
                    referenceName.put((Id)s.get('Id'), 'n/a');
                } else {
                    referenceName.put((Id)s.get('Id'),(String)s.get('Name'));
                }
            }
        }
                
        //Declare a list that will contain the sorted results
        List<cObject> resultList = new List<cObject>();
    
        //Create a map that can be used for sorting 
        Map<object, List<cObject>> objectMap = new Map<object, List<cObject>>();
        
        for(sObject ob : items){
            if(isSortFieldReference == false){
                if(objectMap.get(ob.get(sortField)) == null){ 
                    objectMap.put(ob.get(sortField), new List<cObject>()); 
                }
                cObject o = new cObject(ob);
                objectMap.get(ob.get(sortField)).add(o);
            }else{
                if(objectMap.get(referenceName.get((Id)ob.get(sortField))) == null){ 
                    objectMap.put(referenceName.get((Id)ob.get(sortField)), new List<cObject>()); 
                }
                cObject o = new cObject(ob);
                objectMap.get(referenceName.get((Id)ob.get(sortField))).add(o);
            }
        }
        
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
        
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
        
        //Apply the sorted values to the source list
        items.clear();
        if(order.toLowerCase() == 'asc'){
            for(cObject ob : resultList){
                items.add(ob.obj);  
            }
        }else if(order.toLowerCase() == 'desc'){
            for(integer i = resultList.size()-1; i >= 0; i--){
                items.add(resultList[i].obj);   
            }
        }
    }
    
    /** 
  * @author Original: developerForce.com, Last Modified: GlobalOne - Jesfer Baculod GEHC  
  * @date Original: 11 Apr 2012, Last Modified: 17 Apr 2012 
  * @description wrapper class for displaying the result of the sort 
  */ 
    
    public class cObject{
        sObject obj {get; set;}
        
        public cObject(sObject obj){
            this.obj = obj; 
        }
    }
    
}