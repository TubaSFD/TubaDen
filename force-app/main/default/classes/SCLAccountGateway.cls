public without sharing class SCLAccountGateway {   
    /*
    // Using a list of emails, get a list of person account records that do not have an MRN.
    // These are the person accounts loaded by some other means than the Epic integration like  
    // bulk Planned Outreach uploads or Web-to-Case or NewMover.
    public static Map<String,List<Account>> getExistingPatAccount(List<String> emails) {
        Map<String,List<Account>> existingPatAccEmailSFIdMap = new Map<String,List<Account>>();
        List<Account> accounts = [SELECT Id,PersonEmail,FirstName,MiddleName,LastName,SCL_MRNPersonAccount__c,SCL_PreferredFirstName__pc,
									SCL_Birthdate__pc,SCL_SSN__pc,SCL_SSNLast4__pc,PersonMailingStreet,PersonMailingCity,
                                    PersonMailingPostalCode,PersonMailingState,PersonHomePhone,PersonMobilePhone,
                                    PersonOtherPhone,SCL_Employer__pc,SCL_InsuranceProvider__pc,SCL_MyChartStatus__pc,
                                    SCL_MyChartLastLogin__pc,SCL_MyChartLastMethod__pc,SCL_Gender__pc,SCL_AgePush__pc,
                                    SCL_DeceasedDate__pc,SCL_Deceased__pc,SCL_PCPName__pc,SCL_PCPClinicName__pc,
                                    SCL_LastVisitedClinic__pc,SCL_LastVisitedCareSite__pc,SCL_DischargeDate__pc,SCL_DischargeTime__pc,
                                    SCL_PillPlannerStatus__pc,SCL_PillPlannerEnrolledDate__pc,SCL_Meds2BedsStatus__pc,
                                    SCL_Meds2BedsEnrolledDate__pc,SCL_AntiCoagStatus__pc,SCL_AntiCoagEnrolledDate__pc,
									SCL_PreferredCommunication__pc,SCL_ConvertedToPatient__c,SCL_MergeAccountReference__c,RecordTypeId                                    								  
        						  FROM Account WHERE PersonEmail IN :emails AND IsPersonAccount = true AND SCL_MRNPersonAccount__c = NULL];
        
        for (Account acc : accounts) {
        	if (!existingPatAccEmailSFIdMap.containsKey(acc.PersonEmail)) {
                    existingPatAccEmailSFIdMap.put(acc.PersonEmail, new List<Account>());
            }
            existingPatAccEmailSFIdMap.get(acc.PersonEmail).add(acc);
        }
        
        return existingPatAccEmailSFIdMap;
    }
	// Using a list of emails, get a list of Person Account records that do have an MRN.   
    public static Map<String,List<Account>> getNewPatAccounts(List<String> emails) {
        Map<String,List<Account>> newPatAccEmailSFIdMap = new Map<String,List<Account>>();
        List<Account> accounts = [SELECT Id,PersonEmail,FirstName,MiddleName,LastName,SCL_MRNPersonAccount__c,SCL_PreferredFirstName__pc,
									SCL_Birthdate__pc,SCL_SSN__pc,SCL_SSNLast4__pc,PersonMailingStreet,PersonMailingCity,
                                    PersonMailingPostalCode,PersonMailingState,PersonHomePhone,PersonMobilePhone,
                                    PersonOtherPhone,SCL_Employer__pc,SCL_InsuranceProvider__pc,SCL_MyChartStatus__pc,
                                    SCL_MyChartLastLogin__pc,SCL_MyChartLastMethod__pc,SCL_Gender__pc,SCL_AgePush__pc,
                                    SCL_DeceasedDate__pc,SCL_Deceased__pc,SCL_PCPName__pc,SCL_PCPClinicName__pc,
                                    SCL_LastVisitedClinic__pc,SCL_LastVisitedCareSite__pc,SCL_DischargeDate__pc,SCL_DischargeTime__pc,
                                    SCL_PillPlannerStatus__pc,SCL_PillPlannerEnrolledDate__pc,SCL_Meds2BedsStatus__pc,
                                    SCL_Meds2BedsEnrolledDate__pc,SCL_AntiCoagStatus__pc,SCL_AntiCoagEnrolledDate__pc,
                                    SCL_PreferredCommunication__pc,SCL_ConvertedToPatient__c,CreatedDate,RecordTypeId                                    
								  FROM Account WHERE PersonEmail IN :emails AND IsPersonAccount = true AND SCL_MRNPersonAccount__c != NULL];
        
        for (Account acc : accounts) {
        	if (!newPatAccEmailSFIdMap.containsKey(acc.PersonEmail)) {
            	newPatAccEmailSFIdMap.put(acc.PersonEmail, new List<Account>());
            }
            newPatAccEmailSFIdMap.get(acc.PersonEmail).add(acc);
        }
  
        return newPatAccEmailSFIdMap;
    }
    // Using a list of emails, get a list of Person Account records that matches the PersonEmail.   
    public static Map<String,List<Account>> getMatchAccounts(List<String> emails) {
        Map<String,List<Account>> currentMatchAccountsMap = new Map<String,List<Account>>();
        List<Account> accounts = [SELECT Id,PersonEmail,FirstName,LastName FROM Account WHERE PersonEmail IN :emails AND IsPersonAccount = true];
        
        for (Account acc : accounts) {
        	if (!currentMatchAccountsMap.containsKey(acc.PersonEmail)) {
            	currentMatchAccountsMap.put(acc.PersonEmail, new List<Account>());
            }
            currentMatchAccountsMap.get(acc.PersonEmail).add(acc);
        }
  
        return currentMatchAccountsMap;
    }
	*/
}