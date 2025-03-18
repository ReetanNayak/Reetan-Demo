public class SaiPage2_CLS {
public Boolean pb1{get; set;}
public Boolean pb2{get; set;}

    public SaiPage2_CLS() {
        pb1 = false;
        pb2 = false;
    }
    
    public void ABCD(){
       pb1 = true;
       pb2 = false;
    }

    public void PQRS(){
       pb1 = false;
       pb2 = true;
    }    
    
}