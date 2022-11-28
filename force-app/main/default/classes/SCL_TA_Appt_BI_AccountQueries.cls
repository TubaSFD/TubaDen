public class SCL_TA_Appt_BI_AccountQueries {
  private static SCL_TA_Appt_BI_AccountQueries instance;

  public SCL_TA_Appt_BI_AccountQueries() {
  }

  public static SCL_TA_Appt_BI_AccountQueries getInstance() {
  	if (SCL_TA_Appt_BI_AccountQueries.instance == null) {
    	SCL_TA_Appt_BI_AccountQueries.instance = new SCL_TA_Appt_BI_AccountQueries();
    }
    return SCL_TA_Appt_BI_AccountQueries.instance;
  }

  public Map<String, Account> beforePOAccountMap { get; private set; }

  public class Service implements TriggerAction.BeforeInsert {
    public void beforeInsert(List<SCL_Appointment__c> newList) {          
        Set<String> patientIdSet = new Set<String>();    	
        try {
            for (SCL_Appointment__c appt : newList) {
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');            
                if (String.isNotBlank(appt.SCL_MRN__c)) {                                                    
                    patientIdSet.add(appt.SCL_MRN__c);                                                   
               	}                                              
            }
                
            // Create map of Epic patient Id values and associated SF Ids from Person Account        
            SCL_TA_Appt_BI_AccountQueries.getInstance().beforePOAccountMap = SCL_ApptGateway.getApptPatientSFIdMap(patientIdSet,newList);                    
            patientIdSet = null;            
        } catch (Exception e) {
            SCL_GatewayUtils.publishException(newList,'insert',e);
        }
    }              
  }
}