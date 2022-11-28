public class SCL_TA_Case_BI_CheckDuplicateRecord implements TriggerAction.BeforeInsert {  
    public void beforeInsert(List<Case> newList) { 
        if (newList.isEmpty()) return;
        if (SCL_CaseGateway.getCases(newList).isEmpty()) return;        
        try {            
            // Create map of Case id keys           
            Map<String,String> caseIdKeyMap = SCL_CaseGateway.getCaseIdKeyMap(newList);
            system.debug('caseIdKeyMap '+caseIdKeyMap);
            String caseIdKey = '';
            if (newList != null && !newList.isEmpty()) {
                for (Case case1 : newList) {
                    if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');
                    if(String.isNotBlank(case1.SCL_FormEmail__c)){
                        caseIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null','');
                        system.debug('caseEmailIdKey '+caseIdKey);

                    }   
                    if(String.isNotBlank(case1.SCL_FormPhone__c)){
                        caseIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormPhone__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null',''); 
                         system.debug('casePhoneIdKey '+caseIdKey);

                    }
                    if (String.isBlank(caseIdKey)) continue;
                    if (!caseIdKeyMap.containsKey(caseIdKey)) {
                        case1.SCL_ExternalID__c = caseIdKey;
                        system.debug('case1.SCL_ExternalID__c '+case1.SCL_ExternalID__c);
                    }
                    else { 
                        case1.addError('Case Trigger Error: This is a possible duplicate record. Please confirm that the Case is different from the record found (Case Id: ' + caseIdKeyMap.get(caseIdKey) + ').');
                    } 
                }    
            }
            caseIdKey = null;
            caseIdKeyMap = null; 
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'insert',e);
        }
    }	    
}