public class Coupon_Registration_CLS {

public UB_Coupon__c coup {get;set;}

public string strName{get; set;}
public string strEmail{get; set;}
public string strPhone{get; set;}
public string strAddress{get; set;}

public string SelectBrand {get; set;}
public string SelectProduct {get; set;}
public string SelectLocation {get; set;}
public string SelectOutlet {get; set;}
Public string strCampaign {get;set;}

// public string coupID;

Map<string, Account> mpOutlet = new Map<string, Account>();
Map<string, Product2> mpProd = new Map<string, Product2>();

    public Coupon_Registration_CLS() {
        coup = new UB_Coupon__c();
        strCampaign = ApexPages.currentPage().getParameters().get('id');
    }


    public List<SelectOption> getBrandName() {
       
        List<SelectOption> optBrand = new List<SelectOption>();
        optBrand.add(new SelectOption('', '--Select--'));        
        Schema.DescribeFieldResult fieldResult1 = Product2.UB_Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult1.getPicklistValues();
        
        for(Schema.PicklistEntry f : ple) {
            optBrand.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return optBrand;
    }

    public List<SelectOption> getProductName() {
        List<SelectOption> listProduct = new List<SelectOption>();
    
        if(SelectBrand != '--Select--' && SelectBrand != '' && SelectBrand != null)  {
            List<Product2> listProd2 = [SELECT Id, Name, ProductCode, UB_Brand__c FROM Product2  where UB_Brand__c =:SelectBrand  order by Name];
                listProduct.add(new SelectOption('', '--Select--'));
                for(Product2 pr2 : listProd2) {
                    listProduct.add(new SelectOption(pr2.Id, pr2.Name));
                    mpProd.put(pr2.id, pr2);
                }         
        }  
        else {                
            listProduct.add(new SelectOption('', '--None--'));
        }      
        return listProduct;
    }    


    public List<SelectOption> getLocationName() {
       
        List<SelectOption> optLoc = new List<SelectOption>();
        optLoc.add(new SelectOption('', '--Select--'));        
        Schema.DescribeFieldResult fieldResult2 = UB_Coupon__c.UB_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult2.getPicklistValues();
        
        for(Schema.PicklistEntry ff : ple) {
            optLoc.add(new SelectOption(ff.getLabel(), ff.getValue()));
        }       
        return optLoc;
    }


    public List<SelectOption> getOutletName() {
        List<SelectOption> listOutlet = new List<SelectOption>();
        
        if(SelectLocation != '--Select--' && SelectLocation != '' && SelectLocation != null)  {
            List<Account> lstAcc = [SELECT Id, Name, UB_Location__c FROM Account where UB_Location__c =:SelectLocation order by Name ];
            listOutlet.add(new SelectOption('', '--Select--'));
            for(Account acc:lstAcc) {
                listOutlet.add(new SelectOption(acc.Id, acc.Name));
                mpOutlet.put(acc.id, acc);
            }
        }
        else {                
            listOutlet.add(new SelectOption('', '--None--'));
        }          
        return listOutlet;
    }



    public PageReference doSubmit() {
      List<UB_Campaign_Member__c> lstCampMember = [SELECT Id, Name, UB_Email__c, UB_Mobile__c, UB_Address__c, UB_Redeemed__c FROM UB_Campaign_Member__c where UB_Email__c=:strEmail OR UB_Mobile__c=:strPhone ];

        if(lstCampMember.size()> 0) {
            system.debug('+++555555555555555++++++');
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'You are already Registered' );
            ApexPages.addMessage(msg);
            return null;
        } 
       
        else {
            system.debug('+++333333333333333++++++');
          /*  if(strEmail == '' && strPhone == '' && SelectBrand == '' || SelectBrand == null && SelectLocation == '' || SelectLocation == null ) {
                ApexPages.Message msgAll = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter the Required Fields' );
                ApexPages.addMessage(msgAll);
                return null;            
            }   */
          //  else { 
                if(strEmail == '' ) {
                    ApexPages.Message msgMail = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter the:  Email Id' );
                    ApexPages.addMessage(msgMail);
                    return null;
                }
                else {
                    String isMail = '[a-zA-Z0-9\\.\\!\\#\\$\\%\\&\\*\\/\\=\\?\\^\\_\\+\\-\\`\\{\\|\\}\\~\'._%+-]+@[a-zA-Z0-9\\-.-]+\\.[a-zA-Z]+';
                    Boolean validMail = Pattern.matches(isMail, strEmail);
                    if(validMail == false) {
                        ApexPages.Message msgMail = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Valid Email Id like:  "abc@xyz .com" ' );
                        ApexPages.addMessage(msgMail);
                        return null;   
                    }             
                }
                
                if(strPhone == '' ) {
                    ApexPages.Message msgPhone = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter the:  Mobile No' );
                    ApexPages.addMessage(msgPhone);
                    return null;
                }
             /*   else {
                    Pattern phoneFormat = '((\(\d{3}\))|(\d{3}-))\d{3}-\d{4}';
                    if(!phoneFormat.match(strPhone)) {
                        ApexPages.Message msgMob = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Enter Valid:  Mobile No' );
                        ApexPages.addMessage(msgMob);                   
                    }
                }    */
                
             /*   else {
                    String regexFormat = '^$(?([0-9]{3})$)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$';  
                    Pattern phoneFormat = Pattern.Compile(regexFormat);  
                  
                    Matcher numberMatch = phoneFormat.matcher(strPhone);  
                   
                    if (!numberMatch.matches()) {
                        ApexPages.Message msgMob = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Enter Valid:  Mobile No' );
                        ApexPages.addMessage(msgMob);               
                    }
                }   */


                if(SelectBrand == '' || SelectBrand == null) {
                System.debug('coup.UB_Brand__c........... ' + SelectBrand );
                    ApexPages.Message msgBrand = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the:  Brand' );
                    ApexPages.addMessage(msgBrand);
                    return null;            
                }    

                if(SelectLocation == '' || SelectLocation == null) {
                    ApexPages.Message msgLocation = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the:  Location' );
                    ApexPages.addMessage(msgLocation);
                    return null;            
                }     
                 if(SelectProduct == '' || SelectProduct == null) {
                    ApexPages.Message msgLocation = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the:  Product' );
                    ApexPages.addMessage(msgLocation);
                    return null;            
                }   
                else{}  
                 if(SelectOutlet == '' || SelectOutlet == null) {
                    ApexPages.Message msgLocation = new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the:  Outlet' );
                    ApexPages.addMessage(msgLocation);
                    return null;            
                }   
                else{}    
          //  }
            
                try {
                    system.debug('m here+++++++++++++++++++');
                    system.debug('outlet+++++++++++++++++++'+SelectOutlet);
                    system.debug('product+++++++++++++++++++'+SelectProduct);
                    system.debug('brand+++++++++++++++++++'+SelectBrand);
                    
              
              
                    
                    system.debug('+++&&&&&&&&&&&&&&&&&&'+mpOutlet.get(SelectOutlet).Id);
                    UB_Campaign_Member__c UBCampMemObj = new UB_Campaign_Member__c (UB_Outlet__c=mpOutlet.get(SelectOutlet).Id, Name=strName,UB_Campaign__c = '70130000001toqR', UB_Email__c=strEmail, UB_Mobile__c=strPhone, UB_Address__c=strAddress);
                    insert UBCampMemObj;
                    
                    this.coup.UB_Product__c = mpProd.get(SelectProduct).Id;
                    this.coup.UB_Outlet__c = mpOutlet.get(SelectOutlet).Id;
                    this.coup.UB_Brand__c = SelectBrand;
                    this.coup.UB_Location__c = SelectLocation;
                    this.coup.UB_Campaign__c = '70130000001toqR';
                    this.coup.UB_CampaignMember__c = UBCampMemObj.Id;
                    this.coup.UB_Valid_From__c = System.Today();
                //    coupID = this.coup.id;
                    insert this.coup;
                }
                catch(exception e) { system.debug('exception'+e); }
            PageReference pageRef = new PageReference('/apex/Coupon_View?id='+this.coup.id);
      //      PageReference pageRef = new PageReference('/apex/Coupon_View?id='+ coupID);            
            system.debug('>>>>>>>>>>>>>> ' + pageRef);
            return pageRef;
        }
       return null;
    }
 
}