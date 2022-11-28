/*
Name: SCL_AccountGateway
Purpose: Helper class to handle common functionalities related to Account object
Author: Allan Casalla
Date: 12/21/2021

Change Log
7/6/2022 - Allan Casalla - Add oldAcc as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
7/6/2022 - Allan Casalla - Set all the CP fields to false when incoming PersonHasOptedOutOfEmail is true
7/6/2022 - Allan Casalla - Set PersonHasOptedOutOfEmail to False when any of the CP fields is set True
8/22/2022 - Tuba Ciftci - Add 2 methods for querying Prospect and Patient Accounts based on the phone number fields.
*/
public without sharing class SCL_AccountGateway {     
    private static Set<String> cpAccountFields = SCL_GatewayUtils.cpAccountFields;
    private static String patientInterfaceAccountFields = SCL_GatewayUtils.patientInterfaceAccountFields;
    // Remove Communication
    public static Account getRemoveCommunicationAccount(Account acc, Account oldAcc) {   		
        if (acc.SCL_Deceased__pc != null && acc.SCL_Deceased__pc) {
            acc.PersonDoNotCall = true;
            acc.PersonHasOptedOutOfEmail = true;
            acc.PersonHasOptedOutOfFax = true;
            acc.SCL_DoNotSolicit__pc = true;
            acc.SCL_MobileOptOut__pc = true;
            acc.et4ae5__HasOptedOutOfMobile__pc = true;
            acc.SCL_MedSyncOptIn__pc = 'Declined';
            // Set all the CP fields to false
            for (String cpAccountField: cpAccountFields) { 
                acc.put(cpAccountField,false);                    	
            } 
        } else if (acc.PersonHasOptedOutOfEmail != null && acc.PersonHasOptedOutOfEmail && (oldAcc == null || !oldAcc.PersonHasOptedOutOfEmail)) {
            /*            
            Purpose: Set all the CP fields to false when incoming PersonHasOptedOutOfEmail is true
            Author: Allan Casalla
            */            
            for (String cpAccountField: cpAccountFields) { 
                acc.put(cpAccountField,false);                    	
            }  
        } else {            
            Set<String> cpFields = new Set<String>(cpAccountFields);
            Map<String, Object> accountFieldsToValue = acc.getPopulatedFieldsAsMap();            
            cpFields.retainAll(accountFieldsToValue.keySet());
            /*            
            Purpose: Set PersonHasOptedOutOfEmail to False when any of the CP fields is set True
            Author: Allan Casalla
            */   	            
            for (String cpField: cpFields) {                
                if (acc.get(cpField) == True && (oldAcc == null || oldAcc.get(cpField) == False)) {
                    acc.PersonHasOptedOutOfEmail = false;
                    break;
                }                                    	
            }
        }
        return acc;
    }
    
    public static List<Account> getRemoveCommunicationAccounts(List<Account> accountList, List<Account> oldList) {
        Account oldAcc;
        Map<Id,Account> oldMap;
        if (oldList != null) oldMap = new Map<Id,Account>(oldList);        
        List<Account> updateAccountList = new List<Account>();
        
        for (Account acc : accountList) {  
            /*            
            Purpose: Add oldAcc as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
            Author: Allan Casalla
            */			
            if (oldList != null) oldAcc = oldMap.get(acc.Id);
            acc = getRemoveCommunicationAccount(acc,oldAcc);            
            updateAccountList.add(acc);
        } 	
        return updateAccountList;
    }
    
    // Build the patient account map
    public static Map<String,Account> getPatientAccountMap(Set<String> patientEmailSet, Boolean withMRN) {   
        List<String> patientEmailList = new List<String>(patientEmailSet);
        Map<String,Account> patientAccountMap = new Map<String,Account>();          
        if (!patientEmailSet.isEmpty() && patientEmailList[0] != null) {                              
            if (withMRN) {                
                String soqlQuery = 'SELECT Id,CreatedDate,'+ patientInterfaceAccountFields +' FROM Account WHERE IsPersonAccount = true AND RecordType.DeveloperName=\'SCL_Patient\' AND PersonEmail IN :patientEmailSet';
                List <Account> accounts =  Database.query(soqlQuery);            
                for (Account acc : accounts) {                  
                    patientAccountMap.put((acc.PersonEmail + acc.FirstName + acc.LastName).toLowercase(),acc);        		
                }
            } else {
                for (List<Account> accounts : [                                    
                    SELECT Id,PersonEmail,FirstName,LastName,SCL_MergeAccountReference__c FROM Account WHERE IsPersonAccount = true AND (RecordType.DeveloperName='SCL_Prospect' OR RecordType.DeveloperName='SCL_BehavioralProspect') AND PersonEmail IN :patientEmailSet ORDER BY CreatedDate DESC
                ]) {
                    for (Account acc : accounts) {                  
                        patientAccountMap.put((acc.PersonEmail + acc.FirstName + acc.LastName).toLowercase(),acc);        		
                    }
                }
            }			
        }        
        patientEmailList = null;  
        return patientAccountMap;
    }
    
    // Build the patient account phone map
    public static Map<String,Account> getPatientAccountPhoneMap(Set<String> patientPhoneSet, Boolean withMRN) { 
        List<String> patientPhoneList = new List<String>(patientPhoneSet);
        Map<String,Account> patientAccountPhoneMap = new Map<String,Account>();                   
        if (!patientPhoneSet.isEmpty() && patientPhoneList[0] != null) {                                 
            if (withMRN) {                
                String soqlQuery = 'SELECT Id,CreatedDate,'+ patientInterfaceAccountFields +' FROM Account WHERE IsPersonAccount = true AND RecordType.DeveloperName=\'SCL_Patient\' AND (Phone IN:patientPhoneSet OR PersonHomePhone IN :patientPhoneSet OR PersonMobilePhone IN :patientPhoneSet) ';
                List <Account> accounts =  Database.query(soqlQuery);            
                for (Account acc : accounts) {                  
                    patientAccountPhoneMap.put((acc.Phone + acc.FirstName + acc.LastName).toLowercase(),acc);
                    if(String.isNotBlank(acc.PersonHomePhone)) patientAccountPhoneMap.put((acc.PersonHomePhone + acc.FirstName + acc.LastName).toLowercase(),acc);
                    if(String.isNotBlank(acc.PersonMobilePhone)) patientAccountPhoneMap.put((acc.PersonMobilePhone + acc.FirstName + acc.LastName).toLowercase(),acc);
                }
            } else {
                for (List<Account> accounts : [                                    
                    SELECT Id,Phone,PersonHomePhone,PersonMobilePhone,FirstName,LastName,SCL_MergeAccountReference__c FROM Account WHERE IsPersonAccount = true AND (RecordType.DeveloperName='SCL_Prospect' OR RecordType.DeveloperName='SCL_BehavioralProspect') AND (Phone IN:patientPhoneSet OR PersonHomePhone IN :patientPhoneSet OR PersonMobilePhone IN :patientPhoneSet) ORDER BY CreatedDate DESC]) {
                        for (Account acc : accounts) {
                            if(String.isNotBlank(acc.Phone)) patientAccountPhoneMap.put((acc.Phone + acc.FirstName + acc.LastName).toLowercase(),acc);
                            if(String.isNotBlank(acc.PersonHomePhone)) patientAccountPhoneMap.put((acc.PersonHomePhone + acc.FirstName + acc.LastName).toLowercase(),acc);
                            if(String.isNotBlank(acc.PersonMobilePhone)) patientAccountPhoneMap.put((acc.PersonMobilePhone + acc.FirstName + acc.LastName).toLowercase(),acc);    		
                        }
                    }
            }			
        }        
         system.debug('patientAccountPhonemMap'+patientAccountPhoneMap);
        patientPhoneList = null;        
        return patientAccountPhoneMap;
    }
    
    // Build the prospect account map
    public static Map<String,List<Account>> getProspectAccountMap(Set<String> patientEmailSet) {   
        Map<String,List<Account>> prospectAccountMap = new Map<String,List<Account>>();
        List<String> patientEmailList = new List<String>(patientEmailSet);
        String personIdKey;
        
        if (!patientEmailSet.isEmpty() && patientEmailList[0] != null) {                         
            for (List<Account> accounts : [                                
                SELECT Id,FirstName,LastName,PersonEmail,CreatedDate FROM Account WHERE (RecordType.DeveloperName='SCL_Prospect' OR RecordType.DeveloperName='SCL_BehavioralProspect') AND PersonEmail IN :patientEmailSet ORDER BY CreatedDate DESC
            ]) {
                for (Account acc : accounts) {                    
                    personIdKey = (acc.PersonEmail + acc.FirstName + acc.LastName).toLowercase();
                    // Limit only to 3 accounts per personIdKey.            
                    if (prospectAccountMap.get(personIdKey) != null && prospectAccountMap.get(personIdKey).size() > 2) continue;
                    if (!prospectAccountMap.containsKey(personIdKey)) {
                        prospectAccountMap.put(personIdKey, new List<Account>());                                                                                                                
                    }
                    prospectAccountMap.get(personIdKey).add(acc);    					
                }
            }
        } 
        patientEmailList = null;  
        return prospectAccountMap;
    }  
    
    // Build the prospect account phone map
    public static Map<String,List<Account>> getProspectAccountPhoneMap(Set<String> patientPhoneSet) { 
        Map<String,List<Account>> prospectAccountPhoneMap = new Map<String,List<Account>>();
        List<String> patientPhoneList = new List<String>(patientPhoneSet);
        String phoneIdKey;
        
        if (!patientPhoneSet.isEmpty() && patientPhoneList[0] != null) {                         
            for (List<Account> accounts : [                                
                SELECT Id,FirstName,LastName,Phone,PersonMobilePhone,PersonHomePhone,CreatedDate FROM Account WHERE (RecordType.DeveloperName='SCL_Prospect' OR RecordType.DeveloperName='SCL_BehavioralProspect') AND (Phone IN :patientPhoneSet OR PersonHomePhone IN :patientPhoneSet OR PersonMobilePhone IN: patientPhoneSet) ORDER BY CreatedDate DESC
            ]) {
                for (Account acc : accounts) {
                    if (String.isNotBlank(acc.PersonHomePhone)) phoneIdKey = (acc.PersonHomePhone + acc.FirstName + acc.LastName).toLowercase();
                    if (String.isNotBlank(acc.PersonMobilePhone)) phoneIdKey = (acc.PersonMobilePhone + acc.FirstName + acc.LastName).toLowercase();                        
                    // Limit only to 3 accounts per phoneIdKey.            
                    if (prospectAccountPhoneMap.get(phoneIdKey) != null && prospectAccountPhoneMap.get(phoneIdKey).size() > 2) continue;
                    if (!prospectAccountPhoneMap.containsKey(phoneIdKey)) {
                        prospectAccountPhoneMap.put(phoneIdKey, new List<Account>());
                    }
                    prospectAccountPhoneMap.get(phoneIdKey).add(acc);    					
                }
            }
        }              
        patientPhoneList = null;        
        return prospectAccountPhoneMap;
    }
    
}