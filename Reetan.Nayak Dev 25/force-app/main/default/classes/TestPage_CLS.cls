public class TestPage_CLS {

    public String selectProgram {get; set;}
    public List<SelectOption> corsList {get; set;}   
    public String coid;
    public String cName;
    public Boolean showText{get;set;}
    public List<TaskDetails> taskDetFromSEntry{get;set;}
    public String seletedCors{get;set;}
    public List<Batch__c> batchName{get;set;}
    
    public TestPage_CLS(){
               
    System.debug('TestSEntryList.........taskDetFromSEntry......');
        coid=ApexPages.currentPage().getParameters().get('Id');
        corsList =new List<SelectOption>();
        showText=true;
        System.debug('.............coid..........'+coid);
    }
    // Coordinator User Name
    public Coordinator__c getCorUserName(){
        Coordinator__c cor;
//        cor = [Select Id, Name, Last_Name__c, Email_ID__c,Login_ID__c,Mobile_No__c,PIN__c from Coordinator__c where Login_ID__c=:coid];
        cor = [Select Id, Name, Last_Name__c, Email_ID__c,Login_ID__c,Mobile_No__c,PIN__c from Coordinator__c ];

        return cor;
    }
    
    // Select Program List
    public List<SelectOption> getProgName(){
        List<Program__c> prgm = [SELECT Id, Name from Program__c  order by Name ];
        List<SelectOption> popt = new List<SelectOption>();
            popt.add(new SelectOption('', '--Select--'));
                for(Program__c ps:prgm) {
                 popt.add(new SelectOption(ps.Id, ps.Name));
                 }        
          return popt;
        }
        
    // Onchange Program        
    public void onChangeProgram() {
        showText=false;
        System.debug('Progam I............D is'+selectProgram);
        corsList =new List<SelectOption>();
        List<Course__c> cours = [SELECT Id, Name, Programs__c,Course_Fees__c, Course_Name__c, ProgramId__c from Course__c 
                                  where  ProgramId__c=:selectProgram  order by Name ];
        for(Course__c cs:cours)
            corsList.add(new SelectOption(cs.Id, cs.Name));
    }
    
   public void showBatchStatus(){
       showText=false;
       taskDetFromSEntry = new  List<TaskDetails>();
       batchName = new List<Batch__c>();
       try{
           List<Batch__c> batList=[Select Id,Name,Start_Date__c,Total_Hours__c,Time_Diff__c  from Batch__c where CourseId__c=:seletedCors ];
           Course__c crsName=[Select Id,Name from Course__c where Id=:seletedCors];
           cName=crsName.Name;
           List<SessionEntry__c> sEntryList=[SELECT Id,  Name, Faculty__c, Batch__c, Comment__c, Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c, 
                                   selectsesion__c from SessionEntry__c where Course_Name__c=:cName ]; 
          
           Map<String,List<SessionEntry__c>> batchSessionMap =new  Map<String,List<SessionEntry__c>>();
                for(SessionEntry__c ssent:sEntryList){
                    List<SessionEntry__c> sestemp = batchSessionMap.get(ssent.batch__c);
                    if(sestemp == null){
                        sestemp = new List<SessionEntry__c>();
                        sestemp.add(ssent);
                        batchSessionMap.put(ssent.batch__c,sestemp);
                    }else
                        sestemp.add(ssent);
                    
                }
                
            for(Batch__c b:batList){
                batchName.add(new Batch__c(Name = b.Name));
                for(String key : batchSessionMap.keyset()){
                    List<SessionEntry__c> sList = batchSessionMap.get(key);
                    if(b.Id == key){
                        TaskDetails tsk = new TaskDetails();        
                        tsk.sentList=new List<SesEntRec>();
                        tsk.batchName=b.Name;
                        tsk.batchSDate=String.valueOf(b.Start_Date__c);
                        tsk.timeDuration=b.Time_Diff__c;
                        for(SessionEntry__c sce : sList){
                            if(sce.Faculty__c == null)
                                tsk.sentList.add(new SesEntRec(false,sce));
                            else
                                tsk.sentList.add(new SesEntRec(true,sce));
                        }
                        taskDetFromSEntry.add(tsk);
                        System.debug('.........taskDetFromSEntry...........'+taskDetFromSEntry);
                    }
                } 
            }
          
       }catch(Exception e){System.debug('.......Exception block....'+e);}  
   }        
    
     public PageReference saveSessEntry(){
         showText=false;
         System.debug('.........cname is....'+cName);
        try{
            List<SessionEntry__c> sEntryList=[SELECT Id,  Name, Faculty__c, Batch__c, Comment__c, Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, Start_Time__c, End_Time__c, 
                                    selectsesion__c from SessionEntry__c where Course_Name__c=:cName AND Faculty__c = ''];
            for(TaskDetails tsk:taskDetFromSEntry)
                for(SesEntRec tsent:tsk.sentList)
                     for(SessionEntry__c sent:sEntryList)
                        if(tsent.checked && tsent.sec.Faculty__c != null  && tsent.sec.Id == sent.Id){
                            sent.faculty__c = tsent.sec.Faculty__c;
                            sent.Status__c='In Progress';
                            update sent;
                            System.debug('.....updated Records.............'+sent);
                        }
            showBatchStatus();            
        }catch(Exception e){System.debug('..Exception is........'+e);} 
        return null;
    }
    
    
    // Get Completed Batch  
    public List<Batch__c> getBatchComplete(){
        List<Batch__c> batList;
        try {
             batList = [SELECT Id, Name, CourseId__c, BatchId__c, Faculty_Id__c, Status__c,  End_Date__c, Start_Date__c from Batch__c
                        where Status__c = 'Completed' AND  CourseId__c=:seletedCors  order by Name ];
        
        }catch(Exception e){} 
        return batList;
    }  
    
    // Get In Progress Batch
    public List<Batch__c> getBatchProgress(){
        List<Batch__c> batIp;
        try {
            batIp = [SELECT Id, Name, CourseId__c, BatchId__c, Faculty_Id__c, Status__c,  End_Date__c, Start_Date__c from Batch__c
                     where Status__c = 'In Progress' and  CourseId__c=:seletedCors  order by Name ];
       
        }catch(Exception e){}
        return batIp;
    }
       
    // Get Not Started Batch
    public  List<Batch__c> getBatchNotStart(){
        List<Batch__c> batn; 
        try {        
            batn = [SELECT Id, Name, CourseId__c, BatchId__c, Faculty_Id__c, Status__c,  End_Date__c, Start_Date__c from Batch__c
                    where Status__c = 'Not Started' and  CourseId__c=:seletedCors  order by Name ];
        }catch(Exception e){}
        return batn;
    }
  
    
    public class TaskDetails{
        public String batchName{get;set;}
        public String batchSDate{get;set;}
        public Decimal timeDuration{get;set;}
        public List<SesEntRec> sentList{get;set;}
        public TaskDetails(){}

         public  List<SelectOption> getFacNameList(){
            List<SelectOption> options=new List<SelectOption>();
            List<Faculty__C> fList=[Select Id,Name from Faculty__c Limit 100];
            options.add(new SelectOption('','-select-'));
            for(Faculty__c fa:fList)
                options.add(new SelectOption(fa.Id,fa.Name)); 
                return options;
            } 
     }
     public class SesEntRec{ 
        public Boolean checked{get;set;}
        public Boolean disable{get;set;} 
        public SessionEntry__c sec {get;set;}
        public SesEntRec(Boolean b,SessionEntry__c sc){    
        checked=b;
        disable=b;
        sec=sc;               
        } 
    }
    
    
}