global class SCL_DeleteExceptionLogSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
    	SCL_DeleteExceptionLog deleteExceptionLog = new SCL_DeleteExceptionLog();
      	database.executebatch(deleteExceptionLog, 100);
    }
}