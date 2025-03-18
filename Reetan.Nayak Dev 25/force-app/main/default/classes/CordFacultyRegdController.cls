public class CordFacultyRegdController {

    public List<Faculty__c> selectFaculty { get; set;}
    public Faculty__c faculty {get; set;}
    public Boolean showFaculty {get; set;}    
    public Integer selectPage {get; set;}
    public String facId{get;set;}
    private final Faculty__c factl;  
    
    
    public CordFacultyRegdController() {
        this.faculty = new Faculty__c();
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords();        
        }
        
    public CordFacultyRegdController(ApexPages.StandardSetController controller) {
       this.factl = (Faculty__c)controller.getRecord(); 
    }
    
    
    public ApexPages.StandardSetController facultyRecords {
        get {
            if(facultyRecords == null) {
                facultyRecords = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id,  Name, Last_Name__c, Email_ID__c, Mobile_No__c from Faculty__c  order by Name ]));
                facultyRecords.setPageSize(6);
                facultyRecords.setpageNumber(0);
                }
            return facultyRecords;
        }
        set;
    }    
     
/*     public List<Faculty__c> getSelectFaculty() {
         return (List<Faculty__c>) facultyRecords.getRecords();
    }    */
    
           
    
    // Saving the Faculty Record    
    public void facultySavePage() {
      try {
        insert this.faculty;
        facultyRecords = null;
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords();  
        
        //  Sending Email         
        List<Faculty__c> faclist = new List<Faculty__c>();
        faclist = [SELECT Id, Name, DOB__c, Email_ID__c, Login_ID__c, Gender__c, Last_Name__c, Mobile_No__c, PIN__c from Faculty__c
               //    where Name=:ApexPages.currentPage().getParameters().get('pg:fm:pgblk:pbs:pbsi:facn') ];                     
                   where Name=:ApexPages.currentPage().getParameters().get('pg:cordFactTab:compg:fm:pgblk:pbs:pbsi:facn') ];
        Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
        email.setSubject( 'Account Setup Notification');    
        email.setToAddresses( new String[]{faclist[0].Email_ID__c} );
        email.setPlainTextBody( 'Hello  '+faclist[0].Name+'\n\n'+ 'Thank you for Registering with us.\n\nYour UNIQUE User Name is :\n\nUser Name: '+faclist[0].Login_ID__c+
                          '\nDefault Password is: ceptes321' +
                          '\n\nNow get started by signing up online to view all your course details and get updates on your course status.'+
                          '\nFor queries related to account logins, Please Send Email to:'+
                          '\ntraining@ceptes.com\n\nHappy Learning \n\nSincerely,\nCTP Program Team ');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});    
        } catch(Exception e) { }
        showFaculty = false;
    }
    
    
    // Cancel to Faculty Detail Page.
    public PageReference facultyCancelPage() {
        PageReference ref = new PageReference('/apex/FacultyRegdPage');
        ref.setRedirect(true);
        return ref;
    }       
    
    public PageReference doNewFaculty() {
        this.showFaculty = true;
        return null;
    }    
    
/////////////////////    
    public void nextButton() {
        facultyRecords.next();
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords();        
        }

    public void previousButton() {
        facultyRecords.previous();
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords(); 
        }    

    public void firstButton() {
        facultyRecords.first();
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords(); 
        }    

    public void lastButton() {
        facultyRecords.last();
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords(); 
        }    

    public Integer getPageNo(){
        return facultyRecords.getPageNumber();
    }   

    public List<Integer> getPageNos(){
        List<Integer> lst = new List<Integer>();
          for(Integer i=1; i<=getTotalPageNumber(); i++) {
            lst.add(i);
        }
         return lst;
    }   
    
    public Integer getTotalPageNumber(){
        Integer n = TotalRecords - (pageSize * (TotalRecords / pageSize));
        if(n == 0){
            return TotalRecords / pageSize;
        }else
         return (TotalRecords / pageSize) + 1;
    }
    
    public Integer pageSize {
       get {
            return facultyRecords.getPageSize();
        }
        set;
    }       
    
    public Integer TotalRecords {
        get {
            return facultyRecords.getResultSize();
        }
        set;
    }
 
    public Boolean getDisableNext(){
        return facultyRecords.getHasNext();
    }
    
    public Boolean getDisablePrevious(){
        return facultyRecords.getHasPrevious();
    }
    
    public void onClickPageNo() {
    System.debug('selectPage.......' + selectPage);
        facultyRecords.setpageNumber(selectPage);
        this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords(); 
     }    
     
   public void deleteRecords(){
          
     try{
         Faculty__c fac=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Address__c, City__c, Course_Details__c, Course_Offered__c, 
                         Courses_Association__c, Courses__c, DOB__c, Date_of_Joining__c, Email_ID__c, Expertise__c, Gender__c, Language_Known__c, Last_Name__c, Login_ID__c, Marital_Status__c, Mobile_No__c, PIN__c, Programs__c,
                         Skills__c, State__c, Technical_Experience__c, Technology_Experts__c, Test_Questionnaire__c, Time_Slots__c, Training_Experience__c, Work_Experience__c, Years_of_Experience__c from faculty__c where Id=:facId LIMIT 1];
         System.debug('faculty Id is+++++++++++++++++++'+facId);                
         delete fac;
         facultyRecords = null;
         this.selectFaculty = (List<Faculty__c>) facultyRecords.getRecords();        
     } catch(Exception e) {}
       showFaculty = false;
    
    }  
    
    //Test Methods
    static testMethod void testFaculty() {
        faculty__c fac=new faculty__c();
        fac.Name='Rakesh';
        fac.Last_Name__c='Prahaja';
        fac.Email_ID__c='baruna@ceptes.com';
        fac.DOB__c=System.toDay();
        fac.Mobile_No__c='1234567890';
        fac.PIN__c=332244;
        insert fac;
            
        CordFacultyRegdController CordFactRegd = new CordFacultyRegdController();
        CordFactRegd.facultySavePage();
        CordFactRegd.facultyCancelPage();
        CordFactRegd.doNewFaculty();
        CordFactRegd.nextButton();
        CordFactRegd.previousButton();
        CordFactRegd.firstButton();
        CordFactRegd.lastButton();
        CordFactRegd.getPageNo();
        CordFactRegd.getPageNos();
        CordFactRegd.getTotalPageNumber();
        CordFactRegd.getDisableNext();
        CordFactRegd.getDisablePrevious();
        CordFactRegd.selectPage = 6;
        CordFactRegd.onClickPageNo();
        CordFactRegd.deleteRecords();           
    }
 
}