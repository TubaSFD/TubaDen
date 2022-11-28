public class SCL_TA_Appt_BU_AccountQueries {
  private static SCL_TA_Appt_BU_AccountQueries instance;

  public SCL_TA_Appt_BU_AccountQueries() {
  }

  public static SCL_TA_Appt_BU_AccountQueries getInstance() {
  	if (SCL_TA_Appt_BU_AccountQueries.instance == null) {
    	SCL_TA_Appt_BU_AccountQueries.instance = new SCL_TA_Appt_BU_AccountQueries();
    }
    return SCL_TA_Appt_BU_AccountQueries.instance;
  }

  public Map<String, Account> beforeCaseAccountMap { get; private set; }

  public class Service implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<SCL_Appointment__c> newList, List<SCL_Appointment__c> oldList) {
        List<SCL_Appointment__c> newUpdatedList = new List<SCL_Appointment__c>();
    	Set<String> patientIdSet = new Set<String>();   
                
        try {
            for (SCL_Appointment__c appt : newList) {		
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                            
                if (String.isBlank(appt.SCL_Patient__c)) {                            
                    if (String.isNotBlank(appt.SCL_MRN__c)) {                                
                    	patientIdSet.add(appt.SCL_MRN__c);                            
                	}
                    newUpdatedList.add(appt);
                }
            }
                
            // Create map of Case Id values and Person Account              
            if (!newUpdatedList.isEmpty()) SCL_TA_Appt_BU_AccountQueries.getInstance().beforeCaseAccountMap = SCL_ApptGateway.getApptPatientSFIdMap(patientIdSet,newUpdatedList);            
            patientIdSet = null;
            newUpdatedList = null;            
        } catch (Exception e) {
            SCL_GatewayUtils.publishException(newList,'update',e);
        }
    }              
  }
}