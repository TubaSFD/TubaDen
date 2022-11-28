public class SCL_TA_Account_BU_RemoveCommunication implements TriggerAction.BeforeUpdate {    
	public void beforeUpdate(List<Account> newList, List<Account> oldList) {	
        if (newList.isEmpty()) return;
        newList = SCL_AccountGateway.getRemoveCommunicationAccounts(newList,oldList);                            
  	}	    
}