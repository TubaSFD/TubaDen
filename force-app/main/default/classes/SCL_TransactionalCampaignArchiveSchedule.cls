global class SCL_TransactionalCampaignArchiveSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
    	SCL_TransactionalCampaignArchive transactionalCampaignArchiveBatch = new SCL_TransactionalCampaignArchive();
      	database.executebatch(transactionalCampaignArchiveBatch, 100);
    }
}