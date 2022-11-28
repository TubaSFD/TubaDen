//Story Number
//STY-00050
public class SCL_PillPlannerAutoClose implements Database.Batchable<SObject>{
    
	public Decimal daysCount;
    
    public SCL_PillPlannerAutoClose(){
        List<SCL_ComponentParameters__c> autoCloseDays = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  autoCloseDays){
            daysCount = instance.SCL_PharmacyPillPlannerCaseAutoCloseDays__c;
        }
    }
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Status, SCL_StatusReason__c, SCL_DaysSince1stOutreachAttempt__c, CreatedDate From Case WHERE IsClosed = FALSE AND RecordType.DeveloperName = 'SCL_PharmacyPillPlanner']);
    }
     
   public void execute(Database.BatchableContext BC, List<Case> scope){
     List<Case> casesToClose = new List<Case>();
       for(sObject instance : scope){
           Case caseInstance = (Case)instance;
           if(caseInstance.SCL_DaysSince1stOutreachAttempt__c > daysCount){
                caseInstance.Status = 'Not Enrolled';
                caseInstance.SCL_StatusReason__c ='Time Exceeded';
                casesToClose.add(caseInstance); 
           }
       }
       update casesToClose;
   }
 
   public void finish(Database.BatchableContext BC){
       
   }
}