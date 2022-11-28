@isTest
public class SCL_PlannedOutreachArchiveTest {
    static testmethod void testData() {
        
        //Custom Settings Data
		SCL_ComponentParameters__c instance = new SCL_ComponentParameters__c();
        instance.Name = 'Planned Outreach Archive Age';
        instance.SCL_PlannedOutreachArchiveAge__c = 15;
        insert instance;

        SCL_PlannedOutreach__c plannedOutreachInstance = new SCL_PlannedOutreach__c();
        plannedOutreachInstance.SCL_LastName__c = 'Test1';
        plannedOutreachInstance.SCL_Age__c = 1;
        insert plannedOutreachInstance;
        
        Datetime yesterday = Datetime.now().addDays(-20);
        Test.setCreatedDate(plannedOutreachInstance.Id, yesterday);
        
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_PlannedOutreachArchiveSchedulable scheduleObj = new SCL_PlannedOutreachArchiveSchedulable();
            SCL_PlannedOutreachArchive obj = new SCL_PlannedOutreachArchive();
            Database.executeBatch(obj);
        	scheduleObj.execute(sc);
        Test.stopTest();
        
    }
}