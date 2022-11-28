public class SCL_TA_ExceptionLog_BU_IncrementRetries implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<SCL_ExceptionLog__c> newList, List<SCL_ExceptionLog__c> oldList) {	
        if (newList.isEmpty()) return;
		
        for (SCL_ExceptionLog__c el : newList) {               
            el.SCL_Retries__c++;
        }        
  	}	    
}