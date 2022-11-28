public class SCL_TA_Case_BU_TallyCovidVaccineSignup implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Case> newList, List<Case> oldList) {	
        if (newList.isEmpty()) return;
		Map<Id,Case> oldMap = new Map<Id,Case>(oldList);
        List<String> statusAttempts = new List<String> {'1st Outreach Attempt','2nd Outreach Attempt','3rd Outreach Attempt'};
        Id sclMarketingRecordTypeId = SCL_GatewayUtils.sclMarketingRecordTypeId;
        try {              
            for (Case case1 : newList) {   
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');            
                Case oldCase = oldMap.get(case1.Id);
                if (case1.RecordTypeId == sclMarketingRecordTypeId) {
                    if (String.isNotBlank(case1.SCL_FormCampaignName__c) && case1.SCL_FormCampaignName__c == 'COVID Vaccine Signup') {
                        // 1st Outreach Attempted is null
                        if (case1.SCL_1stOutreachAttempted__c == null) {
                            case1.Status = '1st Outreach Attempt';
                            case1.SCL_1stOutreachAttempted__c = Date.Today();
                            case1.SCL_OutboundCalls__c = 1;
                        }  
                        if ((oldCase.Status != null) && (case1.Status != null) && (oldCase.Status != case1.Status)) {
                            // Check if the status is one of the attempts.
                            if (statusAttempts.contains(case1.Status)) {                                    
                                if (oldCase.SCL_OutboundCalls__c != null) {
                                    case1.SCL_OutboundCalls__c = oldCase.SCL_OutboundCalls__c + 1;
                                } else {
                                    case1.SCL_OutboundCalls__c = 1;
                                }									
                            }
                            if (case1.Status == 'Closed Scheduled') {
                                case1.SCL_OutboundCalls__c = 0;
                            }
                        }
                    }
                }                                                
            }              
            oldMap = null;            
        } catch (Exception e) {           
            SCL_GatewayUtils.publishException(newList,'update',e);
        }        
  	}	    
}