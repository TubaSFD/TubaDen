public with sharing class SCLAccountHandler {
	/*
    //public with sharing class SCLAccountHandler implements SCLInterfaceTrigger {
    List<Account> newTrigger = Trigger.New;
    Map<String,List<Account>> existingAccounts = new Map<String,List<Account>>();
    Map<String,List<Account>> newAccounts = new Map<String,List<Account>>();
    private static List<FieldDefinition> cpAccountFields = [SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.DeveloperName='Account' AND Label LIKE 'CP:%' AND DataType='Checkbox'];
    // Constructor
	public SCLAccountHandler() {
	}
    
	public void bulkBefore() {
		List<String> patientEmailStr = new List<String>();        
        Map<String,List<Account>> matchedAccounts = new Map<String,List<Account>>();
                 
        for (Account acc : newTrigger) {                
            if (acc.IsPersonAccount) {
                if (Trigger.isInsert) {
                    if (acc.PersonEmail != null) {
                        if (!patientEmailStr.contains(acc.PersonEmail)) {
                            patientEmailStr.add(acc.PersonEmail);
                        }
                    }
                }                
                // Set the Territory Related field to null, since this only applicable to Business account
                acc.SCL_TerritoryRelated__c = null;  
                // Remove communication to a deceased person account
                if ((acc.SCL_Deceased__pc != null) && (acc.SCL_Deceased__pc)) {
                    acc.PersonDoNotCall = true;
                    acc.PersonHasOptedOutOfEmail = true;
                    acc.PersonHasOptedOutOfFax = true;
                    acc.SCL_DoNotSolicit__pc = true;
                    acc.SCL_MobileOptOut__pc = true;
                    acc.et4ae5__HasOptedOutOfMobile__pc = true;
                    acc.SCL_MedSyncOptIn__pc = 'Declined';
                    // Set all the CP fields to false
                    for (FieldDefinition cpAccountField: cpAccountFields) { 
                        acc.put(cpAccountField.QualifiedApiName,false);                    	
                    }
                }
            } 
        }
        System.debug('AccountHandler(bulkBefore): patientEmailStr = ' + patientEmailStr);
        
        if (!patientEmailStr.isEmpty()) {
            matchedAccounts = SCLAccountGateway.getMatchAccounts(patientEmailStr);
            for (String matchAccountId : matchedAccounts.keySet()) {
                List<Account> matchedAccts = matchedAccounts.get(matchAccountId);
                System.debug('AccountHandler(bulkBefore): matchedAccounts = ' + matchedAccts);
                
                for (Account matchedAcct: matchedAccts) {                        
                    for (Account acc1 : newTrigger) {
                        if (String.isBlank(acc1.SCL_MRNPersonAccount__c) && (acc1.PersonEmail.toLowerCase() == matchedAcct.PersonEmail.toLowerCase()) && (acc1.FirstName.toLowerCase() == matchedAcct.FirstName.toLowerCase()) &&(acc1.LastName.toLowerCase() == matchedAcct.LastName.toLowerCase())) {
                            acc1.addError('Account Trigger Error: This is a possible duplicate record. Please confirm the person is different than the record(s) found.');
                        }                             
                    }
                }
            }
        }        
    }
    
	public void bulkAfter() {
        List<String> patientEmailStr = new List<String>();
        if (Trigger.isInsert || Trigger.isUpdate) { 
            for (Account acc1 : newTrigger) {
                if ((acc1.IsPersonAccount) && (acc1.PersonEmail != null)) {
                    if (!patientEmailStr.contains(acc1.PersonEmail)) {
                        patientEmailStr.add(acc1.PersonEmail);
                    }
                }
            }
            System.debug('AccountHandler(bulkAfter): patientEmailStr = ' + patientEmailStr);
            // Query Account records with emails matching trigger
            if (!patientEmailStr.isEmpty()) {
                // Get the Accounts without Epic Ids - limited by the current set of new emails
                existingAccounts = SCLAccountGateway.getExistingPatAccount(patientEmailStr);
				
                // Get the Accounts with Epic Ids - These should be the newly inserted accounts
                newAccounts = SCLAccountGateway.getNewPatAccounts(patientEmailStr);
            }
            System.debug('AccountHandler(bulkAfter): existingAccounts = ' + existingAccounts);
            System.debug('AccountHandler(bulkAfter): newAccounts = ' + newAccounts);      
        }
	}
		
	public void beforeInsert(SObject so){
	}
	
	public void beforeUpdate(SObject oldSo, SObject so) {     
	}
	
	public void beforeDelete(SObject so) {	
	}
	
	public void afterInsert(SObject so) {
	}
	
	public void afterUpdate(SObject oldSo, SObject so) {          
	}
	
	public void afterDelete(SObject so) {
	}
	
	public void andFinally() {
        // Merge the newly created Person Account/Patient with the Epic Id
        // to the existing Person Account (Patient or Marketing record types)
        // if the email, name match between the two records
        // the existing Person Account should survive in case it is a part of a campaign or case
        Boolean isMerged = false;
        try {
        	if (!existingAccounts.isEmpty() && !newAccounts.isEmpty()) {
            	for (String existingAccountId : existingAccounts.keySet()) {
                    List<Account> existingAccounts = existingAccounts.get(existingAccountId);
                    System.debug('andFinally: existingAccounts = ' + existingAccounts);
                    List<Account> newAccounts = newAccounts.get(existingAccountId);
                    System.debug('andFinally: newAccounts = ' + newAccounts);
                    if (existingAccounts != null) {
                        for (Account existingAccount: existingAccounts) {
                            Account removeAccount = new Account();
                            if (newAccounts != null) {  
                                for (Account newAccount: newAccounts) {
                                    removeAccount = newAccount;
                                    System.debug('Evaluate Match existing First, last, email: '+ existingAccount.PersonEmail +':' + existingAccount.FirstName +':' + existingAccount.LastName);
                                    System.debug('Evaluate Match newAccount First, last, email: '+ newAccount.PersonEmail +':' + newAccount.FirstName +':' + newAccount.LastName);
                                    if (existingAccount.PersonEmail.toLowerCase() == newAccount.PersonEmail.toLowerCase() && 
                                       existingAccount.FirstName.toLowerCase() == newAccount.FirstName.toLowerCase() && 
                                       existingAccount.LastName.toLowerCase() == newAccount.LastName.toLowerCase()) {                               
                                            // Merge is dumb - doesn't merge fields just contacts
                                            System.debug('Merging a match');							   
                                            existingAccount.SCL_MRNPersonAccount__c = newAccount.SCL_MRNPersonAccount__c;
                                            existingAccount.MiddleName = newAccount.MiddleName;
                                            existingAccount.SCL_PreferredFirstName__pc = newAccount.SCL_PreferredFirstName__pc;
                                            existingAccount.SCL_Birthdate__pc = newAccount.SCL_Birthdate__pc;
                                            existingAccount.SCL_SSN__pc = newAccount.SCL_SSN__pc;
                                            existingAccount.SCL_SSNLast4__pc = newAccount.SCL_SSNLast4__pc;
                                            existingAccount.PersonMailingStreet = newAccount.PersonMailingStreet;
                                            existingAccount.PersonMailingCity = newAccount.PersonMailingCity;
                                            existingAccount.PersonMailingPostalCode = newAccount.PersonMailingPostalCode;
                                            existingAccount.PersonMailingState = newAccount.PersonMailingState;
                                            existingAccount.PersonHomePhone = newAccount.PersonHomePhone;
                                            existingAccount.PersonMobilePhone = newAccount.PersonMobilePhone;
                                            existingAccount.PersonOtherPhone = newAccount.PersonOtherPhone;
                                            existingAccount.SCL_Employer__pc = newAccount.SCL_Employer__pc;
                                            existingAccount.SCL_InsuranceProvider__pc = newAccount.SCL_InsuranceProvider__pc;
                                            existingAccount.SCL_MyChartStatus__pc = newAccount.SCL_MyChartStatus__pc;
                                            existingAccount.SCL_MyChartLastLogin__pc = newAccount.SCL_MyChartLastLogin__pc;
                                            existingAccount.SCL_MyChartLastMethod__pc = newAccount.SCL_MyChartLastMethod__pc;
                                            existingAccount.SCL_Gender__pc = newAccount.SCL_Gender__pc;
                                            existingAccount.SCL_AgePush__pc = newAccount.SCL_AgePush__pc;
                                            existingAccount.SCL_DeceasedDate__pc = newAccount.SCL_DeceasedDate__pc;
                                            existingAccount.SCL_Deceased__pc = newAccount.SCL_Deceased__pc;
                                            existingAccount.SCL_PCPName__pc = newAccount.SCL_PCPName__pc;
                                            existingAccount.SCL_PCPClinicName__pc = newAccount.SCL_PCPClinicName__pc;
                                            existingAccount.SCL_LastVisitedClinic__pc = newAccount.SCL_LastVisitedClinic__pc;
                                            existingAccount.SCL_LastVisitedCareSite__pc = newAccount.SCL_LastVisitedCareSite__pc;
                                            existingAccount.SCL_DischargeDate__pc = newAccount.SCL_DischargeDate__pc;
                                            existingAccount.SCL_DischargeTime__pc = newAccount.SCL_DischargeTime__pc;
                                            existingAccount.SCL_PillPlannerStatus__pc = newAccount.SCL_PillPlannerStatus__pc;
                                            existingAccount.SCL_PillPlannerEnrolledDate__pc = newAccount.SCL_PillPlannerEnrolledDate__pc;
                                            existingAccount.SCL_Meds2BedsStatus__pc = newAccount.SCL_Meds2BedsStatus__pc;
                                            existingAccount.SCL_Meds2BedsEnrolledDate__pc = newAccount.SCL_Meds2BedsEnrolledDate__pc;
                                            existingAccount.SCL_AntiCoagStatus__pc = newAccount.SCL_AntiCoagStatus__pc;
                                            existingAccount.SCL_AntiCoagEnrolledDate__pc = newAccount.SCL_AntiCoagEnrolledDate__pc;
                                            existingAccount.SCL_PreferredCommunication__pc = newAccount.SCL_PreferredCommunication__pc;
                                            existingAccount.SCL_ConvertedToPatient__c = newAccount.CreatedDate.date();
                                            String mergeAccount = existingAccount.SCL_MergeAccountReference__c + ',' + String.valueOf(newAccount.Id) + ':' + DateTime.now();
                                            mergeAccount = mergeAccount.removeStart('null,').removeStart(',');
                                            existingAccount.SCL_MergeAccountReference__c = mergeAccount;                                
                                            // Switch to Patient record type.
                                            existingAccount.RecordTypeId = '0124x000000UaEiAAK';                                
                                            Database.MergeResult mergeResults = Database.merge(existingAccount,newAccount,false);
                                            System.debug('mergeResults = ' + mergeResults);
                                            isMerged=true;
                                            // break out of the loop - only merging the first one
                                            // otherwise we would collapse multiple account id's that may be
                                            // in marketing cloud on different journeys
                                           continue; 
                                    }
                                }
                                if (isMerged) { // If the new account is merged it has been deleted - remove of loop list.
                                    isMerged=false;
                                    newAccounts.remove(newAccounts.indexOf(removeAccount));
                                    continue;
                                }
                            }
                        }
                    }
            	}
        	}
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
	}
	*/
}