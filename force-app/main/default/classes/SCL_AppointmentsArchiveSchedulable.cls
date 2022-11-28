global class SCL_AppointmentsArchiveSchedulable implements Schedulable{
    global void execute(SchedulableContext sc)
    {
    	SCL_AppointmentsArchive appointmentsArchiveBatch = new SCL_AppointmentsArchive();
      	database.executebatch(appointmentsArchiveBatch, 100);
    }
}