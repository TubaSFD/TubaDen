public class SCL_TA_PO_BU_UpdateWithCase {
    private static SCL_TA_PO_BU_UpdateWithCase instance;
    
    public SCL_TA_PO_BU_UpdateWithCase() {
    }
    
    public static SCL_TA_PO_BU_UpdateWithCase getInstance() {
        if (SCL_TA_PO_BU_UpdateWithCase.instance == null) {
            SCL_TA_PO_BU_UpdateWithCase.instance = new SCL_TA_PO_BU_UpdateWithCase();
        }
        return SCL_TA_PO_BU_UpdateWithCase.instance;
    }
    
    public Boolean withCase { get; private set; }
    
    public class Service implements TriggerAction.BeforeUpdate {
        public void beforeUpdate(List<SCL_PlannedOutreach__c> newList, List<SCL_PlannedOutreach__c> oldList) {                        
            try {                                 
                SCL_POGateway.poWithCase poWithCase = SCL_POGateway.getUpdatedPOsWithCase(newList);                
                newList = poWithCase.poList; 
                SCL_TA_PO_BU_UpdateWithCase.getInstance().withCase = poWithCase.withCase;                
                poWithCase = null;                
            } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }        
        }              
    }
}