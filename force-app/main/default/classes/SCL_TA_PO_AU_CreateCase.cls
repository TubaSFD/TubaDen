public class SCL_TA_PO_AU_CreateCase implements TriggerAction.AfterUpdate {
  public void afterUpdate(List<SCL_PlannedOutreach__c> newList, List<SCL_PlannedOutreach__c> oldList) {	
      if (newList == null) return;                    
      if (SCL_TA_PO_BU_UpdateWithCase.getInstance().withCase != null && SCL_TA_PO_BU_UpdateWithCase.getInstance().withCase) SCL_POGateway.createCase(newList);
  }
}