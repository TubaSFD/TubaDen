public without sharing class SCL_CaseGateway {  
    private static Id pillPlannerRecordTypeId = SCL_GatewayUtils.pillPlannerRecordTypeId;
    private static Id prospectRecordTypeId = SCL_GatewayUtils.prospectRecordTypeId;
    private static Id pharmacyQueueId = SCL_GatewayUtils.pharmacyQueueId;
    private static Id wpBHRecordTypeId = SCL_GatewayUtils.wpBHRecordTypeId;
    private static Id wpFinancialQueueId = SCL_GatewayUtils.wpFinancialQueueId;
    private static List<SCL_CaseToAccountFields__c> ctaFields = SCL_GatewayUtils.ctaFields;
    private static List<SCL_CaseToPlannedOutreachFields__c> ctpFields = SCL_GatewayUtils.ctpFields;     
    private static Map<String,Account> patientSFIdMap = new Map<String,Account>();            
    private static List<Case> casesWoAccount = new List<Case>();                
    private static Set<String> patEmailsWoAccount = new Set<String>();    
    private static Map<String,Account> newAccountMap = new Map<String,Account>();
    private static Map<String,Account> updatedAccountMap = new Map<String,Account>();
    private static string caseTypes = SCL_GatewayUtils.caseRecordTypes;
    
    
    // Get the list of accounts given the list of emails and Cases
    public static Map<String,Account> getCasePatientSFIdMap(Set<String> patientKeys,List<Case> caseList) {                                                        
        newAccountMap = new Map<String,Account>();
        updatedAccountMap = new Map<String,Account>();
        List<List<SObject>> arrayListSObject;
        
        setCasePatientSFIdMap(patientKeys,caseList,true);
        if (!(newAccountMap == null || newAccountMap.isEmpty())) {                             
            if (newAccountMap.size() > SCL_GatewayUtils.DML_SIZE_LIMIT) {                            
                arrayListSObject = SCL_GatewayUtils.getArrayListOfSObject(newAccountMap.Values());                
                Database.insert(((List<Account>) arrayListSObject[0]),false);                
                Database.insert(((List<Account>) arrayListSObject[1]),false);                                  
            } else {                                                
                Database.insert(newAccountMap.values(),false);                               
            }
            setCasePatientSFIdMap(patEmailsWoAccount,casesWoAccount,false);
        }
        
        if (!(updatedAccountMap == null || updatedAccountMap.isEmpty())) {                                         
            if (updatedAccountMap.size() > SCL_GatewayUtils.DML_SIZE_LIMIT) {                
                arrayListSObject = SCL_GatewayUtils.getArrayListOfSObject(updatedAccountMap.Values());                                
                Database.update(((List<Account>) arrayListSObject[0]),false);
                Database.update(((List<Account>) arrayListSObject[1]),false);   
            } else {                                
                Database.update(updatedAccountMap.values(),false);                
            }
        }
        
        setCasePatientSFIdMap(patientKeys,caseList,false);
        newAccountMap = null;
        updatedAccountMap = null;
        arrayListSObject = null;        
        return patientSFIdMap;
    }    
    
    // Build the Case SF Id Map
    private static void setCasePatientSFIdMap(Set<String> patientKeys,List<Case> caseList,Boolean createAccount) {              
        casesWoAccount = new List<Case>();            	
        patEmailsWoAccount = new Set<String>();  
        Account updatedAccount = new Account();
        Account currentAccount = new Account();
        List<Account> accts = new List<Account>();          
        Boolean isCaseMatchedAccount;
        Case case1;
        Integer size = caseList.size(); 
        
        if (caseList.isEmpty()) return;        
        if (!patientKeys.isEmpty()) {                            
            accts = [SELECT Id,PersonContactId,SCL_PersonIdKey__c FROM Account WHERE isPersonAccount=true AND PersonEmail IN :patientKeys];
        }  
        Account acc0;
        Integer acctsSize = accts.size(); 
        
        for (Integer i = 0; i < size; ++i) {         
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                                                    
            currentAccount = null;   
            case1 = caseList[i];
            if (String.isBlank(case1.SCL_PersonIdKey__c)) continue;
            isCaseMatchedAccount = false;                                 
            for (Integer i1 = 0; i1 < acctsSize; ++i1) { 
                acc0 = accts[i1];                
                currentAccount = acc0; 
                if (case1.SCL_PersonIdKey__c == acc0.SCL_PersonIdKey__c) {
                    isCaseMatchedAccount = true;                                    
                    break;
                }                                                                                                     
            }                 
            
            if (isCaseMatchedAccount) {                      
                if (case1.Id == null) {
                    updatedAccount = getUpdatedAccount(case1,currentAccount);                        
                    if (updatedAccount != null) { 
                        currentAccount = updatedAccount;                        
                        updatedAccountMap.put(case1.SCL_PersonIdKey__c,currentAccount);
                    }
                } 
                patientSFIdMap.put(case1.SCL_PersonIdKey__c,currentAccount);                                                                     
            } else if (createAccount) {   
                if ((case1.SCL_FormLastName__c == null) || String.isBlank(case1.SCL_FormLastName__c)) continue;                 
                String patEmail = '';                    
                if (String.isNotBlank(case1.SCL_FormEmail__c)) {
                    patEmail = case1.SCL_FormEmail__c;
                    patEmailsWoAccount.add(patEmail); 
                }
                
                Account acc1 = new Account(FirstName=case1.SCL_FormFirstName__c,LastName=case1.SCL_FormLastName__c,PersonEmail=patEmail,RecordTypeId=prospectRecordTypeId);
                newAccountMap.put(case1.SCL_PersonIdKey__c,getUpdatedAccount(case1,acc1));
                casesWoAccount.add(case1);                                                              
            }                 
        }         
        accts = null;		
    }
    
    // Build the Case Id Map
    public static Map<String,String> getCaseIdKeyMap(List<Case> caseList) { 
        String caseIdKey = '';
        Set<String> caseEmailIdKeySet = new Set<String>();
        Set<String> casePhoneIdKeySet = new Set<String>();
        Map<String,String> caseIdKeyMap = new Map<String,String>();            
        
        for (Case case1 : caseList) {               
            if (String.isNotBlank(case1.SCL_FormEmail__c)) caseEmailIdKeySet.add(case1.SCL_FormEmail__c);
            if (String.isNotBlank(case1.SCL_FormPhone__c)) casePhoneIdKeySet.add(case1.SCL_FormPhone__c);
        }
        
       if (!caseEmailIdKeySet.isEmpty() || !casePhoneIdKeySet.isEmpty()) {                
            for (List<Case> cases : [                                    
                SELECT Id,SCL_FormEmail__c,SCL_FormPhone__c,SCL_FormCampaignName__c,SCL_FormFirstName__c,SCL_FormLastName__c FROM Case WHERE SCL_FormEmail__c IN :caseEmailIdKeySet OR SCL_FormPhone__c IN :casePhoneIdKeySet]) {
                   
                    for (Case case1 : cases) {
                        if(String.isNotBlank(case1.SCL_FormEmail__c)){   
                            caseIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null','');
                            caseIdKeyMap.put(caseIdKey,case1.Id);                                
                        }
                        if(String.isNotBlank(case1.SCL_FormPhone__c)){   
                            caseIdKey = (case1.SCL_FormCampaignName__c + case1.SCL_FormPhone__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowercase().replace('null','');
                            caseIdKeyMap.put(caseIdKey,case1.Id);  
                        }
                    }
                }
           
        }
        caseIdKey = null;
        return caseIdKeyMap;   
    }  
    
    // Build the Case Id List
    public static List<Case> getCases(List<Case> caseList){
        Set<String> caseEmailSet = new Set<String>();
        Set<String> casePhoneSet = new Set<String>();
        
        List<Case> caseList1=new List<Case>();
        List<string> typeList = new List<string>();
        for(string type: caseTypes.split(',')) typeList.add(type);
                
        for (Case case1 : caseList) { 
            if (String.isNotBlank(case1.SCL_FormEmail__c)) caseEmailSet.add(case1.SCL_FormEmail__c);
            if (String.isNotBlank(case1.SCL_FormPhone__c)) casePhoneSet.add(case1.SCL_FormPhone__c);
        }
        for (Case case1 : [SELECT Id FROM Case WHERE (SCL_FormEmail__c In: caseEmailSet OR SCL_FormPhone__c In: casePhoneSet) AND RecordType.DeveloperName In: typeList]) {                
            caseList1.add(case1);                                
        }
        typeList = null;      
        return caseList1;
    }
    
    public static Account getUpdatedAccount(Case case1,Account acc) {                                
        Boolean accountUpdated = false;          
        SCL_CaseToAccountFields__c ctaField;
        Integer ctaSize = ctaFields.size();
        
        if (acc != null) {  
            // Copy or set the Case fields to Account fields                   
            for (Integer i = 0; i < ctaSize; ++i) { 
                ctaField = ctaFields[i];
                if (case1.get(ctaField.SCL_CaseField__c) != null) {
                    // Update Accounts cp fields only when the trigger is 'insert'.
                    if ((case1.Id != null) && (ctaField.SCL_FieldCategory__c == 'cp')) continue;                                
                    
                    if (ctaField.SCL_Action__c == 'copy') {
                        acc.put(ctaField.SCL_AccountField__c,case1.get(ctaField.SCL_CaseField__c));
                        accountUpdated = true;
                    } else if (ctaField.SCL_Action__c == 'set') {
                        if (SCL_GatewayUtils.isMatchedValue(String.valueOf(case1.get(ctaField.SCL_CaseField__c)),ctaField.SCL_SourceValueType__c,ctaField.SCL_SourceValue__c)) {
                            switch on ctaField.SCL_DestinationValueType__c {
                                when 'Boolean' { acc.put(ctaField.SCL_AccountField__c,Boolean.valueOf(ctaField.SCL_DestinationValue__c)); }
                                when 'Integer' { acc.put(ctaField.SCL_AccountField__c,Integer.valueOf(ctaField.SCL_DestinationValue__c)); }
                                when 'Double' { acc.put(ctaField.SCL_AccountField__c,Double.valueOf(ctaField.SCL_DestinationValue__c)); }
                                when else { acc.put(ctaField.SCL_AccountField__c,ctaField.SCL_DestinationValue__c); }
                            }
                            accountUpdated = true;
                        }
                    } 
                }
            }                
        }                   
        if (accountUpdated) {
            return acc;
        } else {
            return null;
        }
    }
    
    // Close West Pines Case.       
    public static void closeWPCase(List<Case> cases) { 
        List<String> wpClosedReviewChart = new List<String> {'Patient Inappropriate','Patient left AMA','Reached Therapeutic Limit'};        
            Map<String,Account> wpAccountMap = new Map<String,Account>();
        Account wpAccount;
        Case case1;
        Integer size = cases.size(); 
        
        for (Integer i = 0; i < size; ++i) {         
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                        
            case1 = cases[i];
            if (case1.RecordTypeId != wpBHRecordTypeId) continue;
            if (String.isNotBlank(case1.SCL_ClosedReason__c) && wpClosedReviewChart.contains(case1.SCL_ClosedReason__c)) {                                    
                wpAccount = new Account();
                wpAccount.Id = case1.AccountId;
                wpAccount.SCL_WestPinesPatientWarning__c = case1.SCL_ClosedReason__c + ' - please review chart';
                wpAccountMap.put(case1.AccountId,wpAccount);
            }                    
            
            if (wpAccountMap.size() == SCL_GatewayUtils.DML_SIZE_LIMIT) {
                update wpAccountMap.Values();
                wpAccountMap.clear();
            }                
        } 
        if (wpAccountMap.size() > 0) {
            update wpAccountMap.Values();
        }        
        wpAccountMap = null;        
    }
    
    // Create Planned Outreach and update Case from Case record.       
    public static List<Case> getRouteCaseToTeam(List<Case> newList, List<Case> oldList) {        
        List<Case> updatedCaseList = new List<Case>();
        Map<Id,Case> oldMap = null;        
        if (oldList != null) oldMap = new Map<Id,Case>(oldList);
        Case oldCase = null;
        Case case1;
        Integer size = newList.size(); 
        
        for (Integer i = 0; i < size; ++i) {           
            case1 = newList[i];
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                                        
            if (case1.SCL_FormCampaignName__c == 'pill planner') {            
                if (pillPlannerRecordTypeId != null) case1.RecordTypeId = pillPlannerRecordTypeId;
                if (pharmacyQueueId != null && case1.SCL_CaseAssigned__c == null) case1.OwnerId = pharmacyQueueId;
                case1.SCL_CaseAssigned__c = 'PB Routing Rule Applied';                 
            }                                         
            if (case1.RecordTypeId == wpBHRecordTypeId) {                    
                if (oldMap != null) {
                    oldCase = oldMap.get(case1.Id);
                    // Evaluate WestPines Epic Appointment Status when changed                                            
                    if (case1.SCL_EpicLatestApptStatus__c != null && (oldCase.SCL_EpicLatestApptStatus__c != case1.SCL_EpicLatestApptStatus__c)) {                        
                        case1.Status = 'Appt ' + case1.SCL_EpicLatestApptStatus__c;
                    }
                }
                // Evaluate WestPines Status when changed to 'Pending Verification' and assign the case to WP Financial Counselor queue
                if ((case1.Status == 'Pending Verification') && !case1.IsClosed) {                        
                    if (wpFinancialQueueId  != null) {
                        case1.OwnerId = wpFinancialQueueId;
                    }
                }                     
            }            
            updatedCaseList.add(case1);
        }
        return updatedCaseList;
    }
    
    // update Case when PO is needed.   
    public static caseWithPO getUpdatedCasesWithPO(List<Case> cases) {			
        caseWithPO caseWithPO = new caseWithPO();
        List<Case> updatedCaseList = new List<Case>();        
        Boolean withPO = false;        
        String prevCampaignName = '';
        String campaignNumber = ''; 
        Case case1;
        Integer size = cases.size(); 
        
        for (Integer i = 0; i < size; ++i) {                 
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                            
            case1 = cases[i];
            if (String.isBlank(case1.SCL_FormCampaignName__c)) continue;   
            if (case1.SCL_FormCampaignName__c != prevCampaignName) {                
                campaignNumber = SCL_GatewayUtils.poCampaignMap.get(case1.SCL_FormCampaignName__c);                                        	            	            	
                prevCampaignName = case1.SCL_FormCampaignName__c;                   
                if (!withPO) withPO = true;                
            }
            if (String.isNotBlank(campaignNumber)) {
                case1.SCL_CampaignNumber__c = campaignNumber;
                case1.SCL_SentToPlannedOutreach__c = true;   
            }              
            updatedCaseList.add(case1);
        } 
        caseWithPO.caseList = updatedCaseList;
        caseWithPO.withPO = withPO;        
        updatedCaseList = null;        
        return caseWithPO;
    }
    
    // Create Planned Outreach.       
    public static void createPlannedOutreach(List<Case> cases) {         
        List<SCL_PlannedOutreach__c> newPOList = new List<SCL_PlannedOutreach__c>();        
        SCL_PlannedOutreach__c po;
        String prevCampaignName = '';
        String campaignNumber = '';
        Case case1;
        Integer size = cases.size(); 
        SCL_CaseToPlannedOutreachFields__c ctpField;
        Integer ctpSize = ctpFields.size();
        
        try {                                    
            for (Integer i = 0; i < size; ++i) {                 
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                                            
                case1 = cases[i];
                if (!case1.SCL_SentToPlannedOutreach__c) continue;
                po = new SCL_PlannedOutreach__c();                                				                            	                
                po.SCL_CampaignNumber__c = case1.SCL_CampaignNumber__c;
                po.SCL_ExternalID__c = (case1.SCL_CampaignNumber__c + case1.SCL_FormFirstName__c + case1.SCL_FormEmail__c).toLowercase();                    
                if (String.isNotBlank(case1.AccountId)) {
                    po.SCL_PersonAccount__c = case1.AccountId;
                    po.SCL_ContactSFID__c = case1.ContactId;
                }
                
                for (Integer i1 = 0; i1 < ctpSize; ++i1) {  
                    if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                            
                    ctpField = ctpFields[i1];
                    if (case1.get(ctpField.SCL_CaseField__c) != null) {
                        if (ctpField.SCL_Action__c == 'copy') {
                            po.put(ctpField.SCL_PlannedOutreachField__c,case1.get(ctpField.SCL_CaseField__c));
                        } else if (ctpField.SCL_Action__c == 'set') {
                            if (SCL_GatewayUtils.isMatchedValue(String.valueOf(case1.get(ctpField.SCL_CaseField__c)),ctpField.SCL_SourceValueType__c,ctpField.SCL_SourceValue__c)) {
                                switch on ctpField.SCL_DestinationValueType__c {
                                    when 'Boolean' { po.put(ctpField.SCL_PlannedOutreachField__c,Boolean.valueOf(ctpField.SCL_DestinationValue__c)); }
                                    when 'Integer' { po.put(ctpField.SCL_PlannedOutreachField__c,Integer.valueOf(ctpField.SCL_DestinationValue__c)); }
                                    when 'Double' { po.put(ctpField.SCL_PlannedOutreachField__c,Double.valueOf(ctpField.SCL_DestinationValue__c)); }
                                    when else { po.put(ctpField.SCL_PlannedOutreachField__c,ctpField.SCL_DestinationValue__c); }
                                }
                            }
                        } 
                    }                                        
                }                
                newPOList.add(po);                                                       
                if (newPOList.size() == SCL_GatewayUtils.DML_SIZE_LIMIT) {                                
                    Database.upsert(newPOList, SCL_PlannedOutreach__c.SCL_ExternalID__c, false);
                    newPOList.clear();
                }
            }                             			               
            if (!newPOList.isEmpty()) Database.upsert(newPOList, SCL_PlannedOutreach__c.SCL_ExternalID__c, false);            
            newPOList = null;            
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(cases,'update',e);
        }
    }   
    
    
    // Wrapper Class
    public class caseWithPO {
        public List<Case> caseList;
        public Boolean withPO;        
    }
}