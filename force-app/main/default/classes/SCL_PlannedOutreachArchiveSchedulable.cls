global class SCL_PlannedOutreachArchiveSchedulable implements Schedulable{
    global void execute(SchedulableContext sc)
    {
    	SCL_PlannedOutreachArchive plannedOutreachArchiveBatch = new SCL_PlannedOutreachArchive();
      	database.executebatch(plannedOutreachArchiveBatch, 100);
    }
}