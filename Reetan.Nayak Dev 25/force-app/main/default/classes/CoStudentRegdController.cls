public class CoStudentRegdController {

    public List<Student__c> selectStudent { get; set;}
    public Student__c student {get; set;}
    public String selectBatch{get;set;}
    public String selectProgram {get; set;}
    public String selectCourse {get; set;}
    public String emailid {get; set;}
   
    public Lead Ld;
    public Boolean require {get;set;}
    public Boolean isError {get;set;}   
    public Boolean showLead {get;set;}
    public Boolean showStudent {get; set;}       
    public Boolean displayPopup {get; set;}    
    public String studId {get;set;}
   
    String Gender=null;
   
    // String paymentType=null;
    public String paymentType {get; set;}
   
    public Integer selectPage {get; set;}
    private final Student__c stdnt;     
   
   
    // Default Constructor  
    public CoStudentRegdController() {
       this.selectStudent = (List<Student__c>) studentRecords.getRecords(); 
       this.showLead=true;
    }
   
    public CoStudentRegdController(ApexPages.StandardSetController controller) {
       this.stdnt = (Student__c)controller.getRecord();
    }   


    public ApexPages.StandardSetController studentRecords {
        get {
            if(studentRecords == null) {
                studentRecords = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id, Name, Last_Name__c, SEmail_Id__c, St_Mob_No__c from Student__c  order by Name ]));
                studentRecords.setPageSize(6);
                studentRecords.setpageNumber(0);
                }
            return studentRecords;
        }
        set;
    }       
   
 
    // Create New Student
    public PageReference doNewStudent() {
        student=new Student__c();
        selectProgram=null;
        this.showStudent = true;
        return null;
    }                

    // Get All Program Names           
    public List<Selectoption> getProgramName(){
        List<Program__c> program=[select id, Name from Program__c];
        List<SelectOption> op=new List<SelectOption>();
        op.add(new SelectOption('', '--Select--'));
            for(Program__c p:program){
                op.add(new SelectOption(p.Id, p.Name));
            }
        System.debug('.Program id is......'+selectProgram);
        return op;
      } 
     
    // Get All Courses         
    public List<SelectOption> getCourseList(){
         System.debug('.Program id is......'+selectProgram);
       // pId=ApexPages.CurrentPage().getParameters().get('pg:cordStuTab:compg:form:pgblk:pbs:pbsitem1:pname');
        List<SelectOption> option=new List<SelectOption>();                  
        try {
            List<Course__c> courseList=[select id, Name, Course_Name__c,ProgramId__c from Course__c where
                                    ProgramId__c =:selectProgram  order by Name ];
            
            option.add(new SelectOption('','--Select--'));
            for(Course__c c:courseList)
                option.add(new SelectOption(c.Id, c.Name));
            
         }catch(Exception e){}
         System.debug('............The courses are...........'+option);
         return option;
    }
           
    // Get All Batches
    public List<SelectOption> getBatchList(){ 
        List<SelectOption> opt=new List<SelectOption>();       
        try{
            List<Batch__c> batch = [SELECT Id, Name,CourseId__c from Batch__c where CourseId__c=:selectCourse  ];
            opt.add(new SelectOption('', '--Select--'));
            for(Batch__c b:batch)
                opt.add(new SelectOption(b.Id, b.Name));
        }catch(Exception e){}
        System.debug('..............Batch Details are.......'+opt);
        return opt;
    } 
    
    public List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Direct','Direct'));
        options.add(new SelectOption('Instalment','Installment'));
        return options;
    }
       
    // Check for Lead               
    public void fromLead() {
        System.debug('......EmailId is..'+emailId);
        Student = new Student__c();
        try{
         Ld=[SELECT Id,LastName,FirstName,Email,Phone,City,State from Lead where Email=:emailid LIMIT 1];
         }
         catch(Exception e){
              System.debug(e);
         }
           
        if(Ld != null) {
            Student.Name = Ld.FirstName;
            Student.Last_Name__c = Ld.LastName;
            Student.St_Mob_No__c = Ld.Phone;
            student.City__c=Ld.City;
            emailid = Ld.Email;
            student.States__c=Ld.State;
            isError = false;
            require = true;
            this.showLead = false; 
            }   
                else{isError=true;}
          }
             
        String loginId='';
        public String getLoginId() {  return loginId;    }
        public void setLoginId(String loginId) { this.loginId = loginId; }  
       
 
    // Student Save Page           
    public void studentSave(){
        try {
            System.debug('Email id ................'+emailid);
            Ld = [select id,status from lead where Email=:emailid LIMIT 1];
            Ld.status = 'Enrolled';
            update Ld;
        }catch(Exception e) {
            System.debug(e);
            }
        try { 
            student.SEmail_Id__c= emailid;         
            student.BatchId__c = selectBatch;
            insert this.student;
            studentRecords = null;
            this.selectStudent = (List<Student__c>) studentRecords.getRecords();
            Student__c st=[Select Id,Name,SEmail_Id__c,loginId__c from Student__c where SEmail_Id__c=:emailid Limit 1];
            Messaging.SingleEmailMessage email=new Messaging.SingleEmailMessage();
            email.setSubject( 'Account Setup Notification');
            email.setToAddresses( new String[]{st.SEmail_Id__c} );
            email.setPlainTextBody( 'Hello  '+st.Name+'\n\n'+ 'Thank you for registering with us.\n\n Your unique user name is :\n\n User Name:  '+st.loginId__c+
                                  '\n\nYour Temporary Password: ceptes321 \n\nNow get started by signing up online to view all  your course details and get updates on your course status.'+
                                  '\nFor queries related to account logins, please send email to'+
                                  '\n training@ceptes.com\n\n Happy learning \n\n Sincerely,\nCTP program team ');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            loginId=st.loginId__c;
        } catch(Exception ex) {
        System.debug(ex);
      }
      showStudent = false;
    }
      
    public void nextButton() {
        studentRecords.next();
        this.selectStudent = (List<Student__c>) studentRecords.getRecords();  
        }

    public void previousButton() {
        studentRecords.previous();
        this.selectStudent = (List<Student__c>) studentRecords.getRecords();  
        }   

    public void firstButton() {
        studentRecords.first();
        this.selectStudent = (List<Student__c>) studentRecords.getRecords();  
        }   

    public void lastButton() {
        studentRecords.last();
        this.selectStudent = (List<Student__c>) studentRecords.getRecords();  
        }   

    public Integer getPageNo(){
        return studentRecords.getPageNumber();
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
        return studentRecords.getPageSize();
    }
    
    public Integer getTotalRecords(){
        return studentRecords.getResultSize();
    }
 
    public Boolean getDisableNext(){
        return studentRecords.getHasNext();
    }
    
    public Boolean getDisablePrevious(){
        return studentRecords.getHasPrevious();
    }

    public void onClickPageNo() {
    System.debug('selectPage.......' + selectPage);
        studentRecords.setpageNumber(selectPage);
        this.selectStudent = (List<Student__c>) studentRecords.getRecords();  
     }   
   
     public void deleteRecords(){
     System.debug('Student Id is+++++++++++++++++'+studId); 
     try{
         Student__C std=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                           SystemModstamp, BatchId__c, Address__c, Certificate_received__c, City__c, CourseId__c, DateOfBirth__c, Gender__c,
                           Highest_Qualification__c, Home_Phone_Number__c, Language_known__c, Last_Name__c, Look_Course__c, PaymentType__c,
                           PinCode__c, Prefered_Time__c, Program_Name__c, Revaluation_Needed__c, SEmail_Id__c, SecuredMark__c, St_Mob_No__c,
                           States__c, TestName__c, University__c, Year_Of_Passing__c, loginId__c from student__c where Id=:studId LIMIT 1];
         System.debug('Student Id is+++++++++++++++++'+studId);                  
         delete std;
         studentRecords = null;
         this.selectStudent = (List<Student__C>) studentRecords.getRecords();        
     } catch(Exception e){}
       showStudent = false;
    } 
    
    //Test Methods
    static  testMethod void studentTest(){
        Program__c prg=new Program__c();
        prg.Name='ABCD';
        insert prg;
        
        Course__c crs=new Course__c();
        crs.Name='ABC';
        crs.ProgramId__c=prg.Id;
        insert crs;
        
        Batch__c bat=new Batch__c();
        bat.CourseId__c=crs.Id;
        bat.Name='Morning';
        bat.Start_Time__c='10:00AM';
        bat.End_Time__c='12:30PM';
        bat.Start_Date__c=System.toDay();
        bat.Session_Det__c ='Only Weekend';
        insert bat;
        
        Student__c st=new Student__c();
        st.Name='Ramesh';
        st.Last_Name__c='Naier';
        st.BatchId__c=bat.Id;
        st.SEmail_Id__c='baruna@ceptes.com';
        st.St_Mob_No__c='1234567890';
        st.PinCode__c=233455;
        Insert st;
        
        CoStudentRegdController cost=new CoStudentRegdController();
        cost.selectPage = 6;       
        cost.doNewStudent();
        cost.getProgramName();
        cost.getCourseList();
        cost.getBatchList();
        cost.getItems();
        cost.fromLead();
        cost.studentSave();
        cost.nextButton();
        cost.previousButton();
        cost.firstButton();
        cost.lastButton();
        cost.getPageNo();
        cost.getPageNos();
        cost.getTotalPageNumber();
        cost.getPageSize();
        cost.getTotalRecords();
        cost.getDisableNext();
        cost.getDisablePrevious();
        cost.onClickPageNo();
        cost.deleteRecords();
        Delete st;
    }
    
    static  testMethod void studentTestTrigger(){
     Program__c prg=new Program__c();
        prg.Name='ABCD';
        insert prg;
        
        Course__c crs=new Course__c();
        crs.Name='ABC';
        crs.ProgramId__c=prg.Id;
        insert crs;
        
        Batch__c bat=new Batch__c();
        bat.CourseId__c=crs.Id;
        bat.Name='Morning';
        bat.Start_Time__c='08:30AM';
        bat.End_Time__c='10:30AM';
        bat.Start_Date__c=System.toDay();
        bat.Session_Det__c ='Exclude Weekend';
        insert bat;    
    }                   
}