public class SCL_TA_PO_AI_CheckMissingRecord implements TriggerAction.AfterInsert {	
	public void afterInsert(List<SCL_PlannedOutreach__c> newList) {        
        List<SCL_PlannedOutreach__c> origList = SCL_TA_PO_BI_AccountQueries.getInstance().origList;         
        if (origList.size() > newList.size()) SCL_POGateway.processMissingRecord(origList,newList);         
        origList = null;        
  	}	    
}