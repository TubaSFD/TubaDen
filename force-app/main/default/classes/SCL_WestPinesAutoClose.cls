//Story Number
//STY-00058
public class SCL_WestPinesAutoClose implements Database.Batchable<SObject> {

	public Decimal daysCount;
    
    public SCL_WestPinesAutoClose(){
        List<SCL_ComponentParameters__c> autoCloseDays = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  autoCloseDays){
            daysCount = instance.SCL_WestPinesAutoCloseDays__c;
        }
    }
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Status, SCL_StatusReason__c, SCL_CaseAge__c From Case WHERE (IsClosed = FALSE) AND (RecordType.Name = 'Behavioral Health Intake') AND (Status IN ('Open','Ready to Schedule','Needs Additional Info'))]);
    }
     
   public void execute(Database.BatchableContext BC, List<Case> scope){
     List<Case> casesToClose = new List<Case>();
       for(sObject instance : scope){
           Case caseInstance = (Case)instance;
           if(caseInstance.SCL_CaseAge__c > daysCount){
               caseInstance.Status = 'Closed';
               caseInstance.SCL_StatusReason__c ='Time Exceeded';
               casesToClose.add(caseInstance);
           }
       }
       update casesToClose;
   }
 
   public void finish(Database.BatchableContext BC){
       
   }
}