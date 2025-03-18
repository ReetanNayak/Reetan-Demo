public class CordHomePageBatchTabContlr {

    public List<Batch__c> selectBatch { get; set;}
    public Batch__c bat {get; set;}
    public Boolean showBatch {get; set;}
    public String batchId {get; set;}
    public Integer selectPage {get; set;}
    private final Batch__c bath;  
    public String starttime{get;set;}
    public String endtime{get;set;}
    
        
    
    public CordHomePageBatchTabContlr() {
        this.bat = new Batch__c();
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();
        }    

    public CordHomePageBatchTabContlr(ApexPages.StandardSetController controller) {
       this.bath = (Batch__c)controller.getRecord(); 
    }


    public ApexPages.StandardSetController batchRecords {
        get {
            if(batchRecords == null) {
                batchRecords = new ApexPages.StandardSetController(Database.getQueryLocator( [SELECT Id, Name, CourseId__c, BatchId__c, Status__c,
                                                                                            Start_Time__c ,End_Time__C,Start_Date__c from Batch__c  order by CourseId__c ]));
                batchRecords.setPageSize(6);
                batchRecords.setpageNumber(0);
                }
            return batchRecords;
        }
        set;
    }        
    
/*     public List<Batch__c> getSelectBatch() {
         return (List<Batch__c>) batchRecords.getRecords();
     }    */


    public PageReference doNewBatch() {
        bat=new Batch__c();
        this.showBatch = true;
        return null;
    }


    public void batSavePage() {
     System.debug('inside batSavePage');
      try{
        bat.Start_Time__c=starttime;
        bat.End_Time__c=endtime;
        System.debug('Start Time...'+starttime);
        upsert bat;
        batchRecords = null;
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
        } catch(Exception e) {}
            System.debug('inside__________batSavePage' + bat);
            showBatch = false;
    }
    
    public void batCancelPage() {
        showBatch = false;
        }
        
        
////////////
    public void nextButton() {
        batchRecords.next();
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
        }

    public void previousButton() {
        batchRecords.previous();
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
        }    

    public void firstButton() {
        batchRecords.first();
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
        }    

    public void lastButton() {
        batchRecords.last();
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
        }    

    public Integer getPageNo(){
        return batchRecords.getPageNumber();
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
                 }
             else
             return (TotalRecords / pageSize) + 1;
        }
        
    public Integer pageSize {
       get {
            return batchRecords.getPageSize();
        }
        set;
    }       
    
    public Integer TotalRecords {
        get {
            return batchRecords.getResultSize();
        }
        set;
    }
 
    public Boolean getDisableNext(){
        return batchRecords.getHasNext();
    }
            
    public Boolean getDisablePrevious(){
        return batchRecords.getHasPrevious();
    }
        
    public void onClickPageNo() {
    System.debug('selectPage.......' + selectPage);
        batchRecords.setpageNumber(selectPage);
        this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
     }   
       
    public List<SelectOption> getTimeFormatHour(){
             List<SelectOption> options = new List<SelectOption>();
             
             options.add(new SelectOption('', '--Select--'));
             
            for(Integer s=0;s<2;s++){
            Integer hh=0;
                 for(Integer i=0;i<24;i++){
                      String tm='';
                      Integer mm=i/2;
                      Integer rem=i-mm*2;
                      if(i<20){
                               if(rem==0){
                                      String j='0'+String.valueOf(hh);
                                      String p='00';
                                      tm=j+':'+p;
                                     
                                }else{
                                      String j='0'+String.valueOf(hh);
                                      String p='30';
                                      tm=j+':'+p;
                                      hh=hh+1;  
                               }  
                      }else{
                            
                            if(rem==0){
                                      String j=String.valueOf(hh);
                                      String p='00';
                                      tm=j+':'+p;
                            }else{
                                  String j=String.valueOf(hh);
                                  String p='30';
                                  tm=j+':'+p;
                                  hh=hh+1;  
                           }
                      }
                    if(s==0) 
                        options.add(new  SelectOption(tm+'AM',tm+'AM'));
                    else if(s==1 && i==0){
                        tm='12:00';
                        options.add(new  SelectOption(tm+'PM',tm+'PM'));
                    }else if(s==1 && i==1){
                        tm='12:30';
                        options.add(new  SelectOption(tm+'PM',tm+'PM')); 
                    }else 
                        options.add(new  SelectOption(tm+'PM',tm+'PM')); 
                 }      
            }
            System.debug('option return is..........'+options);
       return options; 
    }
     
     public void deleteRec(){
         System.debug('The recent Batch Id is:_____________'+batchId);
         
         try{
         batch__c bat1=[SELECT Id, IsDeleted, Name,Session_Det__c, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
                         SystemModstamp, CourseId__c, BatchId__c,End_Date__c, Faculty_Id__c, Start_Date__c, 
                         Status__c from batch__c where Id=:batchId LIMIT 1];
         List<SessionEntry__c> ssList=[Select Id,Name from  SessionEntry__c where Batch__c=:bat1.Id Limit 100]; 
         delete ssList;                
         delete bat1;
         batchRecords = null;
         this.selectBatch = (List<Batch__c>) batchRecords.getRecords();        
         } catch(Exception e) {}
            System.debug('inside__________batSavePage' + bat);
            showBatch = false;
       }
       
    public void editRecord(){
        try{
            this.bat=[SELECT Id, Name, CourseId__c,Session_Det__c, BatchId__c,Status__c,Start_Time__c ,End_Time__C,Start_Date__c 
                 from Batch__c  where Id=:batchId ];
        }catch(Exception e){}
        showBatch=true;
    
    }  
    //Test Class
    static testMethod void createStuCorPrgCourse(){
        CordHomePageBatchTabContlr cobatch = new CordHomePageBatchTabContlr();
        cobatch.selectPage=6;
        cobatch.doNewBatch();
        cobatch.batSavePage();
        cobatch.batCancelPage();
        cobatch.nextButton();
        cobatch.previousButton();
        cobatch.firstButton();
        cobatch.lastButton();
        cobatch.onClickPageNo();
        cobatch.getTimeFormatHour();
        cobatch.deleteRec();
        cobatch.editRecord();
        cobatch.getTotalPageNumber();
        cobatch.getPageNo();
        cobatch.getPageNos();
        cobatch.getDisableNext();
        cobatch.getDisablePrevious();
    }
}