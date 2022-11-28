@isTest
public class SCL_UpdatePOPersonAccountIdTest {
	static testmethod void testData() {        
        SCL_PlannedOutreach__c po = new SCL_PlannedOutreach__c();
        po.SCL_MRN__c = 'X111111111';  
        po.SCL_Email__c = 'test-1.test-1@test.com';
        po.SCL_FirstName__c = 'Test-1';  
        po.SCL_LastName__c = 'Test-1';  
        po.SCL_CampaignNumber__c = 'C00014';  
        po.SCL_CampaignName__c = 'Front Range Medical Group';  
        MetadataTriggerHandler.bypass('SCL_TA_PO_BI_AccountQueries'); 
        MetadataTriggerHandler.bypass('SCL_TA_PO_BI_MatchAccount'); 
        insert po;
        MetadataTriggerHandler.clearBypass('SCL_TA_PO_BI_AccountQueries'); 
        MetadataTriggerHandler.clearBypass('SCL_TA_PO_BI_MatchAccount'); 
        
        SCL_PlannedOutreach__c po1 = [SELECT Id,SCL_FirstName__c,SCL_LastName__c,SCL_MRN__c,SCL_Email__c,SCL_PersonAccount__c FROM SCL_PlannedOutreach__c WHERE SCL_MRN__c=:po.SCL_MRN__c];
        System.debug('po1:'+po1);
        
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_UpdatePOPersonAccountIdSchedule scheduleObj = new SCL_UpdatePOPersonAccountIdSchedule();
            SCL_UpdatePOPersonAccountId obj = new SCL_UpdatePOPersonAccountId();
            Database.executeBatch(obj);
        	scheduleObj.execute(sc);
        Test.stopTest();        
    }
}