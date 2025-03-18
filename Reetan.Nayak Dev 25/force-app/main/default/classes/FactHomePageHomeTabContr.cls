public class FactHomePageHomeTabContr {

    public String fid;
    public Session__c sessn {get; set;}   
    public boolean displayPopup {get; set;}
    public List<SessionEntry__C> displayTodaysTask{get;set;}
    public List<SessionEntry__C> displayUpComingTask{get;set;}
    
    public FactHomePageHomeTabContr() {
       fid = ApexPages.currentPage().getParameters().get('Id');
       Faculty__c faclt=[select Id,Name from Faculty__c where Login_ID__c=:fid Limit 1];
       
       //Upcoming task.. 
       displayUpComingTask =new List<SessionEntry__C>();
       List<SessionEntry__C> SentryUpcList=[SELECT Id, IsDeleted, Name, Batch__c, Comment__c, Session_Type__c, Session__c,
                                            Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c, selectsesion__c 
                                            from sessionEntry__c where faculty__c=:faclt.Id limit 50];
       for(SessionEntry__C ss:SentryUpcList){
           displayUpComingTask.add(new SessionEntry__C(Course_Name__c = ss.Course_Name__c,Batch__c = ss.Batch__c,Session_Name__c=ss.Session_Name__c,
                                                       Session_Type__c=ss.Session_Type__c));
       }                                                 
    }

    // Get the Login User Name    
    public Faculty__c[] getUserName(){
        Faculty__c[] fct;
        try {
            fct = [Select Id, Name, Last_Name__c, Email_ID__c, Login_ID__c, Mobile_No__c, PIN__c, Courses__c from Faculty__c where Login_ID__c=:fid];
        }catch(Exception e) { }
        return fct;
    } 
        
    // Session Complete Table
    public Session__c[] getSessComplete(){
        Session__c[] sesscom;
        List<Faculty__c> sessionList = new List<Faculty__c>();
        sessionList = [SELECT Id, login_id__c from Faculty__c where login_id__c=:fid];
        try{
            sesscom = [SELECT Id, Name, CourseId__c, Task_Completed__c, Task__c, Session_Type__c, Status__c, Session_Status__c, FacultyID__c, Comment__c, Batch__c,
                     Date__c, Start_Time__c, End_Time__c  from Session__c  where FacultyID__c=:sessionList[0].Id and Status__c='Completed'   order by Batch__c ];
        }catch(Exception e){
             System.debug(e);
        }
        return sesscom;
    } 
        
    // Session In Progress Table
    public Session__c[] getSessProgress(){
        Session__c[] sessprg;
        List<Faculty__c> sessionList = new List<Faculty__c>();
        sessionList = [SELECT Id, login_id__c from Faculty__c where login_id__c=:fid];
        
        try{
            sessprg = [SELECT Id, Name, CourseId__c, Task_Completed__c, Task__c, Session_Type__c, Status__c, Session_Status__c, FacultyID__c, Comment__c, Batch__c,
                      Date__c, Start_Time__c, End_Time__c  from Session__c  where FacultyID__c=:sessionList[0].Id and Status__c='In Progress' order by Batch__c ];
        }catch(Exception e){
            System.debug(e);
        }
        return sessprg;
    }
        
    // Session Not Complete Table
    public Session__c[] getSessNot(){
        Session__c[] sesnot;
        List<Faculty__c> sessionList = new List<Faculty__c>();
        sessionList = [SELECT Id, login_id__c from Faculty__c where login_id__c=:fid];
        try{
            sesnot = [SELECT Id, Name, CourseId__c, Task_Completed__c, Task__c, Session_Type__c, Status__c, Session_Status__c, FacultyID__c, Comment__c, Batch__c,
                     Date__c, Start_Time__c, End_Time__c  from Session__c  where FacultyID__c=:sessionList[0].Id and Status__c='Not Started'   order by Batch__c ];
        }catch(Exception e){
            System.debug(e);
        }
        return sesnot;
    } 
    
    // Go to Pop Up Page    
    public String edId {get; set;}
    
   // public Session__c sessions;   
    public void sessEditPage() {
        sessn = [SELECT Id, Name, CourseId__c, FacultyID__c, Comment__c, Session_Type__c, Status__c, Task_Completed__c, Task__c, Test_Status__c, Batch__c, 
                    Session_Status__c, Date__c, Start_Time__c, End_Time__c from Session__c  where Id=:edId ];
        
        displayPopup = true;            
    }  
      
    public void savePopUp() {
        List<Faculty__c> fact = new List<Faculty__c>();
        try {
            fact = [SELECT Id, Name, Login_ID__c  from Faculty__c where Id=:fid  ];  
            System.debug('Chk the Fact ID ........'+ fact+'fid value is ....'+ fid);

            update this.sessn;
            System.debug('CHKKKKKKKKKKKKKKKKKK ...............'+this.sessn);
        }catch(Exception e) { }    
      displayPopup = false; 
    }      
    
    public void closePopUp() {
        displayPopup = false;    
    }           
    
    //Test Methods
    static testMethod void facHomeTest(){
        faculty__c fac=new faculty__c();
        fac.Name='Raju';
        fac.Last_Name__c='Shewad';
        fac.DOB__c=System.toDay();
        fac.Email_ID__c='baruna@ceptes.com';
        fac.Mobile_No__c='2121343456';
        fac.PIN__c=232323;
        Insert fac;
        
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
        
        faculty__c fa=[select Id,Name,Login_ID__c from faculty__c where Name='Raju'];
        ApexPages.currentPage().getParameters().put('Id',fa.Login_ID__c);
        FactHomePageHomeTabContr fachm=new FactHomePageHomeTabContr();
        fachm.edId=ssn.Id;
        fachm.getUserName();
        fachm.getSessComplete();
        fachm.getSessProgress();
        fachm.getSessNot();
        fachm.sessEditPage();
        fachm.savePopUp();
        fachm.closePopUp();
        Delete fac;
    }
    
    
}