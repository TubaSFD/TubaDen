public class SCL_TA_PO_BI_MatchAccount implements TriggerAction.BeforeInsert {    
	public void beforeInsert(List<SCL_PlannedOutreach__c> newList) {         
        if (newList.isEmpty()) return;
        
        try {            
            SCL_POGateway.getPOMatchAccount(newList,'insert');            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }
  	}	    
}