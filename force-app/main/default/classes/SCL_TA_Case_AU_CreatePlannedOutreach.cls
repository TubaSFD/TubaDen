public class SCL_TA_Case_AU_CreatePlannedOutreach implements TriggerAction.AfterUpdate {
  public void afterUpdate(List<Case> newList, List<Case> oldList) {	
      if (newList.isEmpty()) return;         
      if (SCL_TA_Case_BU_UpdateWithPlannedOutreach.getInstance().withPO != null && SCL_TA_Case_BU_UpdateWithPlannedOutreach.getInstance().withPO) SCL_CaseGateway.createPlannedOutreach(newList);         
  }
}