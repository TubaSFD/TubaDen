/*
Name: SCL_TA_Case_BI_AccountQueries
Purpose: Account queries for Person Account
Author: Allan Casalla
Date: 12/21/2021

Change Log
08/16/2022 - Tuba Ciftci - Called SCL_GatewayUtils class with releated method to format the phone number fields of Case Object.
*/
public class SCL_TA_Case_BI_AccountQueries {
    private static SCL_TA_Case_BI_AccountQueries instance;
    
    public SCL_TA_Case_BI_AccountQueries() {
    }
    
    public static SCL_TA_Case_BI_AccountQueries getInstance() {
        if (SCL_TA_Case_BI_AccountQueries.instance == null) {
            SCL_TA_Case_BI_AccountQueries.instance = new SCL_TA_Case_BI_AccountQueries();
        }
        return SCL_TA_Case_BI_AccountQueries.instance;
    }
    
    public Map<String, Account> beforeCaseAccountMap { get; private set; }
    
    public class Service implements TriggerAction.BeforeInsert {    
        public void beforeInsert(List<Case> newList) {    	    	        
            Set<String> patientIdSet = new Set<String>();  
            
            try {            
                for (Case case1 : newList) {                   
                    if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');
                    if (String.isNotBlank(case1.SCL_FormInsurerPhone__c)) case1.SCL_FormInsurerPhone__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormInsurerPhone__c); 
                    if (String.isNotBlank(case1.SCL_FormPhone__c)) case1.SCL_FormPhone__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormPhone__c);
                    if (String.isNotBlank(case1.SCL_FormSubmitterPhone__c)) case1.SCL_FormSubmitterPhone__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormSubmitterPhone__c);
                    if (String.isNotBlank(case1.SCL_FormWPOfficePhone__c)) case1.SCL_FormWPOfficePhone__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_FormWPOfficePhone__c);
                    if (String.isNotBlank(case1.SCL_OtherPhone__c)) case1.SCL_OtherPhone__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_OtherPhone__c);
                    if (String.isNotBlank(case1.SCL_SecSubscriberEmployerPhoneNumber__c)) case1.SCL_SecSubscriberEmployerPhoneNumber__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_SecSubscriberEmployerPhoneNumber__c);
                    if (String.isNotBlank(case1.SCL_SubscriberEmployerPhoneNumber__c)) case1.SCL_SubscriberEmployerPhoneNumber__c = SCL_GatewayUtils.formatPhoneNumber(case1.SCL_SubscriberEmployerPhoneNumber__c);
                    if (String.isBlank(case1.AccountId)) {                            
                        if (String.isNotBlank(case1.SCL_FormEmail__c)) {                                
                            patientIdSet.add(case1.SCL_FormEmail__c);                            
                        }                 
                    }    
                }
                
                // Create map of Case Id values and Person Account                     
                SCL_TA_Case_BI_AccountQueries.getInstance().beforeCaseAccountMap = SCL_CaseGateway.getCasePatientSFIdMap(patientIdSet,newList);        			                
                patientIdSet = null;                
            } catch (Exception e) {            
                SCL_GatewayUtils.publishException(newList,'insert',e);
            }
        }              
    }
}