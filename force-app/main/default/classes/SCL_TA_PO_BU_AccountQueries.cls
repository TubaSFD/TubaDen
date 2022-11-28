public class SCL_TA_PO_BU_AccountQueries {
    private static SCL_TA_PO_BU_AccountQueries instance;
    
    public SCL_TA_PO_BU_AccountQueries() {
    }
    
    public static SCL_TA_PO_BU_AccountQueries getInstance() {
        if (SCL_TA_PO_BU_AccountQueries.instance == null) {
            SCL_TA_PO_BU_AccountQueries.instance = new SCL_TA_PO_BU_AccountQueries();
        }
        return SCL_TA_PO_BU_AccountQueries.instance;
    }
    
    public Map<String, Account> beforePOAccountMap { get; private set; }
    
    public class Service implements TriggerAction.BeforeUpdate {
        public void beforeUpdate(List<SCL_PlannedOutreach__c> newList, List<SCL_PlannedOutreach__c> oldList) {            
            List<SCL_PlannedOutreach__c> newUpdatedList = new List<SCL_PlannedOutreach__c>();
            Set<String> patientIdSet = new Set<String>();
            Set<String> patientEmailSet = new Set<String>(); 
            
            try {
                for (SCL_PlannedOutreach__c po : newList) {
                    if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');
                    if(String.isNotBlank(po.SCL_Phone__c))  po.SCL_Phone__c=SCL_GatewayUtils.formatPhoneNumber(po.SCL_Phone__c) ;                    
                    if (String.isBlank(po.SCL_PersonAccount__c) || String.isBlank(po.SCL_ContactSFID__c)) {             
                        if (String.isNotBlank(po.SCL_MRN__c)) {                                                    
                            patientIdSet.add(po.SCL_MRN__c); 
                        } else if (String.isNotBlank(po.SCL_Email__c)) {                                
                            patientEmailSet.add(po.SCL_Email__c);                            
                        }  
                        newUpdatedList.add(po);
                    }
                }
                
                // Create map of Epic patient Id values and associated SF Ids from Person Account        
                if (!newUpdatedList.isEmpty()) SCL_TA_PO_BU_AccountQueries.getInstance().beforePOAccountMap = SCL_POGateway.getPOPatientSFIdMap(patientIdSet,patientEmailSet,newUpdatedList);                
                patientIdSet = null;
                patientEmailSet = null;
                newUpdatedList = null;                
            } catch (Exception e) {
                SCL_GatewayUtils.publishException(newList,'update',e);
            }
        }              
    }
}