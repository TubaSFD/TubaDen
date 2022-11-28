// Tests for PlannedOutreach trigger
@isTest(SeeAllData=true) 
public class SCLPlannedOutreachTriggerTester {    
    @isTest static void testPlannedOutreachTrigger(){
        /*
        Schema.SObjectField sclExternalID = SCL_PlannedOutreach__c.Fields.SCL_ExternalID__c;
        // Test for MRN as Id
        // Create Planned Outreach without an existing account
        SCL_PlannedOutreach__c po1 = new SCL_PlannedOutreach__c();
        po1.SCL_FirstName__c = 'POTest1';
        po1.SCL_LastName__c = 'POTest1';
        po1.SCL_MRN__c = 'X111111111';
        po1.SCL_Phone__c = '949-890-0987';
        po1.SCL_CampaignNumber__c = 'C00017';
        po1.SCL_CampaignName__c = 'E-Visit Patients';
        po1.SCL_ExternalID__c =  po1.SCL_CampaignNumber__c + po1.SCL_FirstName__c + po1.SCL_MRN__c;
        
    	Database.UpsertResult sr1 = Database.upsert(po1,sclExternalID,false);        
        System.debug('sr1.isCreated():'+sr1.isCreated()+' ;sr1.isSuccess():'+sr1.isSuccess());
        System.assertEquals(sr1.isCreated(), true); 
                
        SCL_PlannedOutreach__c po2 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_MRN__c='X111111111' AND SCL_CampaignNumber__c='C00017'];
        System.debug('po2 Id: ' + po2.Id + ' ;po2.SCL_PersonAccount__c: ' + po2.SCL_PersonAccount__c);                        
        
        // Create an Account
        Account acc1 = new Account();
        acc1.FirstName = 'POTest1A';
        acc1.LastName = 'POTest1A';
        acc1.SCL_MRNPersonAccount__c = 'X11111111A';
        acc1.Phone = '949-890-0987';
        acc1.RecordTypeID = '0124x000000UaEiAAK';
        insert acc1;
        
        // Create Planned Outreach using the account that was previously created
        SCL_PlannedOutreach__c po1a = new SCL_PlannedOutreach__c();
        po1a.SCL_FirstName__c = 'POTest1A';
        po1a.SCL_LastName__c = 'POTest1A';
        po1a.SCL_MRN__c = 'X11111111A';
        po1a.SCL_Phone__c = '949-890-0987';
        po1a.SCL_CampaignNumber__c = 'C00017';
        po1a.SCL_CampaignName__c = 'E-Visit Patients';
        po1a.SCL_ExternalID__c =  po1a.SCL_CampaignNumber__c + po1a.SCL_FirstName__c + po1a.SCL_MRN__c;
        
        Database.UpsertResult sr1a = Database.upsert(po1a,sclExternalID,false);        
        System.debug('sr1.isCreated():'+sr1a.isCreated()+' ;sr1.isSuccess():'+sr1a.isSuccess());
        System.assertEquals(sr1a.isSuccess(), true); 
        
        SCL_PlannedOutreach__c po2a = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_MRN__c='X11111111A' AND SCL_CampaignNumber__c='C00017'];
        System.debug('po2a Id: ' + po2a.Id + ' ;po2a.SCL_PersonAccount__c: ' + po2a.SCL_PersonAccount__c);        
        System.assertNotEquals(po2a.SCL_PersonAccount__c, null); 
        System.assertNotEquals(po2a.SCL_ContactSFID__c, null); 
        
        // Create an Account using an email as Id        
        Account acc2 = new Account();
        acc2.FirstName = 'POTest2';
        acc2.LastName = 'POTest2';
        acc2.PersonEmail = 'POTest2.POTest2@test.com';
        acc2.RecordTypeID = '0124x000000UaEiAAK';
        insert acc2;
              
        // Create Planned Outreach
        SCL_PlannedOutreach__c po2b = new SCL_PlannedOutreach__c();
        po2b.SCL_FirstName__c = 'POTest2';
        po2b.SCL_LastName__c = 'POTest2';
        po2b.SCL_Email__c = 'POTest2.POTest2@test.com';
        po2b.SCL_Phone__c = '949-890-0987';
        po2b.SCL_CampaignNumber__c = 'C00017';
        po2b.SCL_CampaignName__c = 'E-Visit Patients';        
        po2b.SCL_ExternalID__c =  po2b.SCL_CampaignNumber__c + po2b.SCL_FirstName__c + po2b.SCL_Email__c;        
        
        Database.UpsertResult sr2b = Database.upsert(po2b,sclExternalID,false);                
        System.debug('sr2.isCreated():'+sr2b.isCreated()+' ;sr2.isSuccess():'+sr2b.isSuccess());
        System.assertEquals(sr2b.isSuccess(), true); 
        SCL_PlannedOutreach__c po2b1 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_Email__c='POTest2.POTest2@test.com' AND SCL_CampaignNumber__c='C00017'];
        System.debug('po2b1 Id: ' + po2b1.Id + ' ;po2b1.SCL_PersonAccount__c: ' + po2b1.SCL_PersonAccount__c);                      
        System.assertNotEquals(po2b1.SCL_PersonAccount__c, null); 
        System.assertNotEquals(po2b1.SCL_ContactSFID__c, null); 
               
        // Create third Planned Outreach
        SCL_PlannedOutreach__c po3 = new SCL_PlannedOutreach__c();
        po3.SCL_FirstName__c = 'POTest3';
        po3.SCL_LastName__c = 'POTest3';
        po3.SCL_Email__c = 'POTest2.POTest2@test.com';
        po3.SCL_Phone__c = '949-890-0987';
        po3.SCL_CampaignNumber__c = 'C00001';
        po3.SCL_CampaignName__c = 'Good Samaritan Medical Center';
        po3.SCL_ExternalID__c =  po3.SCL_CampaignNumber__c + po3.SCL_FirstName__c + po3.SCL_Email__c;        
        
        Database.UpsertResult sr3 = Database.upsert(po3,sclExternalID,false);                        
        System.debug('sr3.isCreated():'+sr3.isCreated()+' ;sr3.isSuccess():'+sr3.isSuccess());
        System.assertEquals(sr3.isSuccess(), true); 
		        
        SCL_PlannedOutreach__c po4 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_Email__c='POTest2.POTest2@test.com' AND SCL_CampaignNumber__c='C00001'];
        System.debug('po4 Id: ' + po4.Id + ' ;po4.SCL_PersonAccount__c: ' + po4.SCL_PersonAccount__c);        
        //System.assertNotEquals(po4.SCL_PersonAccount__c, null); 
        //System.assertNotEquals(po4.SCL_ContactSFID__c, null);             	
        
        // Test for email as Id
        // Create first Planned Outreach
        SCL_PlannedOutreach__c po5 = new SCL_PlannedOutreach__c();
        po5.SCL_FirstName__c = 'POTest5';
        po5.SCL_LastName__c = 'POTest5';
        po5.SCL_Email__c = 'POTest5.POTest5@test.com';
        po5.SCL_CampaignNumber__c = 'C00017';
        po5.SCL_CampaignName__c = 'E-Visit Patients';        
        po5.SCL_ExternalID__c =  po5.SCL_CampaignNumber__c + po5.SCL_FirstName__c + po5.SCL_Email__c;        
        
        Database.UpsertResult sr4 = Database.upsert(po5,sclExternalID,false);                            	
        System.debug('sr4.isCreated():'+sr4.isCreated()+' ;sr4.isSuccess():'+sr4.isSuccess());
        System.assertEquals(sr4.isCreated(), true); 
        
        SCL_PlannedOutreach__c po6 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_Email__c = 'POTest5.POTest5@test.com' AND SCL_CampaignNumber__c='C00017'];
        System.debug('po6 Id: ' + po6.Id + ' ;po6.SCL_PersonAccount__c: ' + po6.SCL_PersonAccount__c);
        
        //System.assertNotEquals(po6.SCL_PersonAccount__c, null); 
        //System.assertNotEquals(po6.SCL_ContactSFID__c, null); 
        
        // Create second Planned Outreach: Insert the the previous PO record to test the duplicate
        SCL_PlannedOutreach__c po7 = new SCL_PlannedOutreach__c();
        po7.SCL_FirstName__c = 'POTest5';
        po7.SCL_LastName__c = 'POTest5';
        po7.SCL_Email__c = 'POTest5.POTest5@test.com';
        po7.SCL_CampaignNumber__c = 'C00017';
        po7.SCL_CampaignName__c = 'E-Visit Patients';
        po7.SCL_ExternalID__c =  po7.SCL_CampaignNumber__c + po7.SCL_FirstName__c + po7.SCL_Email__c;        
        
        Database.UpsertResult sr5 = Database.upsert(po7,sclExternalID,false);                            	
        System.debug('sr5.isCreated():'+sr5.isCreated()+' ;sr5.isSuccess():'+sr5.isSuccess());
        System.assertEquals(sr5.isSuccess(), true); 
               
        // Create third Planned Outreach
        SCL_PlannedOutreach__c po8 = new SCL_PlannedOutreach__c();
        po8.SCL_FirstName__c = 'POTest5';
        po8.SCL_LastName__c = 'POTest5';
        po8.SCL_Email__c = 'POTest5.POTest5@test.com';
        po8.SCL_CampaignNumber__c = 'C00001';
        po8.SCL_CampaignName__c = 'Good Samaritan Medical Center';
        po8.SCL_ExternalID__c =  po8.SCL_CampaignNumber__c + po8.SCL_FirstName__c + po8.SCL_Email__c;        
        
        Database.UpsertResult sr6 = Database.upsert(po8,sclExternalID,false);                            	
        
        System.debug('sr6.isCreated():'+sr6.isCreated()+' ;sr6.isSuccess():'+sr6.isSuccess());
        System.assertEquals(sr6.isCreated(), true); 
                
        SCL_PlannedOutreach__c po9 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c FROM SCL_PlannedOutreach__c WHERE SCL_Email__c = 'POTest5.POTest5@test.com' AND SCL_CampaignNumber__c='C00001'];
        System.debug('po9 Id: ' + po9.Id + ' ;po9.SCL_PersonAccount__c: ' + po9.SCL_PersonAccount__c);        
        //System.assertNotEquals(po9.SCL_PersonAccount__c, null); 
        //System.assertNotEquals(po9.SCL_ContactSFID__c, null);             	
        
        // Create Planned Outreach for Anti-Coag campaign
        SCL_PlannedOutreach__c po10 = new SCL_PlannedOutreach__c();
        po10.SCL_FirstName__c = 'POTest6';
        po10.SCL_LastName__c = 'POTest6';
        po10.SCL_Email__c = 'POTest6.POTest6@test.com';
        po10.SCL_CampaignNumber__c = 'C00032';
        po10.SCL_CampaignName__c = 'Inpatient Anti-Coag';
        po10.SCL_Source__c = 'Epic Data Feed';
               
        insert po10;
        //Database.UpsertResult sr7 = Database.upsert(po10,sclExternalID,false);                            	        
        //System.debug('sr7.isCreated():'+sr7.isCreated()+' ;sr7.isSuccess():'+sr7.isSuccess());
        //System.assertEquals(sr7.isCreated(), true); 
        
        SCL_PlannedOutreach__c po11 = [SELECT Id,SCL_PersonAccount__c,SCL_ContactSFID__c,SCL_CampaignName__c,SCL_CampaignNumber__c FROM SCL_PlannedOutreach__c WHERE SCL_Email__c = 'POTest6.POTest6@test.com' AND SCL_CampaignNumber__c='C00032'];
        System.debug('po11 Id: ' + po11.Id + ' ;po11.SCL_CampaignNumber__c: ' + po11.SCL_CampaignNumber__c);
                
        // Test if Case has been created for Anti-Coag campaign
        //Case case1 = [SELECT Id,AccountId,ContactId FROM Case WHERE AccountId = :po11.SCL_PersonAccount__c AND SCL_FormCampaignName__c= :po11.SCL_CampaignName__c];
        //System.assertNotEquals(case1.Id, null); 
        */
    }
}