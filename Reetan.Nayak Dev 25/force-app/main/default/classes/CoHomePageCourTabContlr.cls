public class CoHomePageCourTabContlr {

    public List<Course__c> selectCors { get; set;}
    public List<Course__c> selectCourse { get; set;}
    public List<Session__c> selectsess{get;set;}
    public Course__c cours { get; set;}
    public Boolean courseDetails1{get;set;}
    public Boolean courseDetails2{get;set;}
    public Boolean showcourse{get;set;} 
    public Boolean showSession{get;set;} 
    public String courseId {get; set;}
    public Boolean isError{get;set;}
    public Integer selectPage {get; set;}
    private final Course__c cors;  
    public String errorMessage{get;set;}
  
    
    public CoHomePageCourTabContlr() {               
        this.courseDetails1=false;
        this.cours = new Course__c();
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
    }   

    public CoHomePageCourTabContlr(ApexPages.StandardSetController controller) {
       this.cors = (Course__c)controller.getRecord(); 
    }        
    
    
    public ApexPages.StandardSetController courseRecords {
        get {
            if(courseRecords == null) {
                courseRecords = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id,  Name,  Programs__c,  Course_Name__c, ProgramId__c from Course__c  order by ProgramId__c ]));
                System.debug('courseRecords.setPageSize' + courseRecords.getResultSize());
               
                courseRecords.setPageSize(6);
                courseRecords.setpageNumber(0);
                }
            return courseRecords;
        }
        set;
    }        
    
    
    public void nextButton() {
        courseRecords.next();
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
        }

    public void previousButton() {
        courseRecords.previous();
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
        }    

    public void firstButton() {
        courseRecords.first();
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
        }    

    public void lastButton() {
        courseRecords.last();
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
        }    

    public Integer getPageNo(){
        return courseRecords.getPageNumber();
    }
    
    public List<Integer> getPageNos(){
        List<Integer> lst = new List<Integer>();
          for(Integer i=1; i<=getTotalPageNumber(); i++) {
            lst.add(i);
        }
        return lst;
    }
       
    public Integer getTotalPageNumber(){
        Integer n = getTotalRecords() - (getPageSize() * (getTotalRecords() / getPageSize()));
         if(n == 0){
             return getTotalRecords() / getPageSize();
             }
         else
         return (getTotalRecords() / getPageSize()) + 1;
    }
    
    public Integer getPageSize(){
        return courseRecords.getPageSize();
    }       
    
    public Integer getTotalRecords(){        
        return courseRecords.getResultSize();
    }
 
    public Boolean getDisableNext(){
        return courseRecords.getHasNext();
    }
    
    public Boolean getDisablePrevious(){
        return courseRecords.getHasPrevious();
    }
    
    public void onClickPageNo() {
        System.debug('selectPage.......' + selectPage);
        courseRecords.setpageNumber(selectPage);
        this.selectCors = (List<Course__c>) courseRecords.getRecords();
     }        
     
     public void doNewCourse() {
        cours=new Course__c();
        this.selectsess = null;
        courseDetails1=true;
        courseDetails2=true;
        showSession=false;
        showcourse=false;
        isError=false;
        
       
    }


    public void addNewSession() {
     if(selectsess == null || selectsess.size() == 0){
         selectsess = new List<Session__c>();
         selectsess.add(new Session__c());
         courseDetails1=true;
         courseDetails2=true;
         showSession=true;
     }else{
          selectsess.add(new Session__c());
          
     }
    }
    
    public void saveCourse(){
        if(selectsess == null || selectsess.size() == 0){
            isError=true;
            errorMessage='At least one session should be inside course';
         }else{    
             try{
                 Decimal Totalhour=0;
                 for(Session__c sess : selectsess)
                     Totalhour=Totalhour+sess.Duration_In_Hour__c;    
                                  
                 cours.Course_Duration__c=Totalhour;
                 upsert cours;
                 for(Session__c sess : selectsess)
                     sess.CourseId__c = cours.Id;
                 
                 upsert selectsess;
                 courseRecords = null;
                 this.selectCors=[SELECT Id, Name, CreatedDate,ProgramId__c, Course_Duration__c, Course_Fees__c, Course_Name__c, Programs__c from course__C];
                 
             }catch(Exception e){
                 System.debug('Error ---- '+e);
             }
               courseDetails1=false;
       }        
    }
    
     
    public List<SelectOption> getfieldValues(){
        List<SelectOption> fieldValues = new List<SelectOption>();
        Schema.DescribeFieldResult evntField = Schema.sObjectType.Session__c.fields.Session_Type__c;
        Schema.PicklistEntry [] values = evntField.getPickListValues();
        for(Schema.PicklistEntry val : values){
            fieldValues.add(new SelectOption(val.getValue(), val.getLabel()));
        }
        return fieldValues;
    } 
     
    public void deleteCourseRecords(){
         try{
             Course__c cors=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                             SystemModstamp, ProgramId__c, Course_Duration__c, Course_Fees__c, Course_Name__c, Programs__c 
                             from course__c where Id=:courseId LIMIT 1];
             
             List<Session__c> sess=[SELECT Id,  IsDeleted, Name,Duration_In_Hour__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                         SystemModstamp, CourseId__c, FacultyID__c, Batch__c, Comment__c, Date__c, End_Time__c, Session_Status__c,
                         Session_Type__c, Start_Time__c, Status__c, Task_Completed__c, Task__c, Test_Status__c, Topic_Covered__c, 
                         Topic_InProgress__c, Topic_Not_Yet_Started__c,Session_Name__c from session__C
                         where CourseId__c=:courseId];
             System.debug('.........................................'+selectsess);           
             delete sess; 
             delete cors;            
             courseRecords = null;
             this.selectCors = (List<Course__c>) courseRecords.getRecords();        
         }catch(Exception e) {}
            courseDetails1=false;
    }  
    
    public void deleteSession(){
        try{
            Session__c ses=[SELECT Id, IsDeleted, Name,Duration_In_Hour__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById,
                            SystemModstamp, CourseId__c, FacultyID__c, Batch__c, Comment__c, Date__c, End_Time__c, Session_Status__c,
                            Session_Type__c, Start_Time__c, Status__c, Task_Completed__c, Task__c, Test_Status__c, Topic_Covered__c,
                            Topic_InProgress__c, Topic_Not_Yet_Started__c,Session_Name__c from session__c
                            where Id=:courseId];
           delete ses;
           Course__c crs=[select Id,Name from Course__c where Id=:ses.CourseId__c];  
           this.selectsess=[select Id,Session_Name__c,Duration_In_Hour__c,Session_Type__c from Session__c where CourseId__c=:crs.Id];                
              
       }catch(Exception e){}
    }
    
    public void editCoursreDetails(){
        try{
            cours=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                         ProgramId__c, Course_Duration__c, Course_Fees__c, Course_Name__c, Programs__c from course__c where Id=:courseId];
            selectsess=[select Id,Session_Name__c,Duration_In_Hour__c,Session_Type__c from Session__c where CourseId__c=:courseId];             
        }catch(Exception e){}    
            courseDetails1=true;
            courseDetails2=true;
            showcourse=false;
            showSession=true;
        
    }   
  
   public void showSessionDetails(){
       try{
           selectCourse=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                         ProgramId__c, Course_Duration__c, Course_Fees__c, Course_Name__c, Programs__c from course__c where Id=:courseId];
           selectsess=[select Id,Session_Name__c,Duration_In_Hour__c,Session_Type__c from Session__c where CourseId__c=:courseId];
           System.debug('I m inside session================'+selectsess);
       }catch(Exception e){}
       courseDetails1=true;
       courseDetails2=false;
       showSession=false;
       showcourse=true; 
   }  
   
   public void courseDetails1(){
       this.courseDetails1=false;
   } 
   
   //Test Method
   static testMethod void TestCourse() {
    
            Program__c prg=new Program__c();
            prg.Name='DWH';
            Insert prg;
           
            Course__c crs=new Course__c();
            crs.Name='J2ME';
            crs.ProgramId__c=prg.Id;
            Insert crs;
                 
            Session__c ssn = new Session__c();
            ssn.CourseId__c = crs.Id;
            ssn.Session_Name__c = 'intro';
            ssn.Session_Type__c = 'Theory';
            ssn.Duration_In_Hour__c = 3;
            insert ssn;
    
        CoHomePageCourTabContlr cordCourTab = new CoHomePageCourTabContlr();
            cordCourTab.courseId=crs.Id;
            cordCourTab.nextButton();
            cordCourTab.previousButton();
            cordCourTab.firstButton();
            cordCourTab.lastButton();
            cordCourTab.getPageNo();
            cordCourTab.getPageNos();
            cordCourTab.getDisableNext();
            cordCourTab.getDisablePrevious();
            cordCourTab.selectPage = 6;
            cordCourTab.onClickPageNo();
            cordCourTab.doNewCourse();
            cordCourTab.addNewSession();
            cordCourTab.saveCourse();
            cordCourTab.getfieldValues();
            cordCourTab.deleteCourseRecords();
            cordCourTab.deleteSession();
            cordCourTab.editCoursreDetails();
            cordCourTab.showSessionDetails();
            cordCourTab.courseDetails1();
    
    }
   
}