public class FactHomePageCorsBuidContr{

    public String selectValue{get;set;}
    public String seletedCors{get;set;}
    public String selectedbatch{get; set;} 
    public List<BatRec> batchDetails{get;set;}
    public String fid;
    public String facId;
    public List<SessionEntry__c> showSessionEntry{get;set;}
    public FactHomePageCorsBuidContr(){
        fid = ApexPages.currentPage().getParameters().get('Id');
        System.debug('.....fid................'+fid);
           try{
               faculty__c fac=[select Id,Name from faculty__c where Login_ID__c=:fid];
               facId=fac.Id;
           }catch(Exception e){}
    }

  public  List<SelectOption> getprogName(){
      List<SelectOption> option=new List<SelectOption>();
      try{
          List<Program__c> prg=[select Id,Name from Program__c];
          option.add(new SelectOption('','--select--'));
          for(Program__c p:prg){
              option.add(new SelectOption(p.Id,p.Name));
          }
      }catch(Exception e){} 
      return option; 
    }
  
    public List<SelectOption> getcorsList(){
        List<SelectOption> option=new List<SelectOption>();
        
        try{
          List<Course__C> crs=[select Id,Name from Course__c where ProgramId__c=:selectValue];
          for(Course__c c:crs){
              option.add(new SelectOption(c.Id,c.Name));
          }
        }catch(Exception e){}
        return option;
    }
    
    public List<SelectOption> getbatchList(){
        List<SelectOption> option=new List<SelectOption>();
        List<Batch__c> bat;
        if(selectValue != null){
            try{
                bat=[select Id,Name from Batch__c where CourseId__c=:seletedCors Limit 10];
            }catch(Exception e){}
            option.add(new SelectOption('','--select--'));
            option.add(new SelectOption('All Batches','All Batches'));
            for(Batch__c b:bat)
                option.add(new SelectOption(b.Id,b.Name));
       }
       return option;
    }
    
    public void readSessCors(){
        batchDetails=new List<BatRec>();
        try{
            Course__C crs=[select Id,Name from Course__c where Id=:seletedCors Limit 1];
            List<SessionEntry__c> ssentList=[SELECT Id,Faculty__c, Batch__c,  Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, 
                             Start_Time__c, End_Time__c from sessionentry__c where Course_Name__c=:crs.Name ];
            System.debug('The course name is------------------'+seletedCors);
                             
            List<Batch__c> batList;
            if(selectedbatch == 'All Batches'){                     
                batList=[select Id,Name,Start_Time__c,End_Time__c,Start_Date__c,Total_Hours__c from Batch__c where CourseId__c=:seletedCors  order by Name Asc  Limit 10  ];
            }else{
                batList=[select Id,Name,Total_Hours__c,Start_Time__c,End_Time__c,Start_Date__c from Batch__c where CourseId__c=:seletedCors and Id=:selectedbatch   Limit 1  ];
            }
            List<Session__c> ssList=[Select Id,Name,Session_Name__c,Session_Type__c,Duration_In_Hour__c from Session__c where CourseId__c=:seletedCors  limit 50];
            
            if(selectedbatch != null && batList.size()>0){
                Map<String,List<SessionEntry__c>> batchSessionMap =new  Map<String,List<SessionEntry__c>>();
                for(SessionEntry__c ssent:ssentList){
                    List<SessionEntry__c> sestemp = batchSessionMap.get(ssent.batch__c);
                    if(sestemp == null){
                        sestemp = new List<SessionEntry__c>();
                        sestemp.add(ssent);
                        batchSessionMap.put(ssent.batch__c,sestemp);
                    }else{
                        sestemp.add(ssent);
                    }
                }
                
                for(Batch__c b:batList){ 
                    Boolean isBatch = false;
                    Integer count=0;
                    for(String key : batchSessionMap.keyset()){
                        if(b.Id == key){
                            isBatch=true;
                            List<SessionEntry__c> sList = batchSessionMap.get(key);
                            System.debug('--------------------+++++++++'+key);
                            BatRec br = new BatRec();
                            br.bname = b.Name;
                            br.bid = b.id;
                            br.sDate=b.Start_Date__c;
                            br.sTime=b.Start_Time__c;
                            br.eTime=b.End_Time__c;
                            br.session = new List<SecRec>();
                            for(Session__c sc :ssList){
                                boolean isSel = false;
                                for(SessionEntry__c sce : sList){
                                    if(sc.Session_Name__c == sce.Session_Name__c && sc.Session_Type__c == sce.Session_Type__c && sce.faculty__c == null){
                                        isSel = true;
                                        count+=1;
                                        break;
                                    }
                                }
                                if(isSel){
                                    br.session.add(new SecRec(sc));
                                }
                            }
                            if(count == 0)
                                br.showSection=false;
                            batchDetails.add(br);
                        } 
                    }
                    if(!isbatch){
                        BatRec br = new BatRec();
                        br.bname = b.Name;
                        br.bId=b.Id;
                        br.sDate=b.Start_Date__c;
                        br.sTime=b.Start_Time__c;
                        br.eTime=b.End_Time__c;
                        List<SecRec> srecList = new List<SecRec>();
                        for(Session__c sc:ssList)
                            srecList.add(new SecRec(sc));
                        br.session = srecList;
                        batchDetails.add(br);
                    }
                } 
            }
        }catch(Exception e){}  
    } 
    
