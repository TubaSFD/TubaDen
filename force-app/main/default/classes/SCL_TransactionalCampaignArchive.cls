public class SCL_TransactionalCampaignArchive implements Database.Batchable<SObject> {
    
    public List<string> transactionalCampaigns;
    
    public SCL_TransactionalCampaignArchive() {        
        List<SCL_ComponentParameters__c> sclComponentParameters = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  sclComponentParameters) {
            transactionalCampaigns = instance.SCL_TransactionalCampaigns__c.split(',');            
        }        
    }        
    
    
    public Database.querylocator start(Database.BatchableContext BC) {              
        return Database.getQueryLocator([SELECT Id, SCL_CampaignNumber__c FROM SCL_PlannedOutreach__c WHERE SCL_CampaignNumber__c IN :transactionalCampaigns]);
    }
    
    public void execute(Database.BatchableContext BC, List<SCL_PlannedOutreach__c> scope) {
        if(!scope.isEmpty()) {
            delete scope;
            // Hard delete the records.
            Database.emptyRecycleBin(scope); 
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}