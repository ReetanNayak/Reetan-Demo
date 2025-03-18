public class Coupon_Validation_CLS {
public string strCoupon{get; set;}
public string SelectLocation {get; set;}
public boolean boolflag {get; set;}
public boolean boolflag2 {get; set;}
public list<UB_Coupon__c> lstcoup;
public list<User> lstobjuser;
public string strMsg{get; set;}

    public  Coupon_Validation_CLS(){
        lstobjuser = [SELECT Id,Name, Contact.Id, Contact.Name,Contact.AccountId FROM User where Id =:UserInfo.getUserId()];
    }


    public PageReference doCheck() {

        if(strCoupon != '' && strCoupon != null ) {
            lstcoup=[select Id,UB_Valid__c,UB_Valid_From__c,UB_Valid_To__c,UB_Redeemed__c,UB_CampaignMember__c,UB_CampaignMember__r.UB_Redeemed__c,UB_Outlet__c,UB_Location__c, UB_Redeem_On__c from UB_Coupon__c where Name=:strCoupon];

            //date validFrm = date.newInstance( lstcoup[0].UB_Valid_From__c.year(),lstcoup[0].UB_Valid_From__c.month(),lstcoup[0].UB_Valid_From__c.day());
            //date validTo = date.newInstance( lstcoup[0].UB_Valid_To__c.year(),lstcoup[0].UB_Valid_To__c.month(),lstcoup[0].UB_Valid_To__c.day());
            //date today = date.newInstance(System.today().year(),System.today().month(),System.today().day());

            if(lstcoup.size()>0) {

                if(lstcoup[0].UB_Redeemed__c == true) {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry your Coupon is already Redeemed !' );
                    ApexPages.addMessage(msg);
                }
                else if(lstcoup[0].UB_Valid__c == false) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry your coupon is expired!' );
                ApexPages.addMessage(msg);
                }
                
                else if(lstcoup[0].UB_Outlet__c != lstobjuser[0].Contact.AccountId) {
                if(lstobjuser[0].Contact.AccountId == null || lstobjuser[0].Contact.AccountId == ''){
                    system.debug('check++++++++++++++'+lstcoup[0].UB_Outlet__c);
                    system.debug('check+++++4444444444+++++++++'+lstobjuser[0].Contact.AccountId);
                    ApexPages.Message msg1 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Login as Partner to Redeem the Coupon.' );
                    ApexPages.addMessage(msg1);
                    }
                    else{
                     ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry your coupon is invalid for this outlet. Please check your outlet !' );
                     ApexPages.addMessage(msg2);
                    }
                    
                }
                else {
                    boolflag = true;
                }
            return null;
            }
        }
        else {
            ApexPages.Message msg2 = new ApexPages.Message(ApexPages.Severity.INFO, 'Please enter Coupon Number !' );
            ApexPages.addMessage(msg2);
        }  
    return null;
    }
    
   public void doRedeem() {
        if(lstcoup.size()>0) {
            lstcoup[0].UB_Redeemed__c = true;
            lstcoup[0].UB_CampaignMember__r.UB_Redeemed__c = true;
            lstcoup[0].UB_Redeem_On__c = System.Today();
            
            update lstcoup[0].UB_CampaignMember__r;
            update lstcoup[0];
            strMsg = 'Successfully Redeemed';
            boolflag2 = true;         
        }
    }

}