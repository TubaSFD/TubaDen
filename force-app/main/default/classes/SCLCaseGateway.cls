public without sharing class SCLCaseGateway {
    /*
    private static Id prospectRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Account' AND Name='Prospect' LIMIT 1].Id;
    private static List<SCL_CaseToAccountFields__c> ctaFields = [SELECT Id, SCL_AccountField__c,SCL_Action__c,SCL_CaseField__c,SCL_DestinationValue__c,SCL_DestinationValueType__c,SCL_FieldCategory__c,SCL_SourceValue__c,SCL_SourceValueType__c FROM SCL_CaseToAccountFields__c WHERE SCL_Active__c=true];
    private static List<SCL_CaseToPlannedOutreachFields__c> ctpFields = [SELECT Id, SCL_PlannedOutreachField__c,SCL_Action__c,SCL_CaseField__c,SCL_DestinationValue__c,SCL_DestinationValueType__c,SCL_FieldCategory__c,SCL_SourceValue__c,SCL_SourceValueType__c FROM SCL_CaseToPlannedOutreachFields__c WHERE SCL_Active__c=true];
    // Get the list of accounts given the list of emails and cases
    public static Map<String,Account> getPatientSFId(List<String> patientEmails,List<Case> caseList) {        
        List<Account> existingAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();
        Map<String,Account> patientIdSFIdMap = new Map<String,Account>();
        Set<String> patientIdOfNoMatchingAcct = new Set<String>();
        String patientIdKey;
        Boolean isCaseMatchedAccount = false;
        try {            
            List<Account> acc = [SELECT Id,PersonContactId,FirstName,LastName,SCL_MRNPersonAccount__c,PersonEmail FROM Account WHERE PersonEmail IN :patientEmails];
            if (!acc.isEmpty()) {   
                for (Case case1 : caseList) {                                        
                    System.debug('SCLCaseGateway(getPatientSFId: Case Information): case1.SCL_FormFirstName__c:'+case1.SCL_FormFirstName__c+' ;case1.SCL_FormLastName__c:'+case1.SCL_FormLastName__c);                            
                    if (String.isNotBlank(case1.SCL_FormEmail__c) && String.isNotBlank(case1.SCL_FormFirstName__c) && String.isNotBlank(case1.SCL_FormLastName__c)) {                                
                        patientIdKey = (case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c + case1.SCL_FormLastName__c).toLowerCase().replaceAll('[^a-zA-Z0-9]','');
                    	isCaseMatchedAccount = false;
                    	for (Account acc0 : acc) {           
                            if (String.isNotBlank(acc0.PersonEmail) && acc0.PersonEmail.toLowerCase() == case1.SCL_FormEmail__c.toLowerCase() && 
                                String.isNotBlank(acc0.FirstName) && acc0.FirstName.toLowerCase() == case1.SCL_FormFirstName__c.toLowerCase() && 
                                acc0.LastName.toLowerCase() == case1.SCL_FormLastName__c.toLowerCase()) {                               
                                    Account acc1 = getUpdatedAccount(case1,acc0,'update');
                                    existingAccounts.add(acc1);
                                    patientIdSFIdMap.put(patientIdKey,acc1); 
                                    isCaseMatchedAccount = true;
                                    break;
                            }                               
                        }
                        if (!isCaseMatchedAccount) {
                            System.debug('SCLCaseGateway(getPatientSFId: No matching account): case1.SCL_FormFirstName__c:'+case1.SCL_FormFirstName__c+' ;case1.SCL_FormLastName__c:'+case1.SCL_FormLastName__c);                            
                            if (!patientIdOfNoMatchingAcct.contains(patientIdKey)) {                                       
                                Account acc2 = new Account(FirstName=case1.SCL_FormFirstName__c,LastName=case1.SCL_FormLastName__c,PersonEmail=case1.SCL_FormEmail__c);
                                Account acc3 = getUpdatedAccount(case1,acc2,'insert');                            
                                newAccounts.add(acc3);
                                patientIdOfNoMatchingAcct.add(patientIdKey);
                            }
                        }
                	}
                }            	
                
                System.debug('SCLCaseGateway(getPatientSFId: Accounts to be updated):existingAccounts:'+existingAccounts);                
                // Update accounts with the CP fields.
                if (!existingAccounts.isEmpty()) {   
                    update existingAccounts;
                }
                System.debug('SCLCaseGateway(getPatientSFId: Accounts to be inserted):newAccounts:'+newAccounts);                
                if (!newAccounts.isEmpty()) {                   
                    insert newAccounts;
                    for (Account acc4 : newAccounts) {
                        patientIdKey = (acc4.PersonEmail + acc4.FirstName + acc4.LastName).toLowerCase().replaceAll('[^a-zA-Z0-9]','');                        
                    	patientIdSFIdMap.put(patientIdKey,acc4);
                    }					
                }
            } else {
                // Create new Account for case with no Account
                System.debug('Cases with no Account:'+caseList);                
                for (Case case1 : caseList) {
                    System.debug('SCLCaseGateway(getPatientSFId: Account does not exist): case1.SCL_FormFirstName__c:'+case1.SCL_FormFirstName__c+' ;case1.SCL_FormLastName__c:'+case1.SCL_FormLastName__c);                            
                    if (String.isNotBlank(case1.SCL_FormEmail__c) && String.isNotBlank(case1.SCL_FormFirstName__c) && String.isNotBlank(case1.SCL_FormLastName__c)) {
                        Account acc5 = new Account(FirstName=case1.SCL_FormFirstName__c,LastName=case1.SCL_FormLastName__c,PersonEmail=case1.SCL_FormEmail__c);                        
                        Account acc6 = getUpdatedAccount(case1,acc5,'insert');
                        newAccounts.add(acc6);
                    }
                }
                System.debug('SCLCaseGateway(getPatientSFId: Accounts to be inserted that do not exist in the system):'+newAccounts);                
                if (!newAccounts.isEmpty()) {
                    insert newAccounts;                     
                    for (Account acc7 : newAccounts) {
                        patientIdKey = (acc7.PersonEmail + acc7.FirstName + acc7.LastName).toLowerCase().replaceAll('[^a-zA-Z0-9]','');                        
                    	patientIdSFIdMap.put(patientIdKey,acc7);
                    }
                }
            }   
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return patientIdSFIdMap;
    }
    
    public static Account getUpdatedAccount(Case case1, Account acc, String action) {
        if (action == 'insert') {
            acc.RecordTypeId = prospectRecordTypeId;
        }
        // Populate the available Case to Account fields
        for (SCL_CaseToAccountFields__c ctaField: ctaFields) {
            if (case1.get(ctaField.SCL_CaseField__c) != null) {
                if (ctaField.SCL_Action__c == 'copy') {
                    acc.put(ctaField.SCL_AccountField__c,case1.get(ctaField.SCL_CaseField__c));
                } else if (ctaField.SCL_Action__c == 'set') {
                    if (isMatchedValue(String.valueOf(case1.get(ctaField.SCL_CaseField__c)),ctaField.SCL_SourceValueType__c,ctaField.SCL_SourceValue__c)) {
                        switch on ctaField.SCL_DestinationValueType__c {
                            when 'Boolean' { acc.put(ctaField.SCL_AccountField__c,Boolean.valueOf(ctaField.SCL_DestinationValue__c)); }
                            when 'Integer' { acc.put(ctaField.SCL_AccountField__c,Integer.valueOf(ctaField.SCL_DestinationValue__c)); }
                            when 'Double' { acc.put(ctaField.SCL_AccountField__c,Double.valueOf(ctaField.SCL_DestinationValue__c)); }
                            when else { acc.put(ctaField.SCL_AccountField__c,ctaField.SCL_DestinationValue__c); }
                        }
                    }
                } 
            }
        }
        return acc;
    }
    
	// Using a list of emails, get a list of Case records that matches the SCL_FormEmail__c.   
    public static Map<String,Case> getMatchCases(List<String> emails) {
        Map<String,Case> currentMatchCasesMap = new Map<String,Case>();
        List<Case> cases = [SELECT Id,CaseNumber,SCL_FormEmail__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c FROM Case WHERE SCL_FormEmail__c IN :emails AND isClosed=false];
        String caseKey;
        for (Case case1 : cases) {
            caseKey = '';
            if (String.isNotBlank(case1.SCL_FormCampaignName__c)) {
                caseKey = case1.SCL_FormCampaignName__c;
            }
			if (String.isNotBlank(case1.SCL_FormEmail__c)) {
                caseKey = caseKey + case1.SCL_FormEmail__c;
            }            
            if (String.isNotBlank(case1.SCL_FormFirstName__c)) {
                caseKey = caseKey + case1.SCL_FormFirstName__c;
            }
            if (String.isNotBlank(case1.SCL_FormLastName__c)) {
                caseKey = caseKey + case1.SCL_FormLastName__c;
            }
            
        	if (!currentMatchCasesMap.containsKey(caseKey)) {
            	currentMatchCasesMap.put(caseKey,case1);
            }            
        }
  
        return currentMatchCasesMap;
    }
    
    // Get PersonContactId given the list of AccountIds
    public static Map<Id,Id> getPersonAccountId(List<String> accountIds) {
        System.debug('(getPersonAccountId) accountIds:'+accountIds);
        Map<Id,Id> personContactIdMap = new Map<Id,Id>();          
        List<Account> acc = [SELECT Id,PersonContactId FROM Account WHERE Id IN :accountIds];
        if (!acc.isEmpty()) {  
            for (Account acc0 : acc) {  
                personContactIdMap.put(acc0.Id,acc0.PersonContactId);                 
            }
        } 
        return personContactIdMap;
    }
    // Create new Planned Outreach record.   
    public static void CreatePlannedOutreach (List<Case> caseList) {
        try {
            List<SCL_PlannedOutreach__c> pos = new List<SCL_PlannedOutreach__c>();
            // Populate the available Case to Planned Outreach fields
            for (Case case1 : caseList) { 
                SCL_PlannedOutreach__c po = new SCL_PlannedOutreach__c();
                if (String.isNotBlank(case1.SCL_CampaignNumber__c) && String.isNotBlank(case1.SCL_FormFirstName__c) && String.isNotBlank(case1.SCL_FormEmail__c)) {
                    po.SCL_ExternalID__c = case1.SCL_CampaignNumber__c + case1.SCL_FormFirstName__c + case1.SCL_FormEmail__c;                
                    for (SCL_CaseToPlannedOutreachFields__c ctpField: ctpFields) { 
                        if (case1.get(ctpField.SCL_CaseField__c) != null) {
                            if (ctpField.SCL_Action__c == 'set') {
                                if (isMatchedValue(String.valueOf(case1.get(ctpField.SCL_CaseField__c)),ctpField.SCL_SourceValueType__c,ctpField.SCL_SourceValue__c)) {
                                    switch on ctpField.SCL_DestinationValueType__c {
                                        when 'Boolean' { po.put(ctpField.SCL_PlannedOutreachField__c,Boolean.valueOf(ctpField.SCL_DestinationValue__c)); }
                                        when 'Integer' { po.put(ctpField.SCL_PlannedOutreachField__c,Integer.valueOf(ctpField.SCL_DestinationValue__c)); }
                                        when 'Double' { po.put(ctpField.SCL_PlannedOutreachField__c,Double.valueOf(ctpField.SCL_DestinationValue__c)); }
                                        when else { po.put(ctpField.SCL_PlannedOutreachField__c,ctpField.SCL_DestinationValue__c); }
                                    }
                                }
                            } else {
                                po.put(ctpField.SCL_PlannedOutreachField__c,case1.get(ctpField.SCL_CaseField__c));
                            }
                        }                    
                    }
                }
                if (po != null) {
                    pos.add(po);
                }
            }
        	if (!pos.isEmpty()) {                
        		// insert pos;
                upsert pos SCL_PlannedOutreach__c.Fields.SCL_ExternalID__c;
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    // Determine if the two values are matched.   
    public static Boolean isMatchedValue (String firstValue, String firstValueType, String secondValue) {
        Boolean isMatchedValue = false;
  		switch on firstValueType {
            when 'Boolean' { isMatchedValue = (Boolean.valueOf(firstValue) == Boolean.valueOf(secondValue)); }
            when 'Integer' { isMatchedValue = (Integer.valueOf(firstValue) == Integer.valueOf(secondValue)); }
            when 'Double' { isMatchedValue = (Double.valueOf(firstValue) == Double.valueOf(secondValue)); }
            when else { isMatchedValue = (firstValue == secondValue); }
        }      
        return isMatchedValue;
    }
	*/
}