public class SCL_TA_Case_BU_UpdateWithPlannedOutreach {
    private static SCL_TA_Case_BU_UpdateWithPlannedOutreach instance;
    
    public SCL_TA_Case_BU_UpdateWithPlannedOutreach() {
    }
    
    public static SCL_TA_Case_BU_UpdateWithPlannedOutreach getInstance() {
        if (SCL_TA_Case_BU_UpdateWithPlannedOutreach.instance == null) {
            SCL_TA_Case_BU_UpdateWithPlannedOutreach.instance = new SCL_TA_Case_BU_UpdateWithPlannedOutreach();
        }
        return SCL_TA_Case_BU_UpdateWithPlannedOutreach.instance;
    }
    
    public Boolean withPO { get; private set; }
    
    public class Service implements TriggerAction.BeforeUpdate {
        public void beforeUpdate(List<Case> newList, List<Case> oldList) {                        
            try {                 
                SCL_CaseGateway.caseWithPO caseWithPO = SCL_CaseGateway.getUpdatedCasesWithPO(newList);                
                newList = caseWithPO.caseList; 
                SCL_TA_Case_BU_UpdateWithPlannedOutreach.getInstance().withPO = caseWithPO.withPO;                
                caseWithPO = null;                
            } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }        
        }              
    }
}