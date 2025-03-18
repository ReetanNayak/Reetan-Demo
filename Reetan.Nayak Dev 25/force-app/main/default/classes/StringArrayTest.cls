public class StringArrayTest {
    public static List<String> generateStringArray (Integer n){
        
        List<String> myList = new List<String>();
        for(Integer i=0; i<n; i++){
            myList.add('Test '+i);
         }   System.debug('Reetan Test... '+ myList );   
        //}
        return myList;
    }

}


// StringArrayTest.generateStringArray(5);