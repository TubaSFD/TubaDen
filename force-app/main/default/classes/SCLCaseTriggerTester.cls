// Tests for Case trigger
@isTest
public class SCLCaseTriggerTester {
    @isTest static void testCaseTrigger(){
        /*
        // Create first Case - represents an inbound Case where there is no existing account.
        Case case1 = new Case();
        case1.SCL_FormFirstName__c = 'TEST';
        case1.SCL_FormLastName__c = 'TEST';
        case1.SCL_MRN__c = 'X012345678';
        case1.SCL_FormEmail__c = 'test.test@test.com';
        case1.SCL_FormCampaignName__c = 'NewMover';
        case1.Form_Age__c = 40;
        case1.Origin = 'Data Feed';
        case1.RecordTypeId = '0124x000000UM8bAAG';
                
    	Database.UpsertResult sr1 = Database.upsert(case1, false);
        Case case2 = [SELECT Id,AccountId,ContactId,CaseNumber,SCL_FormEmail__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c,Origin,Subject,IsClosed FROM Case WHERE SCL_FormEmail__c = 'test.test@test.com' AND SCL_FormCampaignName__c='NewMover'];
        System.debug('Case2.Id: ' + case2.Id + ' ;case2.AccountId: ' + case2.AccountId + ' ;case2.ContactId: ' + case2.ContactId);
        System.assertNotEquals(case2.Id, null); 
        System.assertNotEquals(case2.ContactId, null);                
        
        // Create second Case - represents an inbound Case where there is an existing account.
        Case case3 = new Case();
        case3.SCL_FormFirstName__c = 'TEST';
        case3.SCL_FormLastName__c = 'TEST';
        case3.SCL_MRN__c = 'X012345678';
        case3.SCL_FormEmail__c = 'test.test@test.com';
        case3.SCL_FormCampaignName__c = 'Health 360';
        case3.Form_Age__c = 40;
        case3.Origin = 'Webform';
        case3.SCL_FormCPBody__c = true;
        case3.RecordTypeId = '0124x000000UM8bAAG';
                
    	Database.UpsertResult sr2 = Database.upsert(case3, false);
        Case case4 = [SELECT Id,AccountId,ContactId,CaseNumber,SCL_FormEmail__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c,Origin,Subject,IsClosed FROM Case WHERE SCL_FormEmail__c = 'test.test@test.com' AND SCL_FormCampaignName__c='Health 360'];
        System.debug('Case Id: ' + case4.Id + ' ;case4.AccountId: ' + case4.AccountId + ' ;case4.ContactId: ' + case4.ContactId);
        System.assertNotEquals(case4.Id, null); 
        System.assertNotEquals(case4.ContactId, null); 
    	
        // Create third Case - represents an inbound Case where there is an existing account.
        Case case5 = new Case();
        case5.SCL_FormFirstName__c = 'TEST';
        case5.SCL_FormLastName__c = 'TEST';
        case5.SCL_MRN__c = 'X012345678';
        case5.SCL_FormEmail__c = 'test.test@test.com';
        case5.SCL_FormCampaignName__c = 'Covid Vaccine';
        case5.Form_Age__c = 40;
        case5.Origin = 'Webform';
        case5.SCL_FormCPBody__c = true;
        case5.SCL_1stOutreachAttempted__c = null;
        case5.RecordTypeId = '0124x000000UM8bAAG';
                
    	Database.UpsertResult sr3 = Database.upsert(case5, false);
        Case case6 = [SELECT Id,AccountId,ContactId,CaseNumber,SCL_FormEmail__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c,Origin,Subject,IsClosed FROM Case WHERE SCL_FormEmail__c = 'test.test@test.com' AND SCL_FormCampaignName__c='Covid Vaccine'];
        System.debug('Case Id: ' + case6.Id + ' ;case6.AccountId: ' + case6.AccountId + ' ;case6.ContactId: ' + case6.ContactId);
        System.assertNotEquals(case6.Id, null); 
        System.assertNotEquals(case6.ContactId, null); 
        
        // Load again the first Case but different MRN, to test the duplicate
        Case case7 = new Case();
        case7.SCL_FormFirstName__c = 'TEST';
        case7.SCL_FormLastName__c = 'TEST';
        case7.SCL_MRN__c = 'X012345679';
        case7.SCL_FormEmail__c = 'test.test@test.com';
        case7.SCL_FormCampaignName__c = 'NewMover';
        case7.Form_Age__c = 40;
        case7.Origin = 'Data Feed';
        case7.RecordTypeId = '0124x000000UM8bAAG';
                
    	Database.UpsertResult sr4 = Database.upsert(case7, false);
        Case case8 = [SELECT Id,AccountId,ContactId,CaseNumber,SCL_FormEmail__c,SCL_MRN__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c,Origin,Subject,IsClosed FROM Case WHERE SCL_FormEmail__c = 'test.test@test.com' AND SCL_FormCampaignName__c='NewMover'];
        System.debug('Case8.Id: ' + case8.Id + ' ;case8.AccountId: ' + case8.AccountId + ' ;case8.ContactId: ' + case8.ContactId + ' ;case8.SCL_MRN__c: ' + case8.SCL_MRN__c);
        System.assertNotEquals(case8.SCL_MRN__c, 'X012345679');  
        
        // Create Case for pill planner.
        Case case9 = new Case();
        case9.SCL_FormFirstName__c = 'TEST';
        case9.SCL_FormLastName__c = 'TEST';
        case9.SCL_MRN__c = 'X012345678';
        case9.SCL_FormEmail__c = 'test.test@test.com';
        case9.SCL_FormCampaignName__c = 'Pill Planner';
        case9.Form_Age__c = 40;
        case9.Origin = 'Webform';
        case9.RecordTypeId = '0124x000000UM8bAAG';
                
    	Database.UpsertResult sr5 = Database.upsert(case9, false);
        Case case10 = [SELECT Id,AccountId,ContactId,CaseNumber,SCL_FormEmail__c,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormCampaignName__c,Origin,Subject,SCL_CaseAssigned__c,IsClosed FROM Case WHERE SCL_FormEmail__c = 'test.test@test.com' AND SCL_FormCampaignName__c='Pill Planner'];
        System.debug('Case10.Id: ' + case10.Id + ' ;case10.AccountId: ' + case10.AccountId + ' ;case10.ContactId: ' + case10.ContactId);
        System.assertEquals(case10.SCL_CaseAssigned__c, 'PB Routing Rule Applied'); 
		*/
    }
}