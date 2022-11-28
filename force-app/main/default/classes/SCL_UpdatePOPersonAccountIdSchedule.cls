global class SCL_UpdatePOPersonAccountIdSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
    	SCL_UpdatePOPersonAccountId updatePOPersonAccountId = new SCL_UpdatePOPersonAccountId();
      	database.executebatch(updatePOPersonAccountId, 100);
    }
}