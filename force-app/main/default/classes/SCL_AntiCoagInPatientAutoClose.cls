//Story Number
//STY-00050
public class SCL_AntiCoagInPatientAutoClose  implements Database.Batchable<SObject>{

	public Decimal daysCount;
    
    public SCL_AntiCoagInPatientAutoClose(){
        List<SCL_ComponentParameters__c> autoCloseDays = SCL_ComponentParameters__c.getall().values();
        for(SCL_ComponentParameters__c instance :  autoCloseDays){
            daysCount = instance.SCL_PharmacyAntiCoagCaseAutoCloseDays__c;
        }
    }
    public Database.querylocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Status, SCL_StatusReason__c, SCL_DischargeDate__c, CreatedDate From Case WHERE IsClosed = FALSE AND RecordType.Name = 'Pharmacy Anti-Coag In-Patient']);
    }
     
   public void execute(Database.BatchableContext BC, List<Case> scope){
     List<Case> casesToClose = new List<Case>();
       for(sObject instance : scope){
           Case caseInstance = (Case)instance;
           //we need an exception in case SCL_DischargeDate__c is blank, use Case.CreatedDate
           Date dischargeDate = caseInstance.SCL_DischargeDate__c != NULL ? caseInstance.SCL_DischargeDate__c : Date.valueOf(caseInstance.CreatedDate) ;
           if((dischargeDate.daysBetween(System.today())) > daysCount){
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