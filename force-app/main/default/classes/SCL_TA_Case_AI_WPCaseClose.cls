public class SCL_TA_Case_AI_WPCaseClose implements TriggerAction.AfterInsert {	
	public void afterInsert(List<Case> newList) { 
        if (newList.isEmpty()) return;		        
        try {
            if (newList[0].RecordTypeId != null && newList[0].RecordTypeId == SCL_GatewayUtils.wpBHRecordTypeId) SCL_CaseGateway.closeWPCase(newList);            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }
  	}	    
}