    public void showSessEntry(){
        showSessionEntry=new List<SessionEntry__c>();
        try{     
            Course__C crs=[select Id,Name from Course__c where Id=:seletedCors Limit 1]; 
            List<SessionEntry__c> ssEntryList=[SELECT Id,Faculty__c, Batch__c,  Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, 
                                                Start_Time__c, End_Time__c  from sessionentry__c where Course_Name__c=:crs.Name AND Faculty__c != null order by Batch__c desc Limit 30 ];  
                          
            for(SessionEntry__c ss: ssEntryList)                                  
            showSessionEntry.add(new SessionEntry__c(Faculty__c=ss.Faculty__c,Batch__c=ss.Batch__c,Session_Name__c=ss.Session_Name__c,Session_Type__c=ss.Session_Type__c,Start_Time__c=ss.Start_Time__c,
                                                     End_Time__c=ss.End_Time__c,Course_Name__c=ss.Course_Name__c));   
        }catch(Exception e){} 
        readSessCors();  
    } 
     
     public PageReference saveSessionEntry() {
         
         try{
             Course__C crs=[select Id,Name from Course__c where Id=:seletedCors Limit 1]; 
             List<SessionEntry__c> sentryList=[SELECT Id,Name,Faculty__c, Batch__c,  Session_Type__c, Session__c, Status__c, Session_Name__c, Course_Name__c, 
                                                    Start_Time__c, End_Time__c  from sessionentry__c where Course_Name__c=:crs.Name order by Batch__c desc Limit 30 ];
             Double totalTime=0;
             Faculty__c fac=[Select Id,Name from Faculty__c where Id=:facId limit 1];
             for(SessionEntry__c ssent:sentryList){
                 for(BatRec b:batchDetails){
                     Integer count=0;
                     for(SecRec s: b.session){
                         System.debug('The selected values are....................'+s.isSelected);
                         if(s.isSelected == true && b.bid==ssent.Batch__c && s.sec.Session_Name__c == ssent.Session_Name__c && s.sec.Session_Type__c == ssent.Session_Type__c && ssent.faculty__c == null){
                             count += 1;
                             ssent.faculty__c = facId;
                             ssent.Status__c='In Progress';
                         }
                     }
                     if(count > 0){
                         Batch__c bat=[Select Id,Name,Status__c from Batch__c where Id=:b.bId Limit 1 ];
                         bat.Status__c='In Progress';
                         update bat;
                     }
                 }  
             }
             upsert sentryList;
             showSessEntry();
             readSessCors();
         }catch(Exception e){}
         
         return null;
    } 
 
    public class BatRec{
        public String Selected;
        public Boolean showSection{get;set;} 
        public Id bid{get;set;}
        public Date sDate{get;set;}
        public String stime{get;set;}
        public String etime{get;set;}
        public String bname{get;set;}
        public List<SecRec> session{get;set;}
        public BatRec(){
            showSection=true;
        }   
   }
    
   public class SecRec{
       public Boolean isSelected{get;set;} 
       public Session__c sec {get;set;}
       public SecRec(Session__c nsec){
              isSelected = false;
              sec = nsec;
       } 
   }
   
   //Test Methods
   static testMethod void testFacCrsBld(){
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
        
        Batch__c bat=new Batch__c();
        bat.CourseId__c=crs.Id;
        bat.Name='Morning';
        bat.Start_Time__c='10:00AM';
        bat.End_Time__c='12:30PM';
        bat.Start_Date__c=System.toDay();
        bat.Session_Det__c ='Only Weekend';
        insert bat;
        
        SessionEntry__c ses= new SessionEntry__c();
        ses.Session_Name__c='Intr';
        ses.Session_Type__c='Devlopment';
        ses.Course_Name__c=crs.Name;
        ses.Start_Time__c='10:00AM';
        ses.End_Time__c='12:00PM';
        ses.faculty__c=fac.Id;
        ses.Batch__c=bat.Id;
        insert ses; 
        
        faculty__c fa=[select Id,Name,Login_ID__c from faculty__c where Name='Raju'];
        
        FactHomePageCorsBuidContr factcrs=new FactHomePageCorsBuidContr();
        ApexPages.currentPage().getParameters().put('Id',fa.Login_ID__c);
        factcrs.facId=fa.Id;
        factcrs.selectValue=prg.Id;
        factcrs.seletedCors=crs.Id;
        factcrs.selectedbatch=bat.Id;
        factcrs.getprogName();
        factcrs.getcorsList();
        factcrs.getbatchList();
        factcrs.readSessCors();
        factcrs.showSessEntry();
        factcrs.saveSessionEntry();
        Delete fac;
        Delete bat;
        
    }
    static  testMethod void studentTestTrigger1(){
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