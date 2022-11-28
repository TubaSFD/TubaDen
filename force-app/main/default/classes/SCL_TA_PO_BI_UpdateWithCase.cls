public class SCL_TA_PO_BI_UpdateWithCase {
    private static SCL_TA_PO_BI_UpdateWithCase instance;
    
    public SCL_TA_PO_BI_UpdateWithCase() {
    }
    
    public static SCL_TA_PO_BI_UpdateWithCase getInstance() {
        if (SCL_TA_PO_BI_UpdateWithCase.instance == null) {
            SCL_TA_PO_BI_UpdateWithCase.instance = new SCL_TA_PO_BI_UpdateWithCase();
        }
        return SCL_TA_PO_BI_UpdateWithCase.instance;
    }
    
    public Boolean withCase { get; private set; }
    
    public class Service implements TriggerAction.BeforeInsert {    
        public void beforeInsert(List<SCL_PlannedOutreach__c> newList) {    	    	        
            try { 
                SCL_POGateway.poWithCase poWithCase = SCL_POGateway.getUpdatedPOsWithCase(newList);                
                newList = poWithCase.poList; 
                SCL_TA_PO_BI_UpdateWithCase.getInstance().withCase = poWithCase.withCase;                
                poWithCase = null;                
            } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }      
        }              
    }
}