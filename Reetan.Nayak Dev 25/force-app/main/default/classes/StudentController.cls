Public class StudentController{
    public boolean displayPopup {get; set;}
    public String sid;
    public StudentController() {
        sid=ApexPages.currentPage().getParameters().get('id');
        System.debug('...............................'+sid);
    }
    
    public PageReference cancelButton(){
        PageReference ref=new PageReference('null');
        ref.setRedirect(true);
        return ref;
    }
    public PageReference doExam() {
        PageReference pgref=new PageReference('/apex/Dev401Exam');
        pgref.setRedirect(true);
        return pgref;
    }
    
    public PageReference doLogout(){
        PageReference pgref=new PageReference('/apex/loginpage');
        pgref.setRedirect(true);
        return pgref;
    }
    
        
    public Student__c[] getName(){
        Student__c[] student;
        try{
          student=[Select Name,Last_Name__c, St_Mob_No__c, SEmail_Id__c,loginId__c from Student__c where loginId__c=:sid];
        }catch(Exception e){}
        return student;
    }
    public List<Course__c> getCourse(){
        List<Course__c> csp =new List<Course__c>();
        try{
            Student__c stt1=[select id,BatchId__c from Student__c where loginId__c=:sid];
            Batch__c bat=[SELECT Id, CourseId__c from batch__c where id=:stt1.BatchId__c];
            
            System.debug('..........batchid is..'+bat);
            csp=[SELECT Id,Course_Fees__c, Course_Name__c, Programs__c from Course__c where id=:bat.CourseId__c];
        }catch(Exception e){}
        return csp;
    }
    
    public List<sessionentry__c> getTask(){
    
        List<sessionentry__c> session;
        try{
            List<Student__c> stt1=new List<Student__c>();
            stt1=[select id,BatchId__c from Student__c where loginId__c=:sid];
            List<Batch__c> bat=new List<Batch__c>();
            bat=[SELECT Id, CourseId__c from batch__c where id=:stt1[0].BatchId__c];
             //System.debug('.................'+bat[0].CourseId__c);
            session=[SELECT Id,  Faculty__c, Batch__c, Comment__c, Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c, 
                    selectsesion__c, New_Task__c, No_Of_Hours__c from sessionentry__c where batch__c =:bat[0].id and Status__c='Completed'];
        }catch(Exception e){}
        return session;
        
    }
    public List<sessionentry__c>getTopicInProgress(){
        List<sessionentry__c> session;
        try{
            List<Student__c> stt1=new List<Student__c>();
            stt1=[select id,BatchId__c from Student__c where loginId__c=:sid];
            List<Batch__c> bat=new List<Batch__c>();
            bat=[SELECT Id,Name, CourseId__c from batch__c where id=:stt1[0].BatchId__c];
            System.debug('...................batch name......'+bat[0].Name);
            session=[SELECT Id,  Faculty__c, Batch__c, Comment__c, Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c,
                     selectsesion__c, New_Task__c, No_Of_Hours__c from sessionentry__c where batch__c =:bat[0].id and Status__c='In Progress'];
        }catch(Exception e){
             System.debug(e);
        }
        return session;
    
    }
        
    public List<sessionentry__c> getTopicNotStarted(){    
        List<sessionentry__c> session;
        try{
            List<Student__c> stt1=new List<Student__c>();
            stt1=[select id,BatchId__c from Student__c where loginId__c=:sid];
            List<Batch__c> bat=new List<Batch__c>();
            bat=[SELECT Id, CourseId__c from batch__c where id=:stt1[0].BatchId__c];
            session=[SELECT Id,  Faculty__c, Batch__c, Comment__c, Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c, 
                    selectsesion__c, New_Task__c, No_Of_Hours__c from sessionentry__c where batch__c =:bat[0].id and Status__c='Not Started'];
        }catch(Exception e){
            System.debug(e);
          }
         return session;
    }        
            
    public List<Test__c> getTest(){
        List<Test__c> test;
        try{
           Student__c stt1=new Student__c();
            List<Batch__c> bat=new List<Batch__c>();
            List<Session__c> ses=new List<Session__c>();
            stt1=[select id,BatchId__c from Student__c where loginId__c=:sid];
            bat=[SELECT Id, CourseId__c from batch__c where id=:stt1.BatchId__c]; 
            ses=[SELECT Id, CourseId__c, batch__c,Status__c from session__c where batch__c=:bat[0].id and Status__c='Completed'];  
            test=[SELECT Id, Faculty__c, TaskId__c, Test_Name__c,TestPendingStatus__c, Test_Status__c, Test_Approval__c,
            Assignment_Approval__c from test__c where TaskId__c=:ses[0].id];
        }catch(Exception e){
            System.debug('inside test '+e);
        }
        return test;
    }   
          
    public void closePopup() {        
        displayPopup = false; 
    }     
    public void showPopup() {        
        displayPopup = true;    
    }
    public PageReference doTest(){
        PageReference pgref=new PageReference('/apex/Dev401Exam?id='+sid);
        pgref.setRedirect(true);
        return pgref;
    }
                
    //test method here

    static testMethod void studentTest(){
        ApexPages.currentPage().getParameters().put('id','assw0');
        String sid=ApexPages.currentPage().getParameters().get('id');
        StudentController stc=new StudentController();
        stc.doLogout();
        stc.doTest();
        stc.doExam();
        stc.getName();
        stc.getCourse();
        stc.getTask();
        stc.getTest();
        stc.getTopicInProgress();
        stc.getTopicNotStarted();
        //  stc.getTest();
        stc.cancelButton();
        stc.closePopup();
        stc.showPopup();
    }
    
     static testMethod void studentTestWithout(){
        StudentController stc=new StudentController();
        ApexPages.currentPage().getParameters().put('id','null');
        String sid=ApexPages.currentPage().getParameters().get('id');
        stc.getName();
        stc.getCourse();
        stc.getTask();
        stc.getTopicInProgress();
        stc.getTopicNotStarted();
        //stc.getTest();
     }
    
}