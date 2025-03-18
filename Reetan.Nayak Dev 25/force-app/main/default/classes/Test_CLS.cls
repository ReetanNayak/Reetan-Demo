public class Test_CLS {

public string selectProgram {get; set;}
public string selectCourse {get; set;}
public string selectBatch {get; set;}

public Boolean displayPhone {get; set;}
public Boolean displayChkbox {get; set;}
public Boolean displayActive {get; set;}


    public Test_CLS(ApexPages.StandardController controller) {
        displayPhone = true;
        displayChkbox = false;
        displayActive = false;
    }

    public List<SelectOption> getProgramList() {
        List<SelectOption> lstPrg = new List<SelectOption>();
            lstPrg.add(new SelectOption('selP', '--Select--'));            
            lstPrg.add(new SelectOption('SF', 'Salesforce'));            
            lstPrg.add(new SelectOption('Java', 'JAVA'));            
            lstPrg.add(new SelectOption('net', '.NET'));            
        return lstPrg;
    }


    public List<SelectOption> getCourseList() {
        List<SelectOption> lstPrg = new List<SelectOption>();
            if(selectProgram == 'SF') { 
                lstPrg.add(new SelectOption('vf', 'Visualforce'));            
                lstPrg.add(new SelectOption('apex', 'APEX'));            
                lstPrg.add(new SelectOption('soql', 'SOQL'));  
            }              
            else if(selectProgram == 'Java') { 
                lstPrg.add(new SelectOption('serv', 'Servlet'));            
                lstPrg.add(new SelectOption('jsp', 'JSP'));            
                lstPrg.add(new SelectOption('strs', 'Struts'));  
            }
            else if(selectProgram == 'net') { 
                lstPrg.add(new SelectOption('asp', 'ASP'));            
                lstPrg.add(new SelectOption('vbn', 'VB'));            
                lstPrg.add(new SelectOption('cc', 'C#'));  
            }                        
        return lstPrg;
    }
    

    public List<SelectOption> getBatchList() {
        List<SelectOption> lstBat = new List<SelectOption>();
            lstBat.add(new SelectOption('bat1', 'Batch 1'));            
            lstBat.add(new SelectOption('bat2', 'Batch 2'));            
            lstBat.add(new SelectOption('bat3', 'Batch 3'));            
            lstBat.add(new SelectOption('bat4', 'Batch 4'));            
        return lstBat;
    }    
    
    public void actCors() {
        if(selectCourse == 'apex') {
            displayPhone = false;
        }
        else{
            displayPhone = true;
        }
    }

    public void actChk() {
        system.debug('displayChkbox...BEFORE..... '+displayPhone);
        if(selectCourse == 'apex' && displayChkbox == true) {
            displayPhone = true;
            displayActive = true;
            system.debug('displayChkbox...AFTER..... '+displayPhone);
        }
        else {
            displayPhone = false;
            displayActive = false;
        }
     }

}