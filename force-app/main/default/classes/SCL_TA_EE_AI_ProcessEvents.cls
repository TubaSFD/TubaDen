public class SCL_TA_EE_AI_ProcessEvents implements TriggerAction.AfterInsert {
	public void afterInsert(List<SCL_ExceptionEvent__e> newList) {        
        SCL_ExceptionEventGateway.processExceptionEvents(newList);    	        
  	}
}