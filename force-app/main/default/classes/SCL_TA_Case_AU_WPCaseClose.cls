public class SCL_TA_Case_AU_WPCaseClose implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<Case> newList, List<Case> oldList) {	
        if (newList.isEmpty()) return;		        
        try {
            if (newList[0].RecordTypeId != null && newList[0].RecordTypeId == SCL_GatewayUtils.wpBHRecordTypeId) SCL_CaseGateway.closeWPCase(newList);            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }
    }
}