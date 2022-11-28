public class SCL_TA_PO_AI_CreateCase implements TriggerAction.AfterInsert {		
	public void afterInsert(List<SCL_PlannedOutreach__c> newList) {         
        if (newList.isEmpty()) return;                                            
        if (SCL_TA_PO_BI_UpdateWithCase.getInstance().withCase != null && SCL_TA_PO_BI_UpdateWithCase.getInstance().withCase) SCL_POGateway.createCase(newList);
  	}    
}