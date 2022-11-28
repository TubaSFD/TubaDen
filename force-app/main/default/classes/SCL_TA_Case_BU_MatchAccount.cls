public class SCL_TA_Case_BU_MatchAccount implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Case> newList, List<Case> oldList) {	
        if (newList.isEmpty()) return;
        
        try {
            // Create map of patient Id with Person Account            
        	Map<String, Account> patientIdMap = SCL_TA_Case_BU_AccountQueries.getInstance().beforeCaseAccountMap;              
            if (patientIdMap == null || patientIdMap.isEmpty()) return;                  
            // Loop through newList records and update AccountId and ContactId via the mapped value in patientIdMap.
            for (Case case1 : newList) {
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                            
                String casePersonIdKey = String.isNotBlank(case1.SCL_FormEmail__c) ? (case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c  + case1.SCL_FormLastName__c).toLowercase() : '';                
                Account acc = patientIdMap.get(casePersonIdKey);           
                if (acc != null) {
                    case1.AccountId = acc.Id;    
                    case1.ContactId = acc.PersonContactId;                                                                                         
                }                
            }             
            patientIdMap = null;            
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'update',e);
        }        
  	}	    
}