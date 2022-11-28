public without sharing class SCLAppointmentGateway {
    /*
	// Begin Patient Epic code translation to SF Id.
    public static Map<String,Account> getEpicPatientSFId(List<String> epicPatientIds,List<String> epicPatientEmails,List<SCL_Appointment__c> epicAppointmentList) {
        System.debug('epicPatientIds:'+epicPatientIds);
        List<Account> existingAccounts = new List<Account>();
        List<Account> newAccounts = new List<Account>();
        Map<String,Account> patientEpicIdSFIdMap = new Map<String,Account>();
        Set<String> patientMRNOfNoMatchingAcct = new Set<String>();
        try {
            List<Account> acc = [SELECT Id,FirstName,LastName,PersonEmail,SCL_MRNPersonAccount__c FROM Account WHERE SCL_MRNPersonAccount__c IN :epicPatientIds OR PersonEmail IN :epicPatientEmails];
            if (!acc.isEmpty()) {                
                for (Account acc1 : acc) {
                    if (String.isNotBlank(acc1.SCL_MRNPersonAccount__c)) {
                		patientEpicIdSFIdMap.put(acc1.SCL_MRNPersonAccount__c,acc1);
                    } else {                                                
                        for (SCL_Appointment__c app1 : epicAppointmentList) {
                            System.debug('SCLAppointmentGateway(getEpicPatientSFId: Account MRN is blank): app1.SCL_MRN__c:'+app1.SCL_MRN__c+' ;app1.SCL_FirstName__c:'+app1.SCL_ApptFirstName__c+' ;app1.SCL_LastName__c:'+app1.SCL_ApptLastName__c+' ;app1.SCL_PersonEmail__c:'+app1.SCL_PersonEmail__c);                            
                            if (String.isNotBlank(app1.SCL_PersonEmail__c) && String.isNotBlank(app1.SCL_ApptFirstName__c) && String.isNotBlank(app1.SCL_ApptLastName__c)) {                                
                                if (acc1.PersonEmail.toLowerCase() == app1.SCL_PersonEmail__c.toLowerCase() && 
                                   acc1.FirstName.toLowerCase() == app1.SCL_ApptFirstName__c.toLowerCase() && 
                                   acc1.LastName.toLowerCase() == app1.SCL_ApptLastName__c.toLowerCase()) {                               
                        				patientEpicIdSFIdMap.put(app1.SCL_MRN__c,acc1);  
                                       	acc1.SCL_MRNPersonAccount__c = app1.SCL_MRN__c;
                                       	existingAccounts.add(acc1);
                                } else {
                                    System.debug('SCLAppointmentGateway(getEpicPatientSFId: No matching account): app1.SCL_MRN__c:'+app1.SCL_MRN__c+' ;app1.SCL_FirstName__c:'+app1.SCL_ApptFirstName__c+' ;app1.SCL_LastName__c:'+app1.SCL_ApptLastName__c+' ;app1.SCL_PersonEmail__c:'+app1.SCL_PersonEmail__c);                                                                
                                    if (!patientMRNOfNoMatchingAcct.contains(app1.SCL_MRN__c)) {                                        
                                 		Account acc2 = new Account(FirstName=app1.SCL_ApptFirstName__c,LastName=app1.SCL_ApptLastName__c,SCL_MRNPersonAccount__c=app1.SCL_MRN__c,PersonEmail=app1.SCL_PersonEmail__c,RecordTypeId='0124x000000UaEiAAK');
                                   		newAccounts.add(acc2);
                                        patientMRNOfNoMatchingAcct.add(app1.SCL_MRN__c);
                                	}
                                }                               
                            }
                        }
                    }
                }
                System.debug('SCLAppointmentGateway(getEpicPatientSFId: Accounts to be updated):existingAccounts:'+existingAccounts);                
                // Update accounts with the MRN
                if (!existingAccounts.isEmpty()) {
                    update existingAccounts;
                }
                System.debug('SCLAppointmentGateway(getEpicPatientSFId: Accounts to be upserted where email exists):newAccounts:'+newAccounts);                
                if (!newAccounts.isEmpty()) {
                    //insert newAccounts; 
                    upsert newAccounts Account.Fields.SCL_MRNPersonAccount__c;
                    for (Account acc3 : newAccounts) {
                    	patientEpicIdSFIdMap.put(acc3.SCL_MRNPersonAccount__c,acc3);
                    }
                }
            } else {
                // Create new Account for appointment with no Account
                System.debug('epicAppointmentList:'+epicAppointmentList);                
                for (SCL_Appointment__c app1 : epicAppointmentList) {
                    System.debug('SCLAppointmentGateway(getEpicPatientSFId: Account does not exist): app1.SCL_MRN__c:'+app1.SCL_MRN__c+' ;app1.SCL_FirstName__c:'+app1.SCL_ApptFirstName__c+' ;app1.SCL_LastName__c:'+app1.SCL_ApptLastName__c+' ;app1.SCL_PersonEmail__c:'+app1.SCL_PersonEmail__c);                            
                    if (String.isNotBlank(app1.SCL_MRN__c) && String.isNotBlank(app1.SCL_ApptFirstName__c) && String.isNotBlank(app1.SCL_ApptLastName__c)) {
                        String appPersonEmail = '';
                        if(app1.SCL_PersonEmail__c != null) {
                            appPersonEmail = app1.SCL_PersonEmail__c;
                        }
                        Account acc4 = new Account(FirstName=app1.SCL_ApptFirstName__c,LastName=app1.SCL_ApptLastName__c,SCL_MRNPersonAccount__c=app1.SCL_MRN__c,PersonEmail=appPersonEmail,RecordTypeId='0124x000000UaEiAAK');
                        newAccounts.add(acc4);
                    }
                }
                System.debug('SCLAppointmentGateway(getEpicPatientSFId: Accounts to be upserted where email or mrn does not exists):newAccounts:'+newAccounts);                
                if (!newAccounts.isEmpty()) {
                    //insert newAccounts; 
                    upsert newAccounts Account.Fields.SCL_MRNPersonAccount__c;
                    for (Account acc5 : newAccounts) {
                    	patientEpicIdSFIdMap.put(acc5.SCL_MRNPersonAccount__c,acc5);
                    }
                }
            }   
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return patientEpicIdSFIdMap;
    }
	*/
}