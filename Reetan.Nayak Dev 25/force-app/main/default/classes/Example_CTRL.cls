public class Example_CTRL {
 public  Integer count {get;set;}
 Public list<contact> ct {get;set;}    
                   
    public pagereference incrementCounter() {
           count =0;
           count=count+1;
           
        return null;
    } 
    
    Public pagereference condata() {
        ct=[select id,name,Phone,Email from contact ];
        
        return null;
    }
                    
    /*public Integer getCount() {
        return count;
    }*/
}