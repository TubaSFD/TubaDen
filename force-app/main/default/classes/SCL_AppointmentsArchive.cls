public class SCL_AppointmentsArchive implements Database.Batchable<SObject>{
    
    public Decimal daysCount;
    
    public SCL_AppointmentsArchive(){
        List<SCL_ComponentParameters__c> autoCloseDays = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  autoCloseDays){
            daysCount = instance.SCL_AppointmentsArchiveAge__c;
        }
    }        
    
    
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, SCL_RecordAge__c From SCL_Appointment__c WHERE SCL_RecordAge__c > 0 AND SCL_RecordAge__c >:daysCount]);
    }
    
    public void execute(Database.BatchableContext BC, List<SCL_Appointment__c> scope){
        if(!scope.isEmpty()){
            delete scope;
        }
        
    }
    
    public void finish(Database.BatchableContext BC){
        
    }
}