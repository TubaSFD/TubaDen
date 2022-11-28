public class SCL_UpdatePOPersonAccountId implements Database.Batchable<SObject> {    
    
    public SCL_UpdatePOPersonAccountId() {              
    }            
    
    public Database.querylocator start(Database.BatchableContext BC) {          
        return Database.getQueryLocator([SELECT Id FROM SCL_PlannedOutreach__c WHERE LastModifiedDate=LAST_N_DAYS:0 AND SCL_PersonAccount__c=null]);
    }
    
    public void execute(Database.BatchableContext BC, List<SCL_PlannedOutreach__c> scope) {
        if(!scope.isEmpty()) Database.update(scope,false);                    
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}