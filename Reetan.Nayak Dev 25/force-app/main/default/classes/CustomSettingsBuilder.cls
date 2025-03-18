/**
* @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC  Last Modifid: Andy Ognenoff (212068520)/GEHC
* @date Original: 14 Jun 2012 Last Modified: 13 Jun 2013
* @description Global utility class that contains different record builders for custom setting.
*/
public class CustomSettingsBuilder{
    
    public static List<IB_Source__c> ibSourceList = new List<IB_Source__c>();
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Andy Ognenoff (212068520) GEHC
    * @date Original: 25 Jun 2012 Last Modified: 13 Jun 2013
    * @description Helper method to return Test User Profile Name replacing the Test Account custom setting.
    */
    
    public String getUtilAccountManagerProfileId(){
        Profile p = [select pf.id from profile pf WHERE pf.name= 'GEHC Account Manager (Test Only)' limit 1];
        return p.Id;
    }
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return Test User CRM Team Member Profile Name.
    */
    
    public String getUtilTeamMemberProfileId(){
        Profile p = [select pf.id from profile pf WHERE pf.name= 'GEHC CRM Team Member' limit 1];
        return p.Id;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC 
    * @date Original: 21 Nov 2012
    * @description Helper method to return Test User System Administrator Profile Name.
    */
    
    public String getUtilSysAdminProfileId(){
        Profile p = [select pf.id from profile pf WHERE pf.name= 'System Administrator' limit 1];
        return p.Id;
    }


    /**
    * @author Original: Swapna Vasagiri (502068421) TCS/GEHC 
    * @date Original: 31 May 2013
    * @description Helper method to return Test User SalesReps Role Name.
    */
    
    public String getUtilSalesRepsRoleId(){
        UserRole r = [select ro.id from UserRole ro WHERE ro.name= 'Sales Reps' limit 1];
        return r.Id;
    }
    
    /**
    * @author Original: Swapna Vasagiri (502068421) TCS/GEHC 
    * @date Original: 31 May 2013
    * @description Helper method to return Test User Management Role Name.
    */
    
    public String getUtilManagementRoleId(){
        UserRole r = [select ro.id from UserRole ro WHERE ro.name= 'Management' limit 1];
        return r.Id;
    }
        
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return Test GEHC Admin replacing the general custom setting.
    */
    
    public String getUtilGEHCAdminId(){
        User u = [select u.id from user u where u.FirstName = 'GEHC' And u.LastName = 'Admin' And u.IsActive = true limit 1];
        return u.Id;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 03 May 2013
    * @description Helper method to return Test Chatter Free User Profile Name replacing the Test Account custom setting.
    */
    
    public String getUtilChatterFreeProfileId(){
        Profile p = [select pf.id from profile pf WHERE pf.name= 'Chatter Free User' limit 1];
        return p.Id;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return Default Price Book Name.
    */
    
    public String getUtilDefaultPriceBook(){
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book');
        insert pb;
        return pb.Id;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 30 Jan 2013, Last Modified: Mar 6, 2013
    * @description Helper method to return Call Tracking  Record Type Id of Event 
    */
    
    public String getUtilCallTrackingRecTypeId(){
        Id RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get(Label.RecType_Event_CallTracking).getRecordTypeId();
        return RecordTypeId;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 31 Jan 2013, Last Modified: Mar 6, 2013
    * @description Helper method to return Standard Record Type Id of Event 
    */
    
    public String getUtilStandardEvtRecTypeId(){
        Id RecordTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        return RecordTypeId;
    }
  
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 14 Feb 2013
    * @description Helper method to return Team Member Role Secondary Owner
    */
    
    public String getRoleSecondaryOwner(){
        return 'Secondary Owner';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return Ascending Sort Image URL replacing the my favorites custom setting.
    */
    
    public String getAscSortImageURL(){
        return '/resource/sortArrows/sortArrows_ASC.png';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return Descending Sort Image URL replacing the my favorites custom setting.
    */
    
    public String getDescSortImageURL(){
        return '/resource/sortArrows/sortArrows_DESC.png';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return static Opportunity Open Step value
    */
    
    public String getOpportunityOpenStep(){
        return '1. Understand Customer';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return static Opportunity Won Step value
    */
    
    public String getOpportunityWonStep(){
        return '7. Closed Won - Implement';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 25 Jun 2012 Last Modified: 05 July 2012
    * @description Helper method to return static Opportunity Lost Step value
    */
    
    public String getOpportunityLostStep(){
        return 'Closed - Lost';
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Swapna Vasagiri (502207647) TCS/GEHC
    * @date Original: 18 Jun 2012 Last Modified: 14 May 2013
    * @description Helper method to re-create account team audit trail custom setting
    */
    
    public void buildAccountTeamAuditTrailSetting(){
        Account_Team_Audit_Trail_Settings__c atat = new Account_Team_Audit_Trail_Settings__c();
        
        
        atat.Account_Creator_Batch_Source__c = 'User Interface';
        atat.Account_Original_Owner_Default_Role__c = 'Team Member';
        atat.Add_Action_Text__c = 'Add';
        atat.Case_Access_Level__c = 'None';
        atat.Default_Batch_Source__c = 'DRM Integration';
        atat.Error_Code_Invalid_Action__c = 'Invalid Action';       
        atat.Error_Code_Invalid_Role__c = 'InvalidRole';
        atat.Error_Code_Missing_Account_Team__c = 'MissingAccountTeam';
        atat.Error_Code_Missing_UCM_Commercial_ID__c = 'MissingUCMCommercialID';
        atat.Error_Code_Missing_Action__c = 'MissingAction';
        atat.Error_Code_Missing_New_User_SSO__c = 'MissingNewUserSSO';
        atat.Error_Code_Inactive_New_User__c = 'InactiveNewUser';
        atat.Error_Code_Invalid_New_User__c = 'InvalidNewUser';
        atat.Error_Code_Missing_Old_User_SSO__c = 'MissingOldUserSSO';
        atat.Error_Code_Missing_Role__c = 'MissingRole';
        atat.Error_Code_No_UCM_Match__c = 'NoUCMMatch';
        atat.Error_Code_No_Commercial_ID_Match__c = 'NoCommercialIDMatch';
        atat.Error_Code_No_Matching_New_User__c = 'NoMatchingNewUser';
        atat.Error_Code_No_Matching_Old_User__c = 'NoMatchingOldUser';
        atat.Error_Code_Unhandled_Exception__c = 'UnhandledException';
        atat.Error_Message_Unhandled_Exception__c = 'An exception was encountered while processing this record.';
        atat.Exception_Email_Recipient__c = 'andy.ognenoff@ge.com';
        atat.Failure_Status__c = 'Failure';
        atat.Replace_Action_Text__c = 'Replace';
        atat.Success_Status__c = 'Success';
        atat.Remove_Action_Text__c = 'Remove';
        atat.SetupOwnerId = UserInfo.getOrganizationId();
        atat.Edit_Access_Level_Text__c = 'Edit';
        atat.Read_Access_Level_Text__c = 'Read';
        atat.Error_Code_Invalid_Account_Access_Level__c ='Invalid Account Access Level';
        atat.Error_Code_Invalid_Opp_Access_Level__c ='Invalid Opportunity Access Level';
        atat.None_Access_Level_Text__c='None';

        insert atat;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 18 Jun 2012
    * @description Helper method to re-create account team audit trail custom setting
    */
    
    public void buildAccountTeamAuditTrailTestSetting(){
        Account_Team_Audit_Trail_Test_Settings__c atatTest = new Account_Team_Audit_Trail_Test_Settings__c();
        
        atatTest.Test_Profile_Account_Manager__c = 'GEHC Account Manager';
        atatTest.Test_Role_Account_Executive__c = 'Account Executive (AE)';
        atatTest.Test_Role_Account_Manager__c = 'Account Manager (AM)';
        atatTest.Test_Role_Product_Sales_Specialist__c = 'Product Sales Specialist (PSS)';
        atatTest.SetupOwnerId = UserInfo.getOrganizationId(); 
        
        insert atatTest;
    }       

    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 20 Jun 2012
    * @description Helper method to re-create SDI Business Type custom setting
    */
    
    public void buildSDIBusinessTypeSetting(){
        List<SDI_Business_Type__c> bussTypeList = new List<SDI_Business_Type__c>();
        
        bussTypeList.add(new SDI_Business_Type__c(Name='DCC', Business_Type_Long_Name__c = 'Dialysis Centers Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DE', Business_Type_Long_Name__c = 'Dental Clinic/Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DI', Business_Type_Long_Name__c = 'Diagnostic Imaging Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DIC', Business_Type_Long_Name__c = 'Diagnostic Imaging Center Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DM', Business_Type_Long_Name__c = 'Durable Medical Equipment (DME) Outlet'));
        bussTypeList.add(new SDI_Business_Type__c(Name='EC', Business_Type_Long_Name__c = 'Employer Coalition'));
        bussTypeList.add(new SDI_Business_Type__c(Name='EG', Business_Type_Long_Name__c = 'Employer Group'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CM', Business_Type_Long_Name__c = 'Community Mental Health Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='EM', Business_Type_Long_Name__c = 'Employer Member'));
        bussTypeList.add(new SDI_Business_Type__c(Name='EP', Business_Type_Long_Name__c = 'Exclusive Provider Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='FC', Business_Type_Long_Name__c = 'Fertility Clinic'));
        bussTypeList.add(new SDI_Business_Type__c(Name='FQ', Business_Type_Long_Name__c = 'Federally-Qualified Health Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='GP', Business_Type_Long_Name__c = 'Group Purchasing Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='SP', Business_Type_Long_Name__c = 'Specialty Pharmacy'));
        bussTypeList.add(new SDI_Business_Type__c(Name='TP', Business_Type_Long_Name__c = 'Third Party Administrator'));
        bussTypeList.add(new SDI_Business_Type__c(Name='TR', Business_Type_Long_Name__c = 'Tissue Bank/Repository'));
        bussTypeList.add(new SDI_Business_Type__c(Name='UC', Business_Type_Long_Name__c = 'Urgent Care'));
        bussTypeList.add(new SDI_Business_Type__c(Name='UCC', Business_Type_Long_Name__c = 'Urgent Care Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='UN', Business_Type_Long_Name__c = 'Academic Institution'));
        bussTypeList.add(new SDI_Business_Type__c(Name='XX', Business_Type_Long_Name__c = 'Non-Healthcare/Non-Medical Facility'));
        bussTypeList.add(new SDI_Business_Type__c(Name='YY', Business_Type_Long_Name__c = 'Not Researched/Miscellaneous Facility'));
        bussTypeList.add(new SDI_Business_Type__c(Name='GV', Business_Type_Long_Name__c = 'Government Agency'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HA', Business_Type_Long_Name__c = 'Home Health Agency'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HAC', Business_Type_Long_Name__c = 'Home Health Agency Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HC', Business_Type_Long_Name__c = 'Hospice'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HCC', Business_Type_Long_Name__c = 'Hospice Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HM', Business_Type_Long_Name__c = 'Health Maintenance Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HMC', Business_Type_Long_Name__c = 'Health Maintenance Organization Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HO', Business_Type_Long_Name__c = 'Hospital'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HOC', Business_Type_Long_Name__c = 'Multi-Hospital System'));
        bussTypeList.add(new SDI_Business_Type__c(Name='HS', Business_Type_Long_Name__c = 'Health Service Plan'));
        bussTypeList.add(new SDI_Business_Type__c(Name='IF', Business_Type_Long_Name__c = 'Infirmary'));
        bussTypeList.add(new SDI_Business_Type__c(Name='IP', Business_Type_Long_Name__c = 'Independent Practice/Physician Association'));
        bussTypeList.add(new SDI_Business_Type__c(Name='LB', Business_Type_Long_Name__c = 'Laboratory (Clinical)'));
        bussTypeList.add(new SDI_Business_Type__c(Name='LP', Business_Type_Long_Name__c = 'Long Term Care Pharmacy Provider'));
        bussTypeList.add(new SDI_Business_Type__c(Name='LPC', Business_Type_Long_Name__c = 'Long Term Care Pharmacy Provider Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MA', Business_Type_Long_Name__c = 'State Medicaid Program'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MC', Business_Type_Long_Name__c = 'Managed Care Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MD', Business_Type_Long_Name__c = 'Physician/Not Researched'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MG', Business_Type_Long_Name__c = 'Management Service Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MH', Business_Type_Long_Name__c = 'Mental Health Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MI', Business_Type_Long_Name__c = 'Mobile Imaging'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MK', Business_Type_Long_Name__c = 'Medicare Risk HMO'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MM', Business_Type_Long_Name__c = 'Manufacturer'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MO', Business_Type_Long_Name__c = 'Mail Service Pharmacy'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MP', Business_Type_Long_Name__c = 'Medicare Risk PPO'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MR', Business_Type_Long_Name__c = 'Mental Retardation Facility'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MS', Business_Type_Long_Name__c = 'Miscellaneous Healthcare/Medical Facility'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MV', Business_Type_Long_Name__c = 'Medicare Advantage'));
        bussTypeList.add(new SDI_Business_Type__c(Name='MVC', Business_Type_Long_Name__c = 'Medicare Advantage Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='NH', Business_Type_Long_Name__c = 'Nursing Home'));
        bussTypeList.add(new SDI_Business_Type__c(Name='NHC', Business_Type_Long_Name__c = 'Nursing Home Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='NM', Business_Type_Long_Name__c = 'Non-Physician Medical Practice'));
        bussTypeList.add(new SDI_Business_Type__c(Name='NW', Business_Type_Long_Name__c = 'Integrated Healthcare Network'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OC', Business_Type_Long_Name__c = 'Office and Clinic of Chiropractic Medicine'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OD', Business_Type_Long_Name__c = 'Office and Clinic of Optometry'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OH', Business_Type_Long_Name__c = 'Own Use Home Health Agency'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OO', Business_Type_Long_Name__c = 'Organ Procurement Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OP', Business_Type_Long_Name__c = 'Office and Clinic of Podiatry'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OS', Business_Type_Long_Name__c = 'Outpatient Surgery Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='OSC', Business_Type_Long_Name__c = 'Outpatient Surgery Center Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PB', Business_Type_Long_Name__c = 'Pharmacy Benefit Manager'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PC', Business_Type_Long_Name__c = 'Medical Group Practice'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PCC', Business_Type_Long_Name__c = 'Medical Group Practice Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PD', Business_Type_Long_Name__c = 'Medicare Prescription Drug Plan'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PDC', Business_Type_Long_Name__c = 'Medicare Prescription Drug Plan Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PH', Business_Type_Long_Name__c = 'Pharmacy'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PHC', Business_Type_Long_Name__c = 'Pharmacy Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PO', Business_Type_Long_Name__c = 'Physician Hospital Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PP', Business_Type_Long_Name__c = 'Preferred Provider Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PPC', Business_Type_Long_Name__c = 'Preferred Provider Organization Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PPO', Business_Type_Long_Name__c = ''));
        bussTypeList.add(new SDI_Business_Type__c(Name='PS', Business_Type_Long_Name__c = 'Point of Service'));
        bussTypeList.add(new SDI_Business_Type__c(Name='PY', Business_Type_Long_Name__c = 'Physician Practice'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RC', Business_Type_Long_Name__c = 'Rural Health Clinic'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RE', Business_Type_Long_Name__c = 'Retail Clinic'));
        bussTypeList.add(new SDI_Business_Type__c(Name='REC', Business_Type_Long_Name__c = 'Retail Clinic Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RH', Business_Type_Long_Name__c = 'Rehabilitation Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RHC', Business_Type_Long_Name__c = 'Rehabilitation Center Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RP', Business_Type_Long_Name__c = 'Retail Pharmacy'));
        bussTypeList.add(new SDI_Business_Type__c(Name='RT', Business_Type_Long_Name__c = 'Rehabilitation Therapy'));
        bussTypeList.add(new SDI_Business_Type__c(Name='AD', Business_Type_Long_Name__c = 'Administrative Doctor\'s Office'));
        bussTypeList.add(new SDI_Business_Type__c(Name='AI', Business_Type_Long_Name__c = 'AIDS/HIV Treatment Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='AL', Business_Type_Long_Name__c = 'Assisted Living Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='ALC', Business_Type_Long_Name__c = 'Assisted Living Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='AS', Business_Type_Long_Name__c = 'Ambulance Service'));
        bussTypeList.add(new SDI_Business_Type__c(Name='BB', Business_Type_Long_Name__c = 'Blood Bank'));
        bussTypeList.add(new SDI_Business_Type__c(Name='BC', Business_Type_Long_Name__c = 'Board and Care'));
        bussTypeList.add(new SDI_Business_Type__c(Name='BM', Business_Type_Long_Name__c = 'Bone Marrow Donor Organization'));
        bussTypeList.add(new SDI_Business_Type__c(Name='BR', Business_Type_Long_Name__c = 'Birthing Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CA', Business_Type_Long_Name__c = 'Cancer Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CAC', Business_Type_Long_Name__c = 'Cancer Center Multi-Facility Chain'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CC', Business_Type_Long_Name__c = 'Multi-Facility Chain/Corporate Headquarters'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CH', Business_Type_Long_Name__c = 'Chemical Dependency Center'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CL', Business_Type_Long_Name__c = 'Clinic'));
        bussTypeList.add(new SDI_Business_Type__c(Name='CO', Business_Type_Long_Name__c = 'Corporate Office'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DB', Business_Type_Long_Name__c = 'Distributor'));
        bussTypeList.add(new SDI_Business_Type__c(Name='DC', Business_Type_Long_Name__c = 'Dialysis Center'));
        
        insert bussTypeList;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 20 Jun 2012
    * @description Helper method to re-create Stakeholder Relationship Map custom setting
    */
    
    public void buildStakeHolderMapSetting(){
        List<Stakeholder_Relationship_Map_Settings__c> stakeHolderMapList = new List<Stakeholder_Relationship_Map_Settings__c>();
        
        stakeHolderMapList.add(new Stakeholder_Relationship_Map_Settings__c(Name='Medium', Color__c = '#FFD600'));
        stakeHolderMapList.add(new Stakeholder_Relationship_Map_Settings__c(Name='Needs Development', Color__c = '#EE3324'));
        stakeHolderMapList.add(new Stakeholder_Relationship_Map_Settings__c(Name='Strong', Color__c = '#76B900'));
        
        insert stakeHolderMapList;
    }

    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 20 Jun 2012
    * @description Helper method to re-create Support custom setting
    */
    
    public void buildSupportSetting(){
        List<SupportSettings__c> supportList = new List<SupportSettings__c>();
        
        supportList.add(new SupportSettings__c(SetupOwnerId = UserInfo.getOrganizationId(), Support_Email__c = '501996026@ge.com'));
        
        insert supportList;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 14 Jun 2012 Last Modified: 11 Apr 2013
    * @description Helper method to re-create country list custom setting
    */
    
    public void buildCountryList(){
        
        List<Country_List__c> clsList = new List<Country_List__c>();
        
        clsList.add(new Country_List__c(Name = 'US',Country_Long_Name__c = 'United States', Global_Region__c = 'USCAN', Sub_Region__c = 'United States'));
        clsList.add(new Country_List__c(Name = 'CA', Country_Long_Name__c = 'Canada', Global_Region__c = 'USCAN', Sub_Region__c = 'Canada'));
        clsList.add(new Country_List__c(Name = 'AF', Country_Long_Name__c = 'Afghanistan', Global_Region__c = 'EAGM', Sub_Region__c = 'TCA', Page_Template__c = '2'));
        clsList.add(new Country_List__c(Name = 'AT', Country_Long_Name__c = 'Austria', Global_Region__c = 'EU', Sub_Region__c = 'EU', Page_Template__c = '1'));
        clsList.add(new Country_List__c(Name = 'JP', Country_Long_Name__c = 'Japan', Global_Region__c = 'APAC', Sub_Region__c = 'Japan'));
        
        insert clsList;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 14 Jun 2012 Last Modified: 20 Jun 2012
    * @description Helper method to re-create country list custom setting
    */
    
    public void buildStateList(){
        
        List<State_List__c> slsList = new List<State_List__c>();
        
        slsList.add(new State_List__c(Name='US-AL', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='AL', State_Province_Name__c = 'Alabama'));
        slsList.add(new State_List__c(Name='US-AK', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='AK', State_Province_Name__c = 'Alaska'));
        slsList.add(new State_List__c(Name='US-AZ', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='AZ', State_Province_Name__c = 'Arizona'));
        slsList.add(new State_List__c(Name='US-AR', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='AR', State_Province_Name__c = 'Arkansas'));
        slsList.add(new State_List__c(Name='US-CA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='CA', State_Province_Name__c = 'California'));
        slsList.add(new State_List__c(Name='US-CO', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='CO', State_Province_Name__c = 'Colorado'));
        slsList.add(new State_List__c(Name='US-CT', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='CT', State_Province_Name__c = 'Connecticut'));
        slsList.add(new State_List__c(Name='US-DE', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='DE', State_Province_Name__c = 'Delaware'));
        slsList.add(new State_List__c(Name='US-FL', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='FL', State_Province_Name__c = 'Florida'));
        slsList.add(new State_List__c(Name='US-GA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='GA', State_Province_Name__c = 'Georgia'));
        slsList.add(new State_List__c(Name='US-HI', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='HI', State_Province_Name__c = 'Hawaii'));
        slsList.add(new State_List__c(Name='US-ID', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='ID', State_Province_Name__c = 'Idaho'));
        slsList.add(new State_List__c(Name='US-IL', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='IL', State_Province_Name__c = 'Illinois'));
        slsList.add(new State_List__c(Name='US-IN', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='IN', State_Province_Name__c = 'Indiana'));
        slsList.add(new State_List__c(Name='US-IA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='IA', State_Province_Name__c = 'Iowa'));
        slsList.add(new State_List__c(Name='US-KS', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='KS', State_Province_Name__c = 'Kansas'));
        slsList.add(new State_List__c(Name='US-KY', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='KY', State_Province_Name__c = 'Kentucky'));
        slsList.add(new State_List__c(Name='US-LA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='LA', State_Province_Name__c = 'Louisiana'));
        slsList.add(new State_List__c(Name='US-ME', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='ME', State_Province_Name__c = 'Maine'));
        slsList.add(new State_List__c(Name='US-MD', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MD', State_Province_Name__c = 'Maryland'));
        slsList.add(new State_List__c(Name='US-MA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MA', State_Province_Name__c = 'Massachusetts'));
        slsList.add(new State_List__c(Name='US-MI', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MI', State_Province_Name__c = 'Michigan'));
        slsList.add(new State_List__c(Name='US-MN', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MN', State_Province_Name__c = 'Minnesota'));
        slsList.add(new State_List__c(Name='US-MS', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MS', State_Province_Name__c = 'Mississippi'));
        slsList.add(new State_List__c(Name='US-MO', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MO', State_Province_Name__c = 'Missouri'));
        slsList.add(new State_List__c(Name='US-MT', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MT', State_Province_Name__c = 'Montana'));
        slsList.add(new State_List__c(Name='US-NE', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NE', State_Province_Name__c = 'Nebraska'));
        slsList.add(new State_List__c(Name='US-NV', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NV', State_Province_Name__c = 'Nevada'));
        slsList.add(new State_List__c(Name='US-NH', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NH', State_Province_Name__c = 'New Hampshire'));
        slsList.add(new State_List__c(Name='US-NJ', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NJ', State_Province_Name__c = 'New Jersey'));
        slsList.add(new State_List__c(Name='US-NM', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NM', State_Province_Name__c = 'New Mexico'));
        slsList.add(new State_List__c(Name='US-NY', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NY', State_Province_Name__c = 'New York'));
        slsList.add(new State_List__c(Name='US-NC', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='NC', State_Province_Name__c = 'North Carolina'));
        slsList.add(new State_List__c(Name='US-ND', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='ND', State_Province_Name__c = 'North Dakota'));
        slsList.add(new State_List__c(Name='US-OH', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='OH', State_Province_Name__c = 'Ohio'));
        slsList.add(new State_List__c(Name='US-OK', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='OK', State_Province_Name__c = 'Oklahoma'));
        slsList.add(new State_List__c(Name='US-OR', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='OR', State_Province_Name__c = 'Oregon'));
        slsList.add(new State_List__c(Name='US-RI', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='RI', State_Province_Name__c = 'Rhode Island'));
        slsList.add(new State_List__c(Name='US-SC', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='SC', State_Province_Name__c = 'South Carolina'));
        slsList.add(new State_List__c(Name='US-SD', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='SD', State_Province_Name__c = 'South Dakota'));
        slsList.add(new State_List__c(Name='US-TN', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='TN', State_Province_Name__c = 'Tennessee'));
        slsList.add(new State_List__c(Name='US-TX', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='TX', State_Province_Name__c = 'Texas'));
        slsList.add(new State_List__c(Name='US-PA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='PA', State_Province_Name__c = 'Pennsylvania'));
        slsList.add(new State_List__c(Name='US-UT', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='UT', State_Province_Name__c = 'Utah'));
        slsList.add(new State_List__c(Name='US-VT', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='VT', State_Province_Name__c = 'Vermont'));
        slsList.add(new State_List__c(Name='US-VA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='VA', State_Province_Name__c = 'Virginia'));
        slsList.add(new State_List__c(Name='US-WA', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='WA', State_Province_Name__c = 'Washington'));
        slsList.add(new State_List__c(Name='US-WV', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='WV', State_Province_Name__c = 'West Virginia'));
        slsList.add(new State_List__c(Name='US-WI', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='WI', State_Province_Name__c = 'Wisconsin'));
        slsList.add(new State_List__c(Name='US-WY', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='WY', State_Province_Name__c = 'Wyoming'));
        slsList.add(new State_List__c(Name='US-AS', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='AS', State_Province_Name__c = 'American Samoa'));
        slsList.add(new State_List__c(Name='US-DC', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='DC', State_Province_Name__c = 'District of Columbia'));
        slsList.add(new State_List__c(Name='US-FM', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='FM', State_Province_Name__c = 'Federated States of Micronesia'));
        slsList.add(new State_List__c(Name='US-GU', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='GU', State_Province_Name__c = 'Guam'));
        slsList.add(new State_List__c(Name='US-MH', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MH', State_Province_Name__c = 'Marshall Islands'));
        slsList.add(new State_List__c(Name='US-MP', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='MP', State_Province_Name__c = 'Northern Mariana Islands'));
        slsList.add(new State_List__c(Name='US-PW', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='PW', State_Province_Name__c = 'Palau'));
        slsList.add(new State_List__c(Name='US-PR', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='PR', State_Province_Name__c = 'Puerto Rico'));
        slsList.add(new State_List__c(Name='US-VI', Country_ISO_Code__c = 'US', State_Province_Abbreviation__c ='VI', State_Province_Name__c = 'Virgin Islands'));
        slsList.add(new State_List__c(Name='CA-AB', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='AB', State_Province_Name__c = 'Alberta'));
        slsList.add(new State_List__c(Name='CA-BC', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='BC', State_Province_Name__c = 'British Columbia'));
        slsList.add(new State_List__c(Name='CA-MB', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='MB', State_Province_Name__c = 'Manitoba'));
        slsList.add(new State_List__c(Name='CA-NB', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='NB', State_Province_Name__c = 'New Brunswick'));
        slsList.add(new State_List__c(Name='CA-NL', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='NL', State_Province_Name__c = 'Newfoundland and Labrador'));
        slsList.add(new State_List__c(Name='CA-NT', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='NT', State_Province_Name__c = 'Northwest Territories'));
        slsList.add(new State_List__c(Name='CA-NS', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='NS', State_Province_Name__c = 'Nova Scotia'));
        slsList.add(new State_List__c(Name='CA-NU', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='NU', State_Province_Name__c = 'Nunavut'));
        slsList.add(new State_List__c(Name='CA-ON', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='ON', State_Province_Name__c = 'Ontario'));
        slsList.add(new State_List__c(Name='CA-PE', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='PE', State_Province_Name__c = 'Prince Edward Island'));
        slsList.add(new State_List__c(Name='CA-QC', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='QC', State_Province_Name__c = 'Quebec'));
        slsList.add(new State_List__c(Name='CA-SK', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='SK', State_Province_Name__c = 'Saskatchewan'));
        slsList.add(new State_List__c(Name='CA-YT', Country_ISO_Code__c = 'CA', State_Province_Abbreviation__c ='YT', State_Province_Name__c = 'Yukon'));
        
        insert slsList;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 26 Jun 2012
    * @description Helper method to re-create NETDET IP Addresses custom setting
    */
    
    public void buildNetworkDetectionAddressesSetting(){
        NETDET_IP_Addresses__c netdet = new NETDET_IP_Addresses__c();
        
        netdet.Name = '198.169.189.227';
        
        insert netdet;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 03 July 2012 Last Modified: 26 July 2012
    * @description Helper method to re-create Chatter custom setting for AutoUnfollow Opportunities batch job.
    */
    
    public void buildChatterSetting(){
        Chatter_Settings__c chat = new Chatter_Settings__c();
        
        chat.SetupOwnerId = UserInfo.getOrganizationId();
        chat.Auto_Unfollow_Opps_after_x_Days__c = 14;
        chat.Auto_Unfollow_Opps_Criteria_1__c = 'Closed';
        chat.Auto_Unfollow_Opps_Criteria_2__c = 'Closed - Duplicate';
        chat.Next_Step__c = '#nextstep';
        chat.Notes__c = '#notes';
        
        insert chat;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 21 Aug 2012 
    * @description Helper method to re-create Reminder Time list for creating tasks on Opportunity Close Wizard
    */
    
    public void buildReminderTimeList(){
        list <Reminder_Time_List__c> remtlist = new list <Reminder_Time_List__c>();
        
        remtlist.add(new Reminder_Time_List__c(Name = '12:00 AM', Minutes__c = '0'));
        remtlist.add(new Reminder_Time_List__c(Name = '12:30 AM', Minutes__c = '30'));
        remtlist.add(new Reminder_Time_List__c(Name = '1:00 AM', Minutes__c = '60'));
        remtlist.add(new Reminder_Time_List__c(Name = '1:30 AM', Minutes__c = '90'));
        remtlist.add(new Reminder_Time_List__c(Name = '2:00 AM', Minutes__c = '120'));
        remtlist.add(new Reminder_Time_List__c(Name = '2:30 AM', Minutes__c = '150'));
        remtlist.add(new Reminder_Time_List__c(Name = '3:00 AM', Minutes__c = '180'));
        remtlist.add(new Reminder_Time_List__c(Name = '3:30 AM', Minutes__c = '210'));
        remtlist.add(new Reminder_Time_List__c(Name = '4:00 AM', Minutes__c = '240'));
        remtlist.add(new Reminder_Time_List__c(Name = '4:30 AM', Minutes__c = '270'));
        remtlist.add(new Reminder_Time_List__c(Name = '5:00 AM', Minutes__c = '300'));
        remtlist.add(new Reminder_Time_List__c(Name = '5:30 AM', Minutes__c = '330'));
        remtlist.add(new Reminder_Time_List__c(Name = '6:00 AM', Minutes__c = '360'));
        remtlist.add(new Reminder_Time_List__c(Name = '6:30 AM', Minutes__c = '390'));
        remtlist.add(new Reminder_Time_List__c(Name = '7:00 AM', Minutes__c = '420'));
        remtlist.add(new Reminder_Time_List__c(Name = '7:30 AM', Minutes__c = '450'));
        remtlist.add(new Reminder_Time_List__c(Name = '8:00 AM', Minutes__c = '480'));
        remtlist.add(new Reminder_Time_List__c(Name = '8:30 AM', Minutes__c = '510'));
        remtlist.add(new Reminder_Time_List__c(Name = '9:00 AM', Minutes__c = '540'));
        remtlist.add(new Reminder_Time_List__c(Name = '9:30 AM', Minutes__c = '570'));
        remtlist.add(new Reminder_Time_List__c(Name = '10:00 AM', Minutes__c = '600'));
        remtlist.add(new Reminder_Time_List__c(Name = '10:30 AM', Minutes__c = '630'));
        remtlist.add(new Reminder_Time_List__c(Name = '11:00 AM', Minutes__c = '660'));
        remtlist.add(new Reminder_Time_List__c(Name = '11:30 AM', Minutes__c = '690'));
        remtlist.add(new Reminder_Time_List__c(Name = '12:00 PM', Minutes__c = '720'));
        remtlist.add(new Reminder_Time_List__c(Name = '12:30 PM', Minutes__c = '750'));
        remtlist.add(new Reminder_Time_List__c(Name = '1:00 PM', Minutes__c = '780'));
        remtlist.add(new Reminder_Time_List__c(Name = '1:30 PM', Minutes__c = '810'));
        remtlist.add(new Reminder_Time_List__c(Name = '2:00 PM', Minutes__c = '840'));
        remtlist.add(new Reminder_Time_List__c(Name = '2:30 PM', Minutes__c = '870'));
        remtlist.add(new Reminder_Time_List__c(Name = '3:00 PM', Minutes__c = '900'));
        remtlist.add(new Reminder_Time_List__c(Name = '3:30 PM', Minutes__c = '930'));
        remtlist.add(new Reminder_Time_List__c(Name = '4:00 PM', Minutes__c = '960'));
        remtlist.add(new Reminder_Time_List__c(Name = '4:30 PM', Minutes__c = '990'));
        remtlist.add(new Reminder_Time_List__c(Name = '5:00 PM', Minutes__c = '1020'));
        remtlist.add(new Reminder_Time_List__c(Name = '5:30 PM', Minutes__c = '1050'));
        remtlist.add(new Reminder_Time_List__c(Name = '6:00 PM', Minutes__c = '1080'));
        remtlist.add(new Reminder_Time_List__c(Name = '6:30 PM', Minutes__c = '1110'));
        remtlist.add(new Reminder_Time_List__c(Name = '7:00 PM', Minutes__c = '1140'));
        remtlist.add(new Reminder_Time_List__c(Name = '7:30 PM', Minutes__c = '1170'));
        remtlist.add(new Reminder_Time_List__c(Name = '8:00 PM', Minutes__c = '1200'));
        remtlist.add(new Reminder_Time_List__c(Name = '8:30 PM', Minutes__c = '1230'));
        remtlist.add(new Reminder_Time_List__c(Name = '9:00 PM', Minutes__c = '1260'));
        remtlist.add(new Reminder_Time_List__c(Name = '9:30 PM', Minutes__c = '1290'));
        remtlist.add(new Reminder_Time_List__c(Name = '10:00 PM', Minutes__c = '1320'));
        remtlist.add(new Reminder_Time_List__c(Name = '10:30 PM', Minutes__c = '1350'));
        remtlist.add(new Reminder_Time_List__c(Name = '11:00 PM', Minutes__c = '1380'));
        remtlist.add(new Reminder_Time_List__c(Name = '11:30 PM', Minutes__c = '1410'));
        
        insert remtlist;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 13 Sep 2012 
    * @description Helper method to re-create Opportunity Close to Future RecordType list settings for creating future opportunity from close wizard.
    */
    
    public void buildOppCloseToFutureRecordTypeSetting(){
        list<Opp_Close_To_Future_RecordType_Settings__c> closeOppToFutureRecTypeList = new list<Opp_Close_To_Future_RecordType_Settings__c>();
        
        closeOppToFutureRecTypeList.add(new Opp_Close_To_Future_RecordType_Settings__c(Name='Opportunity to Opportunity', Closing_Opp_RecordType__c='Opportunity', Future_Opp_RecordType__c='Opportunity'));
        closeOppToFutureRecTypeList.add(new Opp_Close_To_Future_RecordType_Settings__c(Name='Renewal to Term', Closing_Opp_RecordType__c='Renewal', Future_Opp_RecordType__c='Term Opportunity'));
        closeOppToFutureRecTypeList.add(new Opp_Close_To_Future_RecordType_Settings__c(Name='Term to Term', Closing_Opp_RecordType__c='Term Opportunity', Future_Opp_RecordType__c='Term Opportunity'));
        closeOppToFutureRecTypeList.add(new Opp_Close_To_Future_RecordType_Settings__c(Name='Warranty Conversion to Term', Closing_Opp_RecordType__c='Warranty Conversion', Future_Opp_RecordType__c='Term Opportunity'));
        
        insert closeOppToFutureRecTypeList;
    }
 
    
    /**
    * @author Original: Robby Angeles (502068424) Last Modifid: Swapna Vasagiri (502207647)GEHC
    * @date Original: 15 Nov 2012 Last Modifid: 10 May 2013
    * @description Helper method to re-create Object Tab Landing Page settings.
    */
    public void buildObjectTabLandingPageSetting(){
        Object_Landing_Page_Settings__c objTabSettings = new Object_Landing_Page_Settings__c();
        
        objTabSettings.Account_Tab_Landing_Page__c = 'https://gehealthcare.accounttabtest';
        objTabSettings.Opportunity_Tab_Landing_Page__c = 'https://gehealthcare.opportunitytabtest';
        objTabSettings.Contact_Relationship_Tab_Landing_Page__c = 'https://gehealthcare.contactreltabtest';
        objTabSettings.Lead_Tab_Landing_Page__c = 'https://gehealthcare.leadtabtest';
        
        insert objTabSettings;
    }
    
    /**
    * @author Original: Jesfer Baculod (502068421) Cloud Sherpas/GEHC
    * @date Original: 21 Nov 2012, Last Modified: 28 Nov 2012
    * @description Helper method to re-create Send Email To New Users settings.
    */
    public void buildSendEmailToUsersSetting(){
        
        list <EmailTemplate> etemp = [Select Id, Name From EmailTemplate Where Name like '%Welcome%' Order By Name];
        list <Send_Email_to_Users_Settings__c> SendEmailSettingsList = new list <Send_Email_to_Users_Settings__c>();
        
        //System Administrator : User - Admin: Send Email Template
        SendEmailSettingsList.add(new Send_Email_to_Users_Settings__c( SetupOwnerId = getUtilSysAdminProfileId(), Email_Template_ID__c = etemp[0].Id )  );
        //GEHC Account Manager : User - AM: Send Email Template
        SendEmailSettingsList.add(new Send_Email_to_Users_Settings__c( SetupOwnerId = getUtilAccountManagerProfileId(), Email_Template_ID__c = etemp[1].Id ) );
         
        insert SendEmailSettingsList;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 19 Mar 2013 Last Modified: 21 Mar 2013
    * @description Helper method to re-create the  General Settings
    */
    public void buildGenSetting(){
        General_Settings__c genSettings = new General_Settings__c();
        insert genSettings;
    }
    
    /**
    * @author Original: Robby Angeles (502068424) Cloud Sherpas/GEHC Last Modified: Robby Angeles (502068424) Cloud Sherpas/GEHC
    * @date Original: 18 Apr 2013
    * @description Helper method to re-create the Account Request Settings
    */
    public void buildAccRequestSetting(){
        Account_Request_Settings__c reqSettings = new Account_Request_Settings__c();
        
        reqSettings.APAC_Request_URL__c = '/testAPACURL';
        reqSettings.China_Request_URL__c = '/testChinaURL';
        reqSettings.EAGM_Request_URL__c = '/testEAGMURL';
        reqSettings.EU_Request_URL__c = '/testEUURL';
        reqSettings.India_Request_URL__c = '/testINDIAURL';
        reqSettings.LATAM_Request_URL__c = '/testLATAMURL';
        reqSettings.USCAN_Request_URL__c = '/testUSCANURL';
        
        insert reqSettings;
    }
    
    
    /**
    * @author Original: Swapna Vasagiri (502207647) TCS/GEHC 
    * @date Original: 30 May 2013
    * @description Helper method to re-create the Parent Opportunity Settings
    */
    public void buildParentOpportunitySetting(){
        Parent_Opportunity_Settings__c parOptySettings = new Parent_Opportunity_Settings__c();
              
        parOptySettings.Term_Record_Type_Name__c = 'Term Opportunity';
        insert parOptySettings ;
    }
    
   
    
     /**
    * @author Original: Mayank Jain (502207676) TCS/GEHC 
    * @date Original: 8 Aug 2013
    * @description Helper method to re-create the Parent Opportunity Settings
    */
    
    public void buildIBSource(){
        
        ibSourceList.add(new IB_Source__c(Name = 'Manual',Editable__c = true));
        ibSourceList.add(new IB_Source__c(Name = 'Arthur Gash', Editable__c = false));

        insert ibSourceList;
        
        System.debug('@@ibSourceList'+ibSourceList);
    }
    
      /**
    * @author Original: Mayank Jain (502207676) TCS/GEHC 
    * @date Original: 8 Aug 2013
    * @description Helper method to re-create the Parent Opportunity Settings
    */
    public void buildIBSetting(){
        IB_Settings__c IBSettings = new IB_Settings__c();
        
        IB_Source__c ibSource = [Select Id , Name ,Editable__c from  IB_Source__c where id =: ibSourceList[0].id];
              
        IBSettings.Default_IB_Source__c = ibSource.id;
        insert IBSettings ;
    }
    
    /**
    *@author Original:GEHC Japan IT
    *@date Original: 17 Dec 2013, Last Modified: 17 Dec 2013
    *@description　Method to get Japan di,us,Lcs User' role Id.
    *@param
    */

    public String getJapanDiRoleId(){
        //UserRole r = [select ro.id from UserRole ro WHERE ro.name= 'JAPAN Management.DI' limit 1];
        UserRole r = [select ro.id from UserRole ro limit 1];
        return r.Id;
    }
    public String getJapanUsRoleId(){
        //UserRole r = [select ro.id from UserRole ro WHERE ro.name= 'JAPAN Management.US' limit 1];
         UserRole r = [select ro.id from UserRole ro limit 1];
        return r.Id;
    }
    public String getJapanLcsRoleId(){
       // UserRole r = [select ro.id from UserRole ro WHERE ro.name= 'JAPAN Management.LCS' limit 1];
         UserRole r = [select ro.id from UserRole ro limit 1];
        return r.Id;
    }
    
    /**
    *@author Original:GEHC Japan IT
    *@date Original: 17 Dec 2013, Last Modified: 17 Dec 2013
    *@description　Method to get Japan HCS User Profile Id.
    *@param
    */

    public String getUtilJapanHcsProfileId(){
        Profile p = [select pf.id from profile pf WHERE pf.name= 'GEHC JAPAN HCS Sales User' limit 1];
        return p.Id;
    }
    
    /**
    * @author Original: Teja Thomas TCS/GEHC
    * @date Original: 28 Jan 2014 
    * @description Helper method to re-create Pega Global Regions custom setting
    */
    
    public void buildPegaGlobalRegions(){
        
        List<Pega_Global_Regions__c> pgrList = new List<Pega_Global_Regions__c>();
        
        pgrList.add(new Pega_Global_Regions__c(Name = 'USCAN'));
         
        insert pgrList ;
    }
    
     /**
    * @author Original: Mayank Jain (502207676) TCS/GEHC 
    * @date Original: 18 Feb214    
    * @description Helper method to re-create the Integration General setting 
    */
    
    public void buildIntegrationGeneralSettings(){
        List<Integration_General_Settings__c> intGenList = new List<Integration_General_Settings__c>();
        
        intGenList.add(new  Integration_General_Settings__c(Name = 'EPOP_CreateQuote',Application_Sender_Name__c='TP_SalesForceGlobal',Default_Error_Code__c='SFDC-GEN-ERR-001',
                        Enable_Integration__c =true,Endpoint__c='test',No_Response_Error_Code__c='SFDC-GEN-ERR-NORESP',Password__c='pa55word',
                         Success_Code__c ='SFDC-SUCCESS',Timeout__c= 120000,   Username__c = 'TP_Salesforce'));


        insert intGenList;
        
        System.debug('@@intGenList'+intGenList);
    }
    
}