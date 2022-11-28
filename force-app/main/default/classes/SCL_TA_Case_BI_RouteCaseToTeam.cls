public class SCL_TA_Case_BI_RouteCaseToTeam implements TriggerAction.BeforeInsert {    
	public void beforeInsert(List<Case> newList) { 
        if (newList.isEmpty()) return;
                
        try {             
            newList = SCL_CaseGateway.getRouteCaseToTeam(newList,null);            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }
  	}	    
}