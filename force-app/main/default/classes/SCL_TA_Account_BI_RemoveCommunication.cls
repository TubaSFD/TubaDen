public class SCL_TA_Account_BI_RemoveCommunication implements TriggerAction.BeforeInsert {    
	public void beforeInsert(List<Account> newList) { 
        if (newList.isEmpty()) return;        
        newList = SCL_AccountGateway.getRemoveCommunicationAccounts(newList,null);
  	}	    
}