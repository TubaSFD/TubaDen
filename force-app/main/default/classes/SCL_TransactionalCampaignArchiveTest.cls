@isTest
public class SCL_TransactionalCampaignArchiveTest {
	static testmethod void testData() {
        
        //Custom Settings Data
		SCL_ComponentParameters__c instance = new SCL_ComponentParameters__c();
        instance.Name = 'SCL Transactional Campaigns';
        instance.SCL_TransactionalCampaigns__c = 'C00019,C00020,C00021,C00022';
        insert instance;

        SCL_PlannedOutreach__c plannedOutreachInstance = new SCL_PlannedOutreach__c();
        plannedOutreachInstance.SCL_CampaignNumber__c = 'C00019';
        plannedOutreachInstance.SCL_LastName__c = 'Test1';
        insert plannedOutreachInstance;
        
        Datetime yesterday = Datetime.now().addDays(-20);
        Test.setCreatedDate(plannedOutreachInstance.Id, yesterday);
        
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_TransactionalCampaignArchiveSchedule scheduleObj = new SCL_TransactionalCampaignArchiveSchedule();
            SCL_TransactionalCampaignArchive obj = new SCL_TransactionalCampaignArchive();
            Database.executeBatch(obj);
        	scheduleObj.execute(sc);
        Test.stopTest();
        
    }
}