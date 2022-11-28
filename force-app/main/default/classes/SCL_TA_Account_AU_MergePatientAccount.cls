/*
Name: SCL_TA_Account_AU_MergePatientAccount
Purpose: Trigger Action class for Merging Patient Account after trigger update
Author: Allan Casalla
Date: 12/21/2021

Change Log
3/28/2022 - Allan Casalla - Fix the bug where the SCL_MergeAccountReference__c is generating 'data value too large' error
7/6/2022 - Allan Casalla - Add oldAcc as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
8/22/2022 - Tuba Ciftci - Add a new set to retrieve the stored person phone set from the SCL_TA_Account_BU_GetPersonEmails class.
*/
public class SCL_TA_Account_AU_MergePatientAccount implements TriggerAction.AfterUpdate {
  public void afterUpdate(List<Account> newList, List<Account> oldList) {	
      if (newList.isEmpty()) return;
                
      try {
          Map<String,Account> existingPatientAccountMap = new Map<String,Account>();
          Map<String,Account> newPatientAccountMap = new Map<String,Account>();
          Map<Id,Account> oldMap = new Map<Id,Account>(oldList);
          // Retrieve the stored person email set
          Set<String> personEmailSet = SCL_TA_Account_BU_GetPersonEmails.getInstance().beforePersonEmailSet;
          // Retrieve the stored person phone set
          Set<String> personPhoneSet = SCL_TA_Account_BU_GetPersonEmails.getInstance().beforePersonPhoneSet;
          boolean isMergeEmail = true;
           if (personEmailSet != null && !personEmailSet.isEmpty()) {
          	existingPatientAccountMap = SCL_AccountGateway.getPatientAccountMap(personEmailSet,false);          
          	newPatientAccountMap = SCL_AccountGateway.getPatientAccountMap(personEmailSet,true);
            isMergeEmail =false;
          } 
          if (isMergeEmail && personPhoneSet != null && !personPhoneSet.isEmpty()) {
                existingPatientAccountMap = SCL_AccountGateway.getPatientAccountPhoneMap(personPhoneSet,false);
                newPatientAccountMap = SCL_AccountGateway.getPatientAccountPhoneMap(personPhoneSet,true);   
          }
          Account existingAccount = new Account();
          Account newAccount = new Account(); 
          Database.MergeResult mergeResults;
          Id patientRecordTypeId = SCL_GatewayUtils.patientRecordTypeId;
          List<String> fields = SCL_GatewayUtils.patientInterfaceAccountFields.split(',');
          if (existingPatientAccountMap != null && !existingPatientAccountMap.isEmpty() && newPatientAccountMap != null && !newPatientAccountMap.isEmpty()) {              
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
                      	  Purpose: Add oldAcc as the second parameter for SCL_AccountGateway.getRemoveCommunicationAccount
					  	  Author: Allan Casalla
                      	  */
                          Account oldAcc = oldMap.get(existingAccount.Id);                          
                          existingAccount = SCL_AccountGateway.getRemoveCommunicationAccount(existingAccount,oldAcc);
                      }   
                      
                      mergeResults = Database.merge(existingAccount,newAccount,false);
                      System.debug('SCL_TA_Account_AU_MergePatientAccount (mergeResults):'+mergeResults);
                  }
              }
          }          
          existingPatientAccountMap = null;
          newPatientAccountMap = null;
          personEmailSet = null;
         // personPhoneSet = null;
          existingAccount = null;
          newAccount = null;
          mergeResults = null;          
      } catch (Exception e) {            
          SCL_GatewayUtils.publishException(newList,'update',e);
      }
  }
}