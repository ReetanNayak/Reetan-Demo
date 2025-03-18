public with sharing class ActionChaining_CTRL {

    private ApexPages.Standardcontroller opptyController;
    public Integer step { get; set; }
    private Id ownerId;
    private User opptyOwner;
    private Opportunity oppty;
    
    public ActionChaining_CTRL (ApexPages.StandardController controller) {
        opptyController = controller;
        oppty = (Opportunity) controller.getRecord();   
        step = 0;
        ownerId = [Select OwnerId From Opportunity Where Id = :oppty.Id ].OwnerId;
    }
    
    public PageReference activateUser() {
        opptyOwner = [Select Id, isActive From User Where Id = :ownerId];
        opptyOwner.IsActive = true;
        update opptyOwner;
        step = 1;
        return null;
    }
    public PageReference updateOppty() {
        oppty.StageName = 'Closed Lost';
        step = 2;
        update oppty;
        return null;
    }
    public PageReference deActivateUser() {
        opptyOwner.IsActive = false;
        update opptyOwner;
        step = 0;
        return null;
    }
}