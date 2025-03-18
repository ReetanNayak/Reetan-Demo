public with sharing class CaseSwarmRule_CLS {

    String step1 = null;
    String withStatus = null;
    String withPriority = null;
    String withType = null;
    String[] usersSelected = new String[]{};
    Boolean notify = false;

    public String getStep1() {
        return step1 ;
    }
                    
    public void setStep1(String step1 ) { 
        this.step1 = step1; 
    }

    public List<SelectOption> getStep1Options() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All Cases','All Cases'));
        options.add(new SelectOption('Only Cases for Accounts I Own',     'Only Cases for Accounts I Own'));
        options.add(new SelectOption('Only Cases with a certain Status',  'Only Cases with a certain Status'));
        options.add(new SelectOption('Only Cases with a certain Priority','Only Cases with a certain Priority'));
        options.add(new SelectOption('Only Cases of a certain Type',      'Only Cases of a certain Type'));
        return options;
    }

    public String getWithStatus() {
        return withStatus;
    }
                    
    public void setWithStatus(String withStatus) { 
        this.withStatus = withStatus; 
    }

    public List<SelectOption> getStatusOptions() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
       return options;
    }

    public String getWithPriority() {
        return withPriority;
    }
                    
    public void setWithPriority(String withPriority) { 
        this.withPriority = withPriority; 
    }

    public List<SelectOption> getPriorityOptions() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = Case.Priority.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
       return options;
    }

    public String getWithType() {
        return withType;
    }
                    
    public void setWithType(String withType) { 
        this.withType = withType; 
    }

    public List<SelectOption> getTypeOptions() {
        List<SelectOption> options = new List<SelectOption>();

        Schema.DescribeFieldResult fieldResult = Case.Type.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
       return options;
    }

   /* public PaginatedSelectList getUserOptions() {
        PaginatedSelectList options = new PaginatedSelectList ();

        for (User thisUser: 
                [select Id, FirstName, LastName from User where isActive = true and UserType = 'Standard' order by LastName, FirstName]) {
            options.add(new SelectOption(thisUser.Id, thisUser.LastName + ', ' + thisUser.FirstName));
        }
        
        return options;
    }    */

    public String[] getUsersSelected() {
        return usersSelected;
    }
                    
    public void setUsersSelected(String[] usersSelected) { 
        this.usersSelected = usersSelected; 
    }

    public Boolean getNotify() {
        return notify;
    }
                    
    public void setNotify(Boolean notify) { 
        this.notify = notify; 
    }

    public PageReference action() {

        CaseSwarmRule_CLS.addRules(this.getUsersSelected(), this.step1, this.withStatus, this.withPriority, this.withType, this.notify);
            
        // Redirect the user back to the original page
     //   PageReference pageRef = Page.SwarmRuleSaveSuccess;
    //    pageRef.setRedirect(true);
     //   return pageRef;
         return null;
    }
    
    @future
    public static void addRules(String[] usersSelected, String step1, String withStatus, String withPriority, String withType, Boolean notify) {
        List<Case_Swarm_Rule__c> newRules = new List<Case_Swarm_Rule__c>();
    
        for (String userId: usersSelected) {
            String ruleName = step1;
        
            Case_Swarm_Rule__c rule = new Case_Swarm_Rule__c();
            rule.Type__c = step1 ;
            if (step1.equals('Only Cases with a certain Status')) {
                rule.Case_Status__c = withStatus;
                ruleName = 'Only Cases with Status: ' + withStatus;
            } else if (step1.equals('Only Cases with a certain Priority')) {
                rule.Case_Priority__c = withPriority;
                ruleName = 'Only Cases with Priority: ' + withPriority;
            } else if (step1.equals('Only Cases of a certain Type')) {
                rule.Case_Type__c = withType;
                ruleName = 'Only Cases with Type: ' + withType;
            }

            rule.User__c = userId;
            rule.Description__c = ruleName;
            rule.Notify_on_Swarm__c = notify;
            newRules.add(rule);
        }
        insert newRules;
    }
}