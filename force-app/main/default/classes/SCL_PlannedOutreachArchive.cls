public class SCL_PlannedOutreachArchive implements Database.Batchable<SObject> {
    
    public Decimal daysCount;
    
    public SCL_PlannedOutreachArchive(){
        List<SCL_ComponentParameters__c> autoCloseDays = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  autoCloseDays){
            daysCount = instance.SCL_PlannedOutreachArchiveAge__c;
        }
    }        
    
    
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, SCL_Age__c, SCL_RecordAge__c From SCL_PlannedOutreach__c WHERE SCL_Age__c > 0 AND SCL_RecordAge__c >:daysCount]);
    }
    
    public void execute(Database.BatchableContext BC, List<SCL_PlannedOutreach__c> scope){
        if(!scope.isEmpty()){
            delete scope;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}