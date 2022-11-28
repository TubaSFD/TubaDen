public without sharing class SCL_ApptGateway {            
    private static Map<String,Account> patientSFIdMap = new Map<String,Account>();            
    private static List<SCL_Appointment__c> apptsWoAccount = new List<SCL_Appointment__c>();            
    private static Set<String> patIdsWoAccount = new Set<String>();        
    private static Map<String,Account> newAccountMap = new Map<String,Account>();
    private static Map<String,Account> updatedAccountMap = new Map<String,Account>(); 
    
    // Get the list of accounts given the list of enterprise epic mrns and appointment list
    public static Map<String,Account> getApptPatientSFIdMap(Set<String> patientIds,List<SCL_Appointment__c> apptList) {                                                
        newAccountMap = new Map<String,Account>();
        updatedAccountMap = new Map<String,Account>(); 
        List<List<SObject>> arrayListSObject;
            	          
        setApptPatientSFIdMap(patientIds,apptList,true);
        if (!(newAccountMap == null || newAccountMap.isEmpty())) {                                     
            if (newAccountMap.size() > SCL_GatewayUtils.DML_SIZE_LIMIT) {                                
                arrayListSObject = SCL_GatewayUtils.getArrayListOfSObject(newAccountMap.Values());                
                Database.insert((List<Account>) arrayListSObject[0],false);                
                Database.insert((List<Account>) arrayListSObject[1],false);
            } else {                 
                Database.insert(newAccountMap.values(),false);
            }
			
            setApptPatientSFIdMap(patIdsWoAccount,apptsWoAccount,false);
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
        
        setApptPatientSFIdMap(patientIds,apptList,false);
        newAccountMap = null;
        updatedAccountMap = null;
        arrayListSObject = null;        
        return patientSFIdMap;
    }
        
	// Build the Appointment SF Id Map
    private static void setApptPatientSFIdMap(Set<String> patientIds,List<SCL_Appointment__c> apptList,Boolean createAccount) {                                
        apptsWoAccount = new List<SCL_Appointment__c>();            	
    	patIdsWoAccount = new Set<String>();    	 
        Account updatedAccount = new Account();
        Account currentAccount = new Account();
        List<Account> accts = new List<Account>();                
        Boolean isPOMatchedAccount;
        SCL_Appointment__c appt;
        Integer size = apptList.size(); 
        
                
        if (apptList.isEmpty()) return;        
        if (!patientIds.isEmpty()) accts = [SELECT Id,SCL_MRNPersonAccount__c,PersonEmail FROM Account WHERE isPersonAccount=true AND SCL_MRNPersonAccount__c IN :patientIds];                               	
        Account acc0;
        Integer acctsSize = accts.size(); 
                                
        for (Integer i = 0; i < size; ++i) { 
            currentAccount = null;  
            appt = apptList[i];
            isPOMatchedAccount = false;                                 
            for (Integer i1 = 0; i1 < acctsSize; ++i1) { 
                acc0 = accts[i1];    
                currentAccount = acc0; 
                if (String.isNotBlank(appt.SCL_MRN__c) && (appt.SCL_MRN__c == acc0.SCL_MRNPersonAccount__c)) {                        
                    isPOMatchedAccount = true; 
                    break;                                                                                           
                }                                                                                                     
            }                 
            
            if (isPOMatchedAccount) {                      
                if (appt.Id == null) {
                    if (String.isBlank(currentAccount.PersonEmail) && String.isNotBlank(appt.SCL_PersonEmail__c)) {
                        currentAccount.PersonEmail = appt.SCL_PersonEmail__c;                        
                        updatedAccountMap.put(appt.SCL_MRN__c,currentAccount);                            
                    }                    
                } 
                patientSFIdMap.put(appt.SCL_MRN__c,currentAccount);                                                                     
            } else if (createAccount) { 
				if ((appt.SCL_LastName__c == null) || String.isBlank(appt.SCL_LastName__c)) continue;                 
                String patId = '';
                String patEmail = '';
                if (String.isNotBlank(appt.SCL_MRN__c)) {
                    patId = appt.SCL_MRN__c;  
                    patIdsWoAccount.add(patId);
                }
                
                if (String.isNotBlank(appt.SCL_PersonEmail__c)) patEmail = appt.SCL_PersonEmail__c;                                        
                
                Account acc1 = new Account(FirstName=appt.SCL_FirstName__c,LastName=appt.SCL_LastName__c,SCL_MRNPersonAccount__c=patId,PersonEmail=patEmail);
                newAccountMap.put(appt.SCL_MRN__c,acc1);                                        					
                apptsWoAccount.add(appt);                                                              
            }                                 
        }        
		accts = null;		
    }     
}