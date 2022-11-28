/*
Name: SCL_TA_Account_AI_MergePatientAccount
Purpose: Trigger Action class for Merging Patient Account after trigger insert
Author: Allan Casalla
Date: 12/21/2021

Change Log
3/29/2022 - Allan Casalla - Fix the bug where the SCL_MergeAccountReference__c is generating 'data value too large' error
7/6/2022 - Allan Casalla - Add null as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
8/22/2022 - Tuba Ciftci - Add a new set to retrieve the stored person phone set from the SCL_TA_Account_BI_GetPersonEmails class.
*/
public class SCL_TA_Account_AI_MergePatientAccount implements TriggerAction.AfterInsert {	
    public void afterInsert(List<Account> newList) { 
        if (newList.isEmpty()) return;
        
        try {           
            Map<String,Account> existingPatientAccountMap = new Map<String,Account>();
            Map<String,Account> newPatientAccountMap = new Map<String,Account>();
            // Retrieve the stored person email set
            Set<String> personEmailSet = SCL_TA_Account_BI_GetPersonEmails.getInstance().beforePersonEmailSet;
            // Retrieve the stored person phone set
            Set<String> personPhoneSet = SCL_TA_Account_BI_GetPersonEmails.getInstance().beforePersonPhoneSet;
            boolean isMergeEmail = true;
            if (personEmailSet != null && !personEmailSet.isEmpty()) {
                existingPatientAccountMap = SCL_AccountGateway.getPatientAccountMap(personEmailSet,false);
                newPatientAccountMap = SCL_AccountGateway.getPatientAccountMap(personEmailSet,true);
                if (existingPatientAccountMap != null && !existingPatientAccountMap.isEmpty() && newPatientAccountMap != null && !newPatientAccountMap.isEmpty()) {            
                    isMergeEmail =false;
                system.debug('existingemail'+existingPatientAccountMap);
                system.debug('newemail'+newPatientAccountMap);  
                    
                }
            }
            if (isMergeEmail && personPhoneSet != null && !personPhoneSet.isEmpty()) {
                existingPatientAccountMap = SCL_AccountGateway.getPatientAccountPhoneMap(personPhoneSet,false);
                newPatientAccountMap = SCL_AccountGateway.getPatientAccountPhoneMap(personPhoneSet,true); 
                system.debug('existing'+existingPatientAccountMap);
                system.debug('new'+newPatientAccountMap);
            }
            
            Id patientRecordTypeId = SCL_GatewayUtils.patientRecordTypeId;
            List<String> fields = SCL_GatewayUtils.patientInterfaceAccountFields.split(',');
            Account existingAccount = new Account();
            Account newAccount = new Account();            
            Database.MergeResult mergeResults;
            
                if(existingPatientAccountMap != null && !existingPatientAccountMap.isEmpty() && newPatientAccountMap != null && !newPatientAccountMap.isEmpty()) {
                for (String existingAccountId : existingPatientAccountMap.keySet()) {
                    newAccount = newPatientAccountMap.get(existingAccountId);
                    if (newAccount != null) {
                        existingAccount = existingPatientAccountMap.get(existingAccountId);
                        for (String field : fields) { 
                            if (newAccount.get(field) != null) existingAccount.put(field,newAccount.get(field)); 
                        }
                        existingAccount.SCL_ConvertedToPatient__c = newAccount.CreatedDate.date();
                        /*
                        Purpose: Set the SCL_MergeAccountReference__c to the most current of value rather than accumulating all the historical values of newAccounts
                        Author: Allan Casalla
                        */ 
                        existingAccount.SCL_MergeAccountReference__c = String.valueOf(String.valueOf(newAccount.Id) + ':' + DateTime.now()).removeStart('null,').removeStart(',');                          
                        // Switch to Patient record type.                                        
                        existingAccount.RecordTypeId = patientRecordTypeId;                        
                        if ((existingAccount.SCL_Deceased__pc != null) && (existingAccount.SCL_Deceased__pc)) {
                            /*
                            Purpose: Add null as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
                            Author: Allan Casalla
                            */
                            existingAccount = SCL_AccountGateway.getRemoveCommunicationAccount(existingAccount,null);
                        }
                        
                        mergeResults = Database.merge(existingAccount,newAccount,false);
                        System.debug('SCL_TA_Account_AI_MergePatientAccount (mergeResults):'+mergeResults);
                    }
                }
            }            
            existingPatientAccountMap = null;
            newPatientAccountMap = null;
            personEmailSet = null;
            personPhoneSet = null;
            existingAccount = null;
            newAccount = null;            
            mergeResults = null;            
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'insert',e);
        }
    }
}