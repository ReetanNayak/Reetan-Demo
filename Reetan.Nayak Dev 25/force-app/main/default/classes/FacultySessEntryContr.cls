public class FacultySessEntryContr {

public String fid;
public String selectCourse {get; set;}
public SessionEntry__c SesEnt {get; set;}
public Batch__c batDate{get;set;}

    public FacultySessEntryContr() {
        SesEnt = new SessionEntry__c();
        fid = ApexPages.currentPage().getParameters().get('Id'); 
        System.debug('>>>>>>>>. Chk the FID >>>>>>. ' + fid);
        }

    public List<SelectOption> getCourseList() {
        List<SelectOption> lst = new List<SelectOption>();
        lst.add(new SelectOption('', '--Select--'));
        
        List<Course__c> crs = [Select Id, Name from Course__c order by Name];
            for(Course__c c:crs){
                lst.add(new SelectOption(c.Name, c.Name));
            }
            return lst;
        }
     
     public void doSave() {
        try{    
            Faculty__c fact = [select Id, Name, Login_ID__c from Faculty__c where Login_ID__c=:fid];
            // Faculty__c fact = [select Id, Name from Faculty__c where Id='a0790000002MJKjAAO'];
            SesEnt.Faculty__c = fact.Id;
            SesEnt.Course_Name__c = selectCourse;
            
            insert this.SesEnt;
            System.debug('Chk the Inserted...... '+ this.SesEnt);
          } catch(Exception e) {}
         this.SesEnt = null;
     }   
    
    static testMethod void SEntryTest(){
        faculty__c fac=new faculty__c();
        fac.Name='Raju';
        fac.Last_Name__c='Shewad';
        fac.DOB__c=System.toDay();
        fac.Email_ID__c='baruna@ceptes.com';
        fac.Mobile_No__c='2121343456';
        fac.PIN__c=232323;
        Insert fac;
        
        faculty__c fa=[select Id,Name,Login_ID__c from faculty__c where Name='Raju'];
        ApexPages.currentPage().getParameters().put('Id',fa.Login_ID__c);
        FacultySessEntryContr facses=new FacultySessEntryContr();
        facses.getCourseList();
        facses.doSave();
        
        Delete fac;
        
    }
    
}