public class SCL_TA_PO_BI_CreateCase {
    /*
    //public class SCL_TA_PO_BI_CreateCase implements TriggerAction.BeforeInsert {
	private static List<SCL_CreateCampaign__c> poCaseCampaigns = [SELECT SCL_CampaignNumber__c,SCL_DestinationObject__c,SCL_RecordTypeName__c FROM SCL_CreateCampaign__c WHERE SCL_SourceObject__c='SCL_PlannedOutreach__c' AND SCL_DestinationObject__c = 'Case' AND SCL_CampaignNumber__c !=NULL AND SCL_Active__c=true];        
	public void beforeInsert(List<SCL_PlannedOutreach__c> newList) { 
        if (newList.isEmpty()) return;
        
		List<Case> newCases = new List<Case>();        
        Map<String,String> caseCampaignMap = new Map<String,String>();                     
        // Map the Case Campaigns
        for (SCL_CreateCampaign__c pocc : poCaseCampaigns) {              	
            caseCampaignMap.put(pocc.SCL_CampaignNumber__c,pocc.SCL_RecordTypeName__c);                            	
        }
        
        for (SCL_PlannedOutreach__c po : newList) { 
        	if (String.isNotBlank(po.SCL_CampaignNumber__c)) {
                // Assign external id if not populated
            	if (String.isBlank(po.SCL_ExternalID__c)) {
                    po.SCL_ExternalID__c = String.isNotBlank(po.SCL_MRN__c) ? (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_MRN__c) : (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_Email__c);                    
            	}
				
                if (String.isNotBlank(po.SCL_Source__c)) {
                    po.SCL_RecordTypeName__c = caseCampaignMap.get(po.SCL_CampaignNumber__c);
                    if (po.SCL_RecordTypeName__c == null) continue;
                    Case newCase = SCL_POGateway.getCase(po);
                    if (newCase != null) {
                        newCases.add(newCase);
                        po.SCL_CaseCreated__c = true;
                    }
                }
            }
        } 
        if (!newCases.isEmpty()) insert newCases;                          
  	}	   
	*/
}