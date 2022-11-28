public class SCL_TA_Case_BU_AccountQueries {
    private static SCL_TA_Case_BU_AccountQueries instance;
    
    public SCL_TA_Case_BU_AccountQueries() {
    }
    
    public static SCL_TA_Case_BU_AccountQueries getInstance() {
        if (SCL_TA_Case_BU_AccountQueries.instance == null) {
            SCL_TA_Case_BU_AccountQueries.instance = new SCL_TA_Case_BU_AccountQueries();
        }
        return SCL_TA_Case_BU_AccountQueries.instance;
    }
    
    public Map<String, Account> beforeCaseAccountMap { get; private set; }
    
    public class Service implements TriggerAction.BeforeUpdate {
        public void beforeUpdate(List<Case> newList, List<Case> oldList) {
            List<Case> newUpdatedList = new List<Case>();
            Set<String> patientIdSet = new Set<String>();   
            
            try {
                for (Case case1 : newList) {		
                    if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');
                    if(String.isNotBlank(case1.SCL_FormInsurerPhone__c))  case1.SCL_FormInsurerPhone__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormInsurerPhone__c); 
                    if(String.isNotBlank(case1.SCL_FormPhone__c))  case1.SCL_FormPhone__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormPhone__c);
                    if(String.isNotBlank(case1.SCL_FormSubmitterPhone__c))  case1.SCL_FormSubmitterPhone__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormSubmitterPhone__c);
                    if(String.isNotBlank(case1.SCL_FormWPOfficePhone__c))  case1.SCL_FormWPOfficePhone__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormWPOfficePhone__c);
                    if(String.isNotBlank(case1.SCL_OtherPhone__c))  case1.SCL_OtherPhone__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_OtherPhone__c);
                    if(String.isNotBlank(case1.SCL_EmergencyContactNumber__c))  case1.SCL_EmergencyContactNumber__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_EmergencyContactNumber__c);
                    if(String.isNotBlank(case1.SCL_SecSubscriberEmployerPhoneNumber__c))  case1.SCL_SecSubscriberEmployerPhoneNumber__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_SecSubscriberEmployerPhoneNumber__c);
                    if(String.isNotBlank(case1.SCL_SubscriberEmployerPhoneNumber__c))  case1.SCL_SubscriberEmployerPhoneNumber__c=SCL_GatewayUtils.formatPhoneNumber(case1.SCL_SubscriberEmployerPhoneNumber__c);                   
                    if (String.isBlank(case1.AccountId) || String.isBlank(case1.ContactId)) {                            
                        if (String.isNotBlank(case1.SCL_FormEmail__c)) patientIdSet.add(case1.SCL_FormEmail__c);                                                                               
                        newUpdatedList.add(case1);
                    }
                }            
                // Create map of Case Id values and Person Account        
                if (!newUpdatedList.isEmpty()) SCL_TA_Case_BU_AccountQueries.getInstance().beforeCaseAccountMap = SCL_CaseGateway.getCasePatientSFIdMap(patientIdSet,newUpdatedList);                
                newUpdatedList = null;
                patientIdSet = null;                
            } catch (Exception e) { SCL_GatewayUtils.publishException(newList,'update',e); }
        }              
    }
}