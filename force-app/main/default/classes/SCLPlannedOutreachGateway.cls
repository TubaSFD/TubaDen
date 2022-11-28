public without sharing class SCLPlannedOutreachGateway {
    /*
    private static Id prospectRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Account' AND Name='Prospect' LIMIT 1].Id;
    private static Id patientRecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Account' AND Name='Patient' LIMIT 1].Id;    
    private static List<SCL_POToAccountFields__c> ptaFields = [SELECT Id, SCL_AccountField__c,SCL_Action__c,SCL_PlannedOutreachField__c,SCL_DestinationValue__c,SCL_DestinationValueType__c,SCL_FieldCategory__c,SCL_SourceValue__c,SCL_SourceValueType__c FROM SCL_POToAccountFields__c WHERE SCL_Active__c=true];
    private static List<SCL_PlannedOutreachToCaseFields__c> ptcFields = [SELECT Id, SCL_PlannedOutreachField__c,SCL_Action__c,SCL_CaseField__c,SCL_DestinationValue__c,SCL_DestinationValueType__c,SCL_FieldCategory__c,SCL_SourceValue__c,SCL_SourceValueType__c FROM SCL_PlannedOutreachToCaseFields__c WHERE SCL_Active__c=true];
    
    // Get the list of accounts given the list of enterprise epic mrns, emails and planned outreach list
    public static Map<String,Account> getPatientSFId(List<String> patientIds,List<String> patientEmails,List<SCL_PlannedOutreach__c> poList) {        
        System.debug('SCLPlannedOutreachGateway(getPatientSFId: Parameters): patientIds:'+patientIds+' ;patientEmails:'+patientEmails+' ;poList:'+poList);
        List<Account> existingAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();
        Map<String,Account> patientIdSFIdMap = new Map<String,Account>();
        Set<String> patientIdOfNoMatchingAcct = new Set<String>();
        String patientIdKey;
        Boolean isPOMatchedAccount = false;
        try { 
            List<Account> acc = [SELECT Id,PersonContactId,FirstName,LastName,PersonEmail,SCL_MRNPersonAccount__c FROM Account WHERE isPersonAccount=true AND (SCL_MRNPersonAccount__c IN :patientIds OR PersonEmail IN :patientEmails)];
            if (!acc.isEmpty()) {   
                for (SCL_PlannedOutreach__c po : poList) {                                                            
                    if (String.isNotBlank(po.SCL_LastName__c) && ((String.isNotBlank(po.SCL_MRN__c) && po.SCL_MRN__c.toLowerCase().startsWith('x')) || (String.isNotBlank(po.SCL_Email__c) && String.isNotBlank(po.SCL_FirstName__c)))) {                                                        
                        if (String.isNotBlank(po.SCL_MRN__c) && po.SCL_MRN__c.toLowerCase().startsWith('x')) {                            
                        	patientIdKey = po.SCL_MRN__c.toLowerCase();
                            System.debug('SCLPlannedOutreachGateway(getPatientSFId: Planned Outreach Information): po.SCL_FirstName__c:'+po.SCL_FirstName__c+' ;po.SCL_LastName__c:'+po.SCL_LastName__c+' ;po.SCL_MRN__c:'+po.SCL_MRN__c);
                        } else {
							patientIdKey = (po.SCL_Email__c + po.SCL_FirstName__c + po.SCL_LastName__c).toLowerCase().replaceAll('[^a-zA-Z0-9]','');                            
                            System.debug('SCLPlannedOutreachGateway(getPatientSFId: Planned Outreach Information): po.SCL_FirstName__c:'+po.SCL_FirstName__c+' ;po.SCL_LastName__c:'+po.SCL_LastName__c+' ;po.SCL_Email__c:'+po.SCL_Email__c);
                        }
                        
                    	isPOMatchedAccount = false;
                    	for (Account acc0 : acc) {                            
                            if (String.isNotBlank(acc0.SCL_MRNPersonAccount__c) && acc0.SCL_MRNPersonAccount__c.toLowerCase().startsWith('x') && String.isNotBlank(po.SCL_MRN__c) && acc0.SCL_MRNPersonAccount__c.toLowerCase() == po.SCL_MRN__c.toLowerCase()) {
                                if (String.isBlank(acc0.PersonEmail) && String.isNotBlank(po.SCL_Email__c)) {
                                    acc0.PersonEmail = po.SCL_Email__c;
                                }
                                isPOMatchedAccount = true;                                 
                            } else if (String.isNotBlank(acc0.PersonEmail) && String.isNotBlank(po.SCL_Email__c) && acc0.PersonEmail.toLowerCase() == po.SCL_Email__c.toLowerCase() && 
                                String.isNotBlank(po.SCL_FirstName__c) && String.isNotBlank(acc0.FirstName) && acc0.FirstName.toLowerCase() == po.SCL_FirstName__c.toLowerCase() && 
                                String.isNotBlank(acc0.LastName) && acc0.LastName.toLowerCase() == po.SCL_LastName__c.toLowerCase()) {                                                                   
									if (String.isBlank(acc0.SCL_MRNPersonAccount__c) && String.isNotBlank(po.SCL_MRN__c) && po.SCL_MRN__c.toLowerCase().startsWith('x')) {
                                    	acc0.SCL_MRNPersonAccount__c = po.SCL_MRN__c;
                                	}                                    
                                    isPOMatchedAccount = true;                                         
                            }   
                            
                            if (isPOMatchedAccount) {                                                                
                                Account acc1 = getUpdatedAccount(po,acc0,'update');
                                existingAccounts.add(acc1);
                                patientIdSFIdMap.put(patientIdKey,acc1); 
                                isPOMatchedAccount = true;
                                break;
                            }
                        }
                        if (!isPOMatchedAccount) {
                            System.debug('SCLPlannedOutreachGateway(getPatientSFId: No matching account): po.SCL_FirstName__c:'+po.SCL_FirstName__c+' ;po.SCL_LastName__c:'+po.SCL_LastName__c+' ;po.SCL_FirstName__c:'+po.SCL_FirstName__c+' ;patientIdKey:'+patientIdKey);
                            if (!patientIdOfNoMatchingAcct.contains(patientIdKey)) {                                       
                                Account acc2 = new Account(FirstName=po.SCL_FirstName__c,LastName=po.SCL_LastName__c);
                                Account acc3 = getUpdatedAccount(po,acc2,'insert');                            
                                newAccounts.add(acc3);
                                patientIdOfNoMatchingAcct.add(patientIdKey);
                            }
                        }
                	}
                }            	
                
                System.debug('SCLPlannedOutreachGateway(getPatientSFId: Accounts to be updated):existingAccounts:'+existingAccounts);                
                // Update accounts with the CP fields.
                if (!existingAccounts.isEmpty()) {   
                    update existingAccounts;
                }
                System.debug('SCLPlannedOutreachGateway(getPatientSFId: Accounts to be inserted):newAccounts:'+newAccounts);                
                if (!newAccounts.isEmpty()) {                   
                    insert newAccounts;
                    for (Account acc4 : newAccounts) {
                        if (String.isNotBlank(acc4.SCL_MRNPersonAccount__c) && acc4.SCL_MRNPersonAccount__c.toLowerCase().startsWith('x')) {
                            patientIdKey = acc4.SCL_MRNPersonAccount__c.toLowerCase();
                        } else if (String.isNotBlank(acc4.PersonEmail) && String.isNotBlank(acc4.FirstName) && String.isNotBlank(acc4.LastName)) {
                            patientIdKey = (acc4.PersonEmail + acc4.FirstName + acc4.LastName).toLowerCase().replaceAll('[^a-zA-Z0-9]','');                            
                        }                        
                        patientIdSFIdMap.put(patientIdKey,acc4);                                             	
                    }					
                }
            } else {
                // Create new Account for Planned Outreach with no Account
                System.debug('Planned Outreach with no Account:'+poList);                
                for (SCL_PlannedOutreach__c po1 : poList) {
                    System.debug('SCLPlannedOutreachGateway(getPatientSFId: Account does not exist): po1.SCL_FirstName__c:'+po1.SCL_FirstName__c+' ;po1.SCL_FormLastName__c:'+po1.SCL_LastName__c);                                                                    
                    if (String.isNotBlank(po1.SCL_LastName__c) && ((String.isNotBlank(po1.SCL_MRN__c) && po1.SCL_MRN__c.toLowerCase().startsWith('x')) || (String.isNotBlank(po1.SCL_Email__c) && String.isNotBlank(po1.SCL_FirstName__c)))) {                                
                        Account acc5 = new Account(FirstName=po1.SCL_FirstName__c,LastName=po1.SCL_LastName__c);                        
                        Account acc6 = getUpdatedAccount(po1,acc5,'insert');
                        newAccounts.add(acc6);
                    }
                }
                
                System.debug('SCLPlannedOutreachGateway(getPatientSFId: Accounts to be inserted that do not exist in the system):'+newAccounts);                
                if (!newAccounts.isEmpty()) {
                    insert newAccounts;                     
                    for (Account acc7 : newAccounts) {                        
                        if (String.isNotBlank(acc7.SCL_MRNPersonAccount__c) && acc7.SCL_MRNPersonAccount__c.toLowerCase().startsWith('x')) {
                            patientIdKey = acc7.SCL_MRNPersonAccount__c.toLowerCase();
                        } else if (String.isNotBlank(acc7.PersonEmail) && String.isNotBlank(acc7.FirstName) && String.isNotBlank(acc7.LastName)) {
                            patientIdKey = (acc7.PersonEmail + acc7.FirstName + acc7.LastName).toLowerCase().replaceAll('[^a-zA-Z0-9]','');                            
                        }  
                        patientIdSFIdMap.put(patientIdKey,acc7);                                            	
                    }
                }
            }   
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return patientIdSFIdMap;
    }
    
    public static Account getUpdatedAccount(SCL_PlannedOutreach__c po, Account acc, String action) {        
        if (String.isNotBlank(po.SCL_MRN__c) && !po.SCL_MRN__c.toLowerCase().startsWith('x')) {
            po.SCL_MRN__c = '';
        }
        acc.SCL_HasPlannedOutreach__c = true;
        if (action == 'insert') {
            if (String.isNotBlank(po.SCL_MRN__c)) {
                acc.RecordTypeId = patientRecordTypeId;
            } else {
            	acc.RecordTypeId = prospectRecordTypeId;    
            }            
        }
        // Populate the available Planned Outreach to Account fields
        for (SCL_POToAccountFields__c ptaField: ptaFields) {
            if (po.get(ptaField.SCL_PlannedOutreachField__c) != null) {
                if (ptaField.SCL_Action__c == 'copy') {
                    acc.put(ptaField.SCL_AccountField__c,po.get(ptaField.SCL_PlannedOutreachField__c));
                } else if (ptaField.SCL_Action__c == 'set') {
                    if (isMatchedValue(String.valueOf(po.get(ptaField.SCL_PlannedOutreachField__c)),ptaField.SCL_SourceValueType__c,ptaField.SCL_SourceValue__c)) {
                        switch on ptaField.SCL_DestinationValueType__c {
                            when 'Boolean' { acc.put(ptaField.SCL_AccountField__c,Boolean.valueOf(ptaField.SCL_DestinationValue__c)); }
                            when 'Integer' { acc.put(ptaField.SCL_AccountField__c,Integer.valueOf(ptaField.SCL_DestinationValue__c)); }
                            when 'Double' { acc.put(ptaField.SCL_AccountField__c,Double.valueOf(ptaField.SCL_DestinationValue__c)); }
                            when else { acc.put(ptaField.SCL_AccountField__c,ptaField.SCL_DestinationValue__c); }
                        }
                    }
                } 
            }
        }
        return acc;
    }
        
    // Get PersonContactId given the list of AccountIds
    public static Map<Id,Id> getPersonContactId(List<String> accountIds) {        
        System.debug('(getPersonAccountInfo) accountIds:'+accountIds);
        Map<Id,Id> personContactIdMap = new Map<Id,Id>();          
        List<Account> acc = [SELECT Id,PersonContactId FROM Account WHERE isPersonAccount=true AND Id IN :accountIds];
        if (!acc.isEmpty()) {  
            for (Account acc0 : acc) {  
                personContactIdMap.put(acc0.Id,acc0.PersonContactId);                 
            }
        } 
        return personContactIdMap;
    }
    
    // Create new Planned Outreach record.   
    public static void CreateCase (List<SCL_PlannedOutreach__c> poList) {		
        System.debug('CreateCase(poList):'+poList);
        try {            
            List<Case> cases = new List<Case>();
            // Populate the available Planned Outreach to Case fields            
            for (SCL_PlannedOutreach__c po : poList) {
                if (String.isNotBlank(po.SCL_CampaignNumber__c) && String.isNotBlank(po.SCL_Source__c)) {
                    Case case1 = new Case();                
                    case1.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='Case' AND Name=:po.SCL_RecordTypeName__c LIMIT 1].Id;
                    case1.Status = 'Open';
                    case1.SCL_Source__c = 'Planned Outreach';                
                    for (SCL_PlannedOutreachToCaseFields__c ptcField: ptcFields) { 
                        if (po.get(ptcField.SCL_PlannedOutreachField__c) != null) {
                            if (ptcField.SCL_Action__c == 'copy') {
                                case1.put(ptcField.SCL_CaseField__c,po.get(ptcField.SCL_PlannedOutreachField__c));
                            } else if (ptcField.SCL_Action__c == 'set') {
                                if (isMatchedValue(String.valueOf(po.get(ptcField.SCL_PlannedOutreachField__c)),ptcField.SCL_SourceValueType__c,ptcField.SCL_SourceValue__c)) {
                                    switch on ptcField.SCL_DestinationValueType__c {
                                        when 'Boolean' { case1.put(ptcField.SCL_CaseField__c,Boolean.valueOf(ptcField.SCL_DestinationValue__c)); }
                                        when 'Integer' { case1.put(ptcField.SCL_CaseField__c,Integer.valueOf(ptcField.SCL_DestinationValue__c)); }
                                        when 'Double' { case1.put(ptcField.SCL_CaseField__c,Double.valueOf(ptcField.SCL_DestinationValue__c)); }
                                        when else { case1.put(ptcField.SCL_CaseField__c,ptcField.SCL_DestinationValue__c); }
                                    }
                                }
                            } 
                        }                    
                    }                    
                	if (case1 != null) {                    	
                    	cases.add(case1);
                	}
                }                
            }
            
            System.debug('CreateCase(cases):'+cases);
        	if (!cases.isEmpty()) {                
        		insert cases;                   
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