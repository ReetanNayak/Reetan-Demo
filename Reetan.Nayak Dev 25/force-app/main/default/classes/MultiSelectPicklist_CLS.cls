public with sharing class MultiSelectPicklist_CLS {
     
    //Holds the list of selected values (ids) in the left list box
    public List<String> leftSelectedValues {get; set;}
    //Holds the list of selected values (ids) in the right list box
    public List<String> rightSelectedValues {get; set;}

    //Holds the list of all values  (ids,values) in the left list box
    public List<SelectOption> LeftListValues { get;set;}
    //Holds the list of all values  (ids,values) in the right list box
    public List<SelectOption> RightListValues { get;set;}
  
    
    List<String> selectedFields = new List<String>{'Name','IsDeleted','Sic','Rating','BillingCity','Id'};
    
    //constructor, fetch all the account fields and fill in the left list box
    // move selectedFields from left list box to right list box.
    public MultiSelectPicklist_CLS() {
        Map<String, Schema.SObjectField> mapField = Schema.SObjectType.Account.fields.getMap();  
        LeftListValues = new List<SelectOption>();
        RightListValues = new List<SelectOption>();
        SelectOption SO;
        for(String str:mapField.KeySet() ) {
            SO = new SelectOption(mapField.get(str).getDescribe().getName(),mapField.get(str).getDescribe().getLabel());
            LeftListValues.add(SO);
        } 
        addToRight(selectedFields); 
    }   
     
    // method used to move selected left list box values to right list box.
    private void addToRight(List<String> selectedCols){
        for (Integer i=0; i<selectedCols.size(); i++)
        {
            for (Integer j=0;j<LeftListValues.size();j++)
            { 
                if (selectedCols[i] == LeftListValues[j].getValue())
                {
                    RightListValues.add(LeftListValues[j]);
                    LeftListValues.remove(j--);
                    break; 
                }
            }
        }
    }
    
    
    // method used to move selected right list box values to left list box.
    private void addToLeft(List<String> selectedCols){
        for (Integer i=0; i<selectedCols.size(); i++)
        {
           for (Integer j =0;j<RightListValues.size();j++)
           { 
                if (selectedCols[i] == RightListValues[j].getValue()){
                   LeftListValues.add(RightListValues[j]);
                   RightListValues.remove(j--);
                   break; 
                }
           }
        }    
     }
       
  
    // method used to move selected right list box values to Top.
    // if ToTop is true then move the selected values to Top most.
    // else move the selected values to one position up.
     private void moveColsTop(List<String> selectedCols,boolean ToTop){
        Integer k=0;
           for (Integer i=0; i< selectedCols.size(); i++){
               for (Integer j =0;j<RightListValues.size();j++)
                { 
                    if (selectedCols[i] == RightListValues[j].getValue())
                    {
                       if (ToTop) { 
                           RightListValues.add(k++,RightListValues[j]);
                           RightListValues.remove(j+1);
                       } else {
                           if (j>0){
                               RightListValues.add(j-1,RightListValues[j]);
                               RightListValues.remove(j+1);
                            }
                       }
                       break; 
                    }
                }
            }
    }

    // method used to move selected right list box values to Bottom.
    // if ToBottom is true then move the selected values to Bottom most.
    // else move the selected values to one position down.
    private void moveColsBottom(List<String> selectedCols,boolean ToBottom){
           Integer RightListSize = RightListValues.size() -1;
           Integer listsize;
           for (Integer i=0; i< selectedCols.size(); i++)
           {  
               listsize = RightListSize;
               for (Integer j=listsize; j>=0 ; j--)
                { 
                    if (selectedCols[i] == RightListValues[j].getValue()){
                        if (ToBottom){
                           RightListValues.add(RightListValues[j]);
                           RightListValues.remove(j);
                        } else {
                           if (j==listsize-1){
                               RightListValues.add(RightListValues[j]);
                               RightListValues.remove(j);
                           }
                           else if (j<listsize){
                               RightListValues.add(j+2,RightListValues[j]);
                               RightListValues.remove(j);
                           }
                        }
                       break; 
                    }
                }
           }
    }
    
   

    public void assignRight(){
        addToRight(leftSelectedValues);
    }

    public void assignLeft(){
        addToLeft(rightSelectedValues);
    }

    public void moveToTop() {
        moveColsTop(rightSelectedValues,true);
    }
     
    public void moveToBottom() {
      moveColsBottom(rightSelectedValues,true);
    }    
    

    public void moveOneUp() {
        moveColsTop(rightSelectedValues,false);
    }
     
    public void moveOneBottom() {
      moveColsBottom(rightSelectedValues,false);
    }    

 
}