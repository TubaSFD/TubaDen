public class SCL_TA_Appt_BU_MatchAccount implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<SCL_Appointment__c> newList, List<SCL_Appointment__c> oldList) {	
        if (newList.isEmpty()) return;
      
        try {
            // Create map of patient Id with Person Account            
        	Map<String, Account> patientIdMap = SCL_TA_Appt_BU_AccountQueries.getInstance().beforeCaseAccountMap;               
            if (patientIdMap == null || patientIdMap.isEmpty()) return;                  
            // Loop through newList records and update SCL_Patient__c via the mapped value in patientIdMap.
            for (SCL_Appointment__c appt : newList) {
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                            
                Account acc = patientIdMap.get(appt.SCL_MRN__c);           
                if (acc != null) {
                    appt.SCL_Patient__c = acc.Id;
                    if (String.isBlank(appt.SCL_PersonEmail__c) && String.isNotBlank(acc.PersonEmail)) appt.SCL_PersonEmail__c = acc.PersonEmail;
                }
            }             
            patientIdMap = null;            
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'update',e);
        }
  	}	    
}