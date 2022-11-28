//Story Number
//STY-00050
global class SCL_AntiCoagInPatientSchedulable implements Schedulable{
    global void execute(SchedulableContext sc)
    {
    	SCL_AntiCoagInPatientAutoClose antiCoagInPatientBatch = new SCL_AntiCoagInPatientAutoClose();
      	database.executebatch(antiCoagInPatientBatch, 100);
    }
}