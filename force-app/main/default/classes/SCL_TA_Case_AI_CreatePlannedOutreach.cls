public class SCL_TA_Case_AI_CreatePlannedOutreach implements TriggerAction.AfterInsert {	
	public void afterInsert(List<Case> newList) { 
        if (newList.isEmpty()) return;                   
        if (SCL_TA_Case_BI_UpdateWithPlannedOutreach.getInstance().withPO != null && SCL_TA_Case_BI_UpdateWithPlannedOutreach.getInstance().withPO) SCL_CaseGateway.createPlannedOutreach(newList);         
  	}	    
}