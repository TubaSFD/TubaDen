public class SCL_TA_Account_AU_MergeProspectAccount implements TriggerAction.AfterUpdate {
    public void afterUpdate(List<Account> newList, List<Account> oldList) {	
        if (newList.isEmpty()) return;
        
        try {
            Map<String,List<Account>> prospectAccountMap = new Map<String,List<Account>>();
            // Retrieve the saved person email set
            Set<String> personEmailSet = SCL_TA_Account_BU_GetPersonEmails.getInstance().beforePersonEmailSet;
            // Retrieve the saved phone set
            Set<String> patientPhoneSet = SCL_TA_Account_BU_GetPersonEmails.getInstance().beforePersonPhoneSet;
            boolean isMergeEmail = true;
            if (personEmailSet != null && !personEmailSet.isEmpty()){	
                prospectAccountMap = SCL_AccountGateway.getprospectAccountMap(personEmailSet); 
                if(prospectAccountMap != null && !prospectAccountMap.isEmpty()){
                isMergeEmail = false;
                }
            }	
            if (isMergeEmail && patientPhoneSet != null && !patientPhoneSet.isEmpty()) prospectAccountMap = SCL_AccountGateway.getProspectAccountPhoneMap(patientPhoneSet);  
            List<Account> prospectAccounts = new List<Account>();
            List<Id> duplicatedAccounts = new List<Id>();
            Account masterAccount = new Account();
            Account tempMasterAccount = new Account();  
            Database.MergeResult[] mergeResults;
            
            if (prospectAccountMap != null && !prospectAccountMap.isEmpty()) {              
                for (String personKeyId : prospectAccountMap.keySet()) {
                    prospectAccounts = prospectAccountMap.get(personKeyId);
                    if (prospectAccounts.size() == 1) continue;
                    duplicatedAccounts = new List<Id>();
                    for(Integer i = 0; i < prospectAccounts.size(); i++) {
                        if (i == 0) { 
                            tempMasterAccount = prospectAccounts[0];
                        } else {
                            if (tempMasterAccount.CreatedDate <= prospectAccounts[i].CreatedDate) {
                                masterAccount.Id = tempMasterAccount.Id;
                                duplicatedAccounts.add(prospectAccounts[i].Id);                                
                            } else {
                                duplicatedAccounts.add(tempMasterAccount.Id);
                                masterAccount.Id = prospectAccounts[i].Id;                                
                                tempMasterAccount = prospectAccounts[i];
                            }                            
                        }    
                    }                  
                    if (duplicatedAccounts.size() > 0) {                      
                        mergeResults = Database.merge(masterAccount,duplicatedAccounts,false);
                        System.debug('SCL_TA_Account_AU_MergeProspectAccount (mergeResults):'+mergeResults);
                    }
                }
            }          
            prospectAccountMap = null;
            personEmailSet = null;
            patientPhoneSet = null;
            prospectAccounts = null;
            duplicatedAccounts = null;
            masterAccount = null;
            tempMasterAccount = null;
            mergeResults = null;          
        } catch (Exception e) {            
            SCL_GatewayUtils.publishException(newList,'update',e);
        }
    }
}