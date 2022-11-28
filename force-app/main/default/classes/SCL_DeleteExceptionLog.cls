public class SCL_DeleteExceptionLog implements Database.Batchable<SObject> {    
    
    public SCL_DeleteExceptionLog() {              
    }        
    
    
    public Database.querylocator start(Database.BatchableContext BC) {          
        return Database.getQueryLocator([SELECT Id FROM SCL_ExceptionLog__c WHERE SCL_Resolved__c=true AND CreatedDate<LAST_N_DAYS:7]);
    }
    
    public void execute(Database.BatchableContext BC, List<SCL_ExceptionLog__c> scope) {
        if(!scope.isEmpty()) {
            delete scope;
            // Hard delete the records.
            Database.emptyRecycleBin(scope); 
        }
        
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
}