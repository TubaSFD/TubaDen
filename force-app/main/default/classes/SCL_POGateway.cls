/*
Name: SCL_POGateway
Purpose: Helper class to handle common functionalities related to Planned Outreach object
Author: Allan Casalla
Date: 12/21/2021

Change Log
3/24/2022 - Allan Casalla - Fix the bug where the multiple accounts could not merge when the RecordType of one of the account records is set to 'SCL_Prospect' even though the MRN field is populated
*/
public without sharing class SCL_POGateway { 
    private static Id patientRecordTypeId = SCL_GatewayUtils.patientRecordTypeId;
    private static Id prospectRecordTypeId = SCL_GatewayUtils.prospectRecordTypeId;   
    private static List<SCL_POToAccountFields__c> ptaFields = SCL_GatewayUtils.ptaFields;         
    private static List<SCL_PlannedOutreachToCaseFields__c> ptcFields = SCL_GatewayUtils.ptcFields;
    private static Map<String,Account> patientSFIdMap = new Map<String,Account>();            
    private static List<SCL_PlannedOutreach__c> posWoAccount = new List<SCL_PlannedOutreach__c>();            
    private static Set<String> patIdsWoAccount = new Set<String>();
    private static Set<String> patEmailsWoAccount = new Set<String>();    
    private static Map<String,Account> newAccountMap = new Map<String,Account>();
    private static Map<String,Account> updatedAccountMap = new Map<String,Account>();     
    
    // Get the list of accounts given the list of enterprise epic mrns, emails and planned outreach list
    public static Map<String,Account> getPOPatientSFIdMap(Set<String> patientIds,Set<String> patientEmails,List<SCL_PlannedOutreach__c> poList) {                                                
        newAccountMap = new Map<String,Account>();
        updatedAccountMap = new Map<String,Account>();        		            	        
        List<List<SObject>> arrayListSObject;
        
        setPOPatientSFIdMap(patientIds,patientEmails,poList,true);        
        
        if (!(newAccountMap == null || newAccountMap.isEmpty())) {         
            if (newAccountMap.size() > SCL_GatewayUtils.DML_SIZE_LIMIT) {                                
                arrayListSObject = SCL_GatewayUtils.getArrayListOfSObject(newAccountMap.Values());                
                Database.insert(((List<Account>) arrayListSObject[0]),false);
                Database.insert(((List<Account>) arrayListSObject[1]),false);                
            } else {                                
				Database.insert(newAccountMap.values(),false);                				
            }			
            setPOPatientSFIdMap(patIdsWoAccount,patEmailsWoAccount,posWoAccount,false);
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
        setPOPatientSFIdMap(patientIds,patientEmails,poList,false);                
        newAccountMap = null;
        updatedAccountMap = null;
        arrayListSObject = null;        
        return patientSFIdMap;
    }
        
	// Build the Planned Outreach SF Id Map
    private static void setPOPatientSFIdMap(Set<String> patientIds,Set<String> patientEmails,List<SCL_PlannedOutreach__c> poList,Boolean createAccount) {                                
        posWoAccount = new List<SCL_PlannedOutreach__c>();            	
    	patIdsWoAccount = new Set<String>();
    	patEmailsWoAccount = new Set<String>();  
        Account updatedAccount = new Account();
        Account currentAccount = new Account();
        List<Account> accts = new List<Account>();                
        Boolean isPOMatchedAccount;
        SCL_PlannedOutreach__c po;
        Integer size = poList.size(); 
        
        if (poList.isEmpty()) return;
        
        if (!patientIds.isEmpty() && !patientEmails.isEmpty()) {                               	
            accts = [SELECT Id,PersonContactId,FirstName,LastName,PersonEmail,SCL_MRNPersonAccount__c,SCL_PersonIdKey__c,SCL_HasPlannedOutreach__c,RecordTypeId FROM Account WHERE isPersonAccount=true AND ((SCL_MRNPersonAccount__c IN :patientIds) OR (PersonEmail IN :patientEmails))];                
        } else if (!patientIds.isEmpty()) {                
            accts = [SELECT Id,PersonContactId,FirstName,LastName,PersonEmail,SCL_MRNPersonAccount__c,SCL_PersonIdKey__c,SCL_HasPlannedOutreach__c,RecordTypeId FROM Account WHERE isPersonAccount=true AND SCL_MRNPersonAccount__c IN :patientIds];            
        } else if (!patientEmails.isEmpty()) {                
            accts = [SELECT Id,PersonContactId,FirstName,LastName,PersonEmail,SCL_MRNPersonAccount__c,SCL_PersonIdKey__c,SCL_HasPlannedOutreach__c,RecordTypeId FROM Account WHERE isPersonAccount=true AND PersonEmail IN :patientEmails];
        }
        
        Account acc0;
        Integer acctsSize = accts.size(); 
        
        for (Integer i = 0; i < size; ++i) { 
            po = poList[i];
            currentAccount = null;                    
            po.SCL_PersonIdKey__c = String.isNotBlank(po.SCL_MRN__c) ? po.SCL_MRN__c : (po.SCL_Email__c + po.SCL_FirstName__c + po.SCL_LastName__c).toLowercase();
            isPOMatchedAccount = false;  
            for (Integer i1 = 0; i1 < acctsSize; ++i1) { 
                acc0 = accts[i1];                
                currentAccount = acc0; 
                if (String.isNotBlank(po.SCL_MRN__c) && (po.SCL_MRN__c == acc0.SCL_MRNPersonAccount__c)) { 
                    /*
                    Purpose: If MRN is populated and RecordType is not 'SCL_Patient', set the RecordType to 'SCL_Patient'
					Author: Allan Casalla
                    */ 
                    if (acc0.RecordTypeId != patientRecordTypeId) currentAccount.RecordTypeId=patientRecordTypeId;                    
                    isPOMatchedAccount = true; 
                    break;                                                                                           
                } else if (String.isNotBlank(po.SCL_Email__c) && (po.SCL_PersonIdKey__c == acc0.SCL_PersonIdKey__c)) {
                    isPOMatchedAccount = true;                                    
                    break;
                }                                                                                                     
            }                 
            
            if (isPOMatchedAccount) {                      
                if (po.Id == null) {
                    updatedAccount = getUpdatedAccount(po,currentAccount);                        
                    if (updatedAccount != null) { 
                        currentAccount = updatedAccount;                        
                        updatedAccountMap.put(po.SCL_PersonIdKey__c,currentAccount);                            
                    }
                } 
                patientSFIdMap.put(po.SCL_PersonIdKey__c,currentAccount);                    
            } else if (createAccount) {
                if ((po.SCL_LastName__c == null) || String.isBlank(po.SCL_LastName__c) || (po.SCL_FirstName__c == null) || String.isBlank(po.SCL_FirstName__c)) continue;                 
                String patId = '';
                String patEmail = '';
                String recordTypeId = '';
                if (String.isNotBlank(po.SCL_MRN__c)) {
                    patId = po.SCL_MRN__c;  
                    patIdsWoAccount.add(patId);
                }
                
                if (String.isNotBlank(po.SCL_Email__c)) {
                    patEmail = po.SCL_Email__c;
                    patEmailsWoAccount.add(patEmail); 
                }
                
                if (String.isNotBlank(patId)) {
                    recordTypeId = patientRecordTypeId;                    
                } else {
                    recordTypeId = prospectRecordTypeId;                        
                }            
                
                Account acc1 = new Account(FirstName=po.SCL_FirstName__c,LastName=po.SCL_LastName__c,SCL_MRNPersonAccount__c=patId,PersonEmail=patEmail,SCL_HasPlannedOutreach__c=false,RecordTypeId=recordTypeId);                                                                                                                          
                newAccountMap.put(po.SCL_PersonIdKey__c,getUpdatedAccount(po,acc1));                                        					
                posWoAccount.add(po);                                                              
            }                                 
        }		
		accts = null;		
    }
        
    public static Account getUpdatedAccount(SCL_PlannedOutreach__c po,Account acc) {                        
        Boolean accountUpdated = false;
        SCL_POToAccountFields__c ptaField;
        Integer ptaSize = ptaFields.size();
                                                          
        if (acc != null) {                
            if (!acc.SCL_HasPlannedOutreach__c) {
                acc.SCL_HasPlannedOutreach__c = true;
                accountUpdated = true;
            }                
            // Copy or set the Planned Outreach fields to Account fields            
            for (Integer i = 0; i < ptaSize; ++i) {  
                ptaField = ptaFields[i];
                if (po.get(ptaField.SCL_PlannedOutreachField__c) != null) {
                    // Update Accounts cp fields only when the trigger is 'insert'.                        
                    if ((po.Id != null) && (ptaField.SCL_FieldCategory__c == 'cp')) continue;                                
                    
                    if (ptaField.SCL_Action__c == 'copy') {                        
                        acc.put(ptaField.SCL_AccountField__c,po.get(ptaField.SCL_PlannedOutreachField__c));
                        accountUpdated = true;
                    } else if (ptaField.SCL_Action__c == 'set') {
                        if (SCL_GatewayUtils.isMatchedValue(String.valueOf(po.get(ptaField.SCL_PlannedOutreachField__c)),ptaField.SCL_SourceValueType__c,ptaField.SCL_SourceValue__c)) {
                            switch on ptaField.SCL_DestinationValueType__c {
                                when 'Boolean' { acc.put(ptaField.SCL_AccountField__c,Boolean.valueOf(ptaField.SCL_DestinationValue__c)); }
                                when 'Integer' { acc.put(ptaField.SCL_AccountField__c,Integer.valueOf(ptaField.SCL_DestinationValue__c)); }
                                when 'Double' { acc.put(ptaField.SCL_AccountField__c,Double.valueOf(ptaField.SCL_DestinationValue__c)); }
                                when else { acc.put(ptaField.SCL_AccountField__c,ptaField.SCL_DestinationValue__c); }
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

	// update Planned Outreach when Case is needed.   
    public static poWithCase getUpdatedPOsWithCase(List<SCL_PlannedOutreach__c> pos) {
        poWithCase poWithCase = new poWithCase();    
        List<SCL_PlannedOutreach__c> updatedPOList = new List<SCL_PlannedOutreach__c>();     
        SCL_PlannedOutreach__c po;
        Integer size = pos.size(); 
        Boolean withCase = false;
        String prevCampaignNumber = '';
		String recordTypeName = '';  
                
        for (Integer i = 0; i < size; ++i) { 
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                                                                
            po = pos[i];
            if (po.SCL_CampaignNumber__c != prevCampaignNumber) {
				recordTypeName = SCL_GatewayUtils.caseCampaignMap.get(po.SCL_CampaignNumber__c);
				prevCampaignNumber = po.SCL_CampaignNumber__c;                      
                if (!withCase) withCase = true;                 
			}
            if (String.isNotBlank(recordTypeName)) {
                po.SCL_RecordTypeName__c = recordTypeName;
            	po.SCL_CaseCreated__c = true;   
            }        	            
            updatedPOList.add(po);
        }  
        
        poWithCase.poList = updatedPOList;
        poWithCase.withCase = withCase;        
        updatedPOList = null;        
        return poWithCase;
    }
        
    public static void createCase(List<SCL_PlannedOutreach__c> pos) {	        
        List<Case> newCaseList = new List<Case>();        
        Case case1;             
        SCL_PlannedOutreach__c po;
        Integer size = pos.size(); 
        SCL_PlannedOutreachToCaseFields__c ptcField;
        Integer ptcSize = ptcFields.size();
        String prevRecordTypeName = '';		
        String recordTypeId = '';
        
        try {            
            for (Integer i = 0; i < size; ++i) { 
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');                                            
                po = pos[i];
                if (!po.SCL_CaseCreated__c) continue;                
                if (po.SCL_RecordTypeName__c != prevRecordTypeName) {
                    recordTypeId = SCL_GatewayUtils.caseRecordTypeIdMap.get(po.SCL_RecordTypeName__c);
                    prevRecordTypeName = po.SCL_RecordTypeName__c;                    
                }
                
                case1 = new Case();               
                case1.SCL_CampaignNumber__c = po.SCL_CampaignNumber__c;
                case1.RecordTypeId = recordTypeId;
                case1.Status = 'Open';
                case1.SCL_Source__c = 'Planned Outreach';                 
                case1.SCL_FormCampaignName__c = po.SCL_CampaignName__c;
                case1.SCL_ExternalId__c = (po.SCL_CampaignName__c + po.SCL_Email__c + po.SCL_FirstName__c + po.SCL_LastName__c).toLowercase().replace('null','');                
                if (String.isNotBlank(po.SCL_PersonAccount__c)) case1.AccountId = po.SCL_PersonAccount__c;                
                
                for (Integer i1 = 0; i1 < ptcSize; ++i1) { 
                    ptcField = ptcFields[i1];
                    if (po.get(ptcField.SCL_PlannedOutreachField__c) != null) {
                        if (ptcField.SCL_Action__c == 'copy') {
                            case1.put(ptcField.SCL_CaseField__c,po.get(ptcField.SCL_PlannedOutreachField__c));
                        } else if (ptcField.SCL_Action__c == 'set') {
                            if (SCL_GatewayUtils.isMatchedValue(String.valueOf(po.get(ptcField.SCL_PlannedOutreachField__c)),ptcField.SCL_SourceValueType__c,ptcField.SCL_SourceValue__c)) {
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
                newCaseList.add(case1); 
                if (newCaseList.size() == SCL_GatewayUtils.DML_SIZE_LIMIT) {                                
                    Database.upsert(newCaseList, Case.SCL_ExternalID__c, false);
                    newCaseList.clear();
                }
            }               
            if (!newCaseList.isEmpty()) Database.upsert(newCaseList, Case.SCL_ExternalID__c, false);
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(pos,'update',e);
        }    
    }
    
    public static List<SCL_PlannedOutreach__c> getPOMatchAccount(List<SCL_PlannedOutreach__c> newList, String triggerOperation) {
        Map<String, Account> patientIdMap = null;
        SCL_PlannedOutreach__c po;
        Integer size = newList.size(); 
        Account acc = null;
        if (triggerOperation == 'insert') {
            patientIdMap = SCL_TA_PO_BI_AccountQueries.getInstance().beforePOAccountMap;
        } else if (triggerOperation == 'update') {
            patientIdMap = SCL_TA_PO_BU_AccountQueries.getInstance().beforePOAccountMap;               
        }
                
        if (patientIdMap == null || patientIdMap.isEmpty()) return newList;
        
        List<SCL_PlannedOutreach__c> updatedPOs = new List<SCL_PlannedOutreach__c>();      
        // Loop through newList records and update AccountId and ContactId via the mapped value in patientIdMap.        
        for (Integer i = 0; i < size; ++i) { 
            if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.95)) throw new SCLTriggerException('Apex CPU time limit exceeded');            
            po = newList[i];
            // Assign external id if not populated
            if (String.isBlank(po.SCL_ExternalID__c)) {
                po.SCL_ExternalID__c = String.isNotBlank(po.SCL_MRN__c) ? (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_MRN__c) : (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_Email__c);                    
            }
            po.SCL_PersonIdKey__c = String.isNotBlank(po.SCL_MRN__c) ? po.SCL_MRN__c : (po.SCL_Email__c + po.SCL_FirstName__c + po.SCL_LastName__c).toLowercase();                                
            
            acc = patientIdMap.get(po.SCL_PersonIdKey__c);           
            if (acc != null) {
                po.SCL_PersonAccount__c = acc.Id;    
                po.SCL_ContactSFID__c = acc.PersonContactId;                                                                                         
            } 
            updatedPOs.add(po);
        }
        patientIdMap = null;
        return updatedPOs;
    }
    
    public static void processMissingRecord(List<SCL_PlannedOutreach__c> origList,List<SCL_PlannedOutreach__c> newList) {	        
        Set<String> poExternalId = new Set<String>();	        
        List<SCL_PlannedOutreach__c> missingPOs = new List<SCL_PlannedOutreach__c>();                
        
        for (SCL_PlannedOutreach__c po : newList) {                         
            poExternalId.add(po.SCL_ExternalID__c);                            
        }
        
        if (poExternalId.isEmpty()) {
            missingPOs.addAll(origList);                                                     
        } else {
            for (SCL_PlannedOutreach__c po : origList) {             
                if (String.isBlank(po.SCL_ExternalID__c)) {
                    po.SCL_ExternalID__c = String.isNotBlank(po.SCL_MRN__c) ? (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_MRN__c) : (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_Email__c);                    
                }
                if (!poExternalId.contains(po.SCL_ExternalID__c)) missingPOs.add(po);                                                     
            }
        }
                
        if (!missingPOs.isEmpty()) SCL_GatewayUtils.publishException(missingPOs,'insert',new SCLTriggerException('Unable to insert record'));                                                                         
        poExternalId = null;
        missingPOs = null;
    }    
    
    // Wrapper Class
    public class poWithCase {
        public List<SCL_PlannedOutreach__c> poList;
        public Boolean withCase;        
    }    
}