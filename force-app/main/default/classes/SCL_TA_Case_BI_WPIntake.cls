public class SCL_TA_Case_BI_WPIntake implements TriggerAction.BeforeInsert {    
	public void beforeInsert(List<Case> newList) { 
        if (newList.isEmpty()) return;
        try {             
            for (case case1 : newList) {
                if (newList[0].RecordTypeId == SCL_GatewayUtils.wpBHRecordTypeId && newList[0].origin == 'Webform' && newList[0].SCL_FormFirstName__c == null && newList[0].SCL_FormLastName__c == null) {
                	// Don't insert it!
                	newList[0].addError('Invalid data from Formstack insert');
            	}
            }
        } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }
  	}	    
}