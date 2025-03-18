Public Class Coupon_View_CLS {

Public string strCouPonID;
Public UB_Coupon__c Coupon {get; set;}

    Public Coupon_View_CLS() {

    strCouPonID = ApexPages.currentPage().getParameters().get('id');
    system.debug('<<<<<<<<<< ' + strCouPonID );
     /* list<UB_Coupon__c> lstCoupon = [select id,UB_Brand__c,UB_Contact__r.Name,UB_Coupon_Number__c,UB_Location__c,UB_Outlet__r.name from UB_Coupon__c where id =:strCouPonID ];

    if(lstCoupon > 0)
    strName=lstCoupon[0].UB_Brand__c;
    */

    /*strUbslCouPonNumber=
    strBrandName=
    strProduct=
    strCouPonID=
    */
    // Coupon = [select id,UB_Brand__c,UB_Contact__r.Name,UB_Coupon_Number__c,UB_Location__c,UB_Outlet__r.name from UB_Coupon__c where id =:strCouPonID ];

        if (strCouPonID != null) {
           Coupon = [select id, QR_image__c,QR_Image_Url__c, QR_URL__c, UB_Brand__c, UB_CampaignMember__r.Name, UB_Coupon_Number__c, UB_Location__c, UB_Product__r.Name, UB_Outlet__r.name, UB_Valid_From__c, UB_Valid_To__c from UB_Coupon__c where id =:strCouPonID ]; 
        }
    }

}