public class SCL_TA_Case_BI_UpdateWithPlannedOutreach {
    private static SCL_TA_Case_BI_UpdateWithPlannedOutreach instance;
    
    public SCL_TA_Case_BI_UpdateWithPlannedOutreach() {
    }
    
    public static SCL_TA_Case_BI_UpdateWithPlannedOutreach getInstance() {
        if (SCL_TA_Case_BI_UpdateWithPlannedOutreach.instance == null) {
            SCL_TA_Case_BI_UpdateWithPlannedOutreach.instance = new SCL_TA_Case_BI_UpdateWithPlannedOutreach();
        }
        return SCL_TA_Case_BI_UpdateWithPlannedOutreach.instance;
    }
    
    public Boolean withPO { get; private set; }
    
    public class Service implements TriggerAction.BeforeInsert {    
        public void beforeInsert(List<Case> newList) {    	    	        
            try {                 
                SCL_CaseGateway.caseWithPO caseWithPO = SCL_CaseGateway.getUpdatedCasesWithPO(newList);                
                newList = caseWithPO.caseList; 
                SCL_TA_Case_BI_UpdateWithPlannedOutreach.getInstance().withPO = caseWithPO.withPO;                
                caseWithPO = null;                
            } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'insert',e); }        
        }              
    }
}