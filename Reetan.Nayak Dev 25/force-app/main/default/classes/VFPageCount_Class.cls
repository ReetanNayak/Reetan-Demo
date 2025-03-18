public class VFPageCount_Class {

    public VFPageCount_Class(ApexPages.StandardController controller) {

    }

    public decimal viewCount {get; set;}

    public void countVF() {
        Modality__c VFC = [Select Id, Total_Count__c from Modality__c];
        if(VFC != null){
            VFC.Total_Count__c = VFC.Total_Count__c + 1;
            viewCount = VFC.Total_Count__c;
            //
        } 
        update VFC;
    }

    
    
}