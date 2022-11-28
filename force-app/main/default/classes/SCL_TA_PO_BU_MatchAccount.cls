public class SCL_TA_PO_BU_MatchAccount implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<SCL_PlannedOutreach__c> newList, List<SCL_PlannedOutreach__c> oldList) {	        
        if (newList.isEmpty()) return;

        try {
            SCL_POGateway.getPOMatchAccount(newList,'update');            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }
  	}	    
}