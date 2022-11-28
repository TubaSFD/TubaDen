public class SCL_TA_Case_BU_RouteCaseToTeam implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Case> newList, List<Case> oldList) {	
        if (newList.isEmpty()) return;
		
        try {            
            newList = SCL_CaseGateway.getRouteCaseToTeam(newList,oldList);            
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }        
  	}	    
}