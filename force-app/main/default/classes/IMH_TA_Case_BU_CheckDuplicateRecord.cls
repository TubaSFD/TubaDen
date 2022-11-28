public class IMH_TA_Case_BU_CheckDuplicateRecord implements TriggerAction.BeforeUpdate {
    public void beforeUpdate(List<Case> newList,List<Case> oldList) { 
        if (newList.isEmpty()) return;
        if (SCL_CaseGateway.getCases(newList).isEmpty()) return;        
        try {            
            // Create map of Case id keys           
            Map<String,String> caseIdKeyMap = SCL_CaseGateway.getCaseIdKeyMap(newList);
            system.debug('caseIdKeyMap '+caseIdKeyMap);
            String caseEmailIdKey = '';
            String casePhoneIdKey = '';
            for (Case case1 : newList) {
                
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');
                caseEmailIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null','');
                
                casePhoneIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormPhone__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null',''); 
                
                if (String.isBlank(caseEmailIdKey)) continue;
                if (!caseIdKeyMap.containsKey(caseEmailIdKey)) {
                    case1.SCL_ExternalID__c = caseEmailIdKey;
                }
                else if(case1.id != caseIdKeyMap.get(caseEmailIdKey)){
                    case1.addError('Case Trigger Error: This is a possible duplicate record. Please confirm that the Case is different from the record found (Case Id: ' + caseIdKeyMap.get(caseEmailIdKey) + ').');
                } 
                if (String.isBlank(casePhoneIdKey)) continue;
                if (!caseIdKeyMap.containsKey(casePhoneIdKey)) {
                    case1.SCL_ExternalID__c = casePhoneIdKey;
                }
                else if(case1.id != caseIdKeyMap.get(casePhoneIdKey)){
                    case1.addError('Case Trigger Error: This is a possible duplicate record. Please confirm that the Case is different from the record found (Case Id: ' + caseIdKeyMap.get(casePhoneIdKey) + ').');
                } 
            } 
            caseEmailIdKey = null;
            caseIdKeyMap = null;            
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'update',e);
        }
    }	    
}