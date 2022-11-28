@IsTest(SeeAllData=true)
public class SCL_TA_Case_Test {
    @IsTest
    private static void beforeUpdate_test() {
        List<Case> newList = new List<Case>();
        List<Case> oldList = new List<Case>();
        
        // Insert Accounts  
        List<Account> newAccountList = new List<Account>();
        
        newAccountList.add(new Account(FirstName='BUTest1', LastName='Test1', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));
        newAccountList.add(new Account(FirstName='BUTest5', LastName='Test5', PersonEmail='test5.test5@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));
        newAccountList.add(new Account(FirstName='BUTest6', LastName='Test6', PersonEmail='test6.test6@test.com', SCL_MRNPersonAccount__c='X00000006',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));
        insert newAccountList; 
        
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BUTest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId, SCL_FormInsurerPhone__c='9999999999', SCL_OtherPhone__c='x'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));      
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='BUTest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId, SCL_FormSubmitterPhone__c='19999999999X999', SCL_FormPhone__c='99999999'));        
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='BUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));                    
        newList.add(new Case(SCL_FormCampaignName__c = 'COVID Vaccine Signup', SCL_FormFirstName__c='BUTest3', SCL_FormLastName__c='Test3', SCL_FormEmail__c='test3.test3@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));                      
        newList.add(new Case(SCL_FormCampaignName__c = 'LMCEvents', SCL_FormFirstName__c='BUTest4', SCL_FormLastName__c='Test4', SCL_FormEmail__c='test4.test4@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));              
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BUTest5', SCL_FormLastName__c='Test5', SCL_FormEmail__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));        
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BUTest6', SCL_FormLastName__c='Test6', SCL_FormEmail__c='test6.test6@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                	  	        
        newList.add(new Case(SCL_FormCampaignName__c = 'COVID Vaccine Signup', SCL_FormFirstName__c='BUTest3', SCL_FormLastName__c='Test3', SCL_FormEmail__c='test3.test3@test.com', Status='2nd Outreach Attempt', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                              
        newList.add(new Case(SCL_FormCampaignName__c = 'COVID Vaccine Signup', SCL_FormFirstName__c='BUTest4', SCL_FormLastName__c='Test4', SCL_FormEmail__c='test4.test4@test.com', Status='Closed Scheduled', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                                              
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='Duplicate', SCL_FormLastName__c='Test',SCL_FormPhone__c='2222222222', Status='1st Outreach Attemp',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                                        
        oldList.add(new Case(SCL_FormCampaignName__c = 'COVID Vaccine Signup', SCL_FormFirstName__c='BUTest3', SCL_FormLastName__c='Test3', SCL_FormEmail__c='test3.test3@test.com', Status='1st Outreach Attempt', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                              
        oldList.add(new Case(SCL_FormCampaignName__c = 'COVID Vaccine Signup', SCL_FormFirstName__c='BUTest4', SCL_FormLastName__c='Test4', SCL_FormEmail__c='test4.test4@test.com', Status='2nd Outreach Attempt', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));
        oldList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='Duplicate', SCL_FormLastName__c='Test',SCL_FormPhone__c='2222222222', Status='2nd Outreach Attempt',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                                        
        
        insert oldList;
        Set<String> patientKeys = new Set<String>{'test1.test1@test.com','test2.test2@test.com','test3.test3@test.com','test4.test4@test.com','test5.test5@test.com','test6.test6@test.com'};            
            oldList = [SELECT Id,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormEmail__c,SCL_FormCampaignName__c,SCL_FormPhone__c,SCL_1stOutreachAttempted__c,SCL_OutboundCalls__c,Status,RecordTypeId FROM Case WHERE SCL_FormEmail__c IN :patientKeys];	        
        
        Test.startTest();      
        List<Account> accts = [SELECT Id,PersonContactId,SCL_PersonIdKey__c FROM Account WHERE isPersonAccount=true AND PersonEmail IN :patientKeys];
        System.debug('accts:'+accts);        
        new SCL_TA_Case_BU_AccountQueries.Service().beforeUpdate(newList, oldList);
        new SCL_TA_Case_BU_MatchAccount().beforeUpdate(newList, oldList);        
        new SCL_TA_Case_BU_RouteCaseToTeam().beforeUpdate(newList, oldList);        
        new SCL_TA_Case_BU_TallyCovidVaccineSignup().beforeUpdate(newList, oldList);              
        new SCL_TA_Case_BU_UpdateWithPlannedOutreach.Service().beforeUpdate(newList, oldList); 
        new IMH_TA_Case_BU_CheckDuplicateRecord().beforeUpdate(newList,oldList);
        Test.stopTest();
        //Use getErrors() SObject method to get errors from addError without performing DML
        System.assertEquals(false, newList[0].hasErrors());
        System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void afterUpdate_test() {
        List<Case> newList = new List<Case>();
        List<Case> oldList = new List<Case>();
        
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AUTest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormInsurerPhone__c='9999999999', SCL_OtherPhone__c='x'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormSubmitterPhone__c='19999999999X999',SCL_FormPhone__c='99999999'));
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormSubmitterPhone__c='19999999999X999',SCL_FormPhone__c='99999999'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='AUTest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));        
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='AUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));              
        newList.add(new Case(SCL_FormFirstName__c='AUTest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_ClosedReason__c='Patient Inappropriate', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));                      
        insert newList;
        oldList = newList;        
        Test.startTest();        
        new SCL_TA_Case_BU_AccountQueries.Service().beforeUpdate(newList, oldList);
        new SCL_TA_Case_BU_MatchAccount().beforeUpdate(newList, oldList);        
        new SCL_TA_Case_BU_RouteCaseToTeam().beforeUpdate(newList, oldList);        
        new SCL_TA_Case_BU_UpdateWithPlannedOutreach.Service().beforeUpdate(newList, oldList);        	 	 
        Set<String> patientEmailSet = new Set<String>{'test1.test1@test.com','test2.test2@test.com'}; 
            newList = [SELECT Id,AccountId,SCL_FormFirstName__c,SCL_FormLastName__c,SCL_FormEmail__c,SCL_FormCampaignName__c,SCL_CampaignNumber__c,SCL_ClosedReason__c,SCL_PersonIdKey__c,RecordTypeId,CreatedDate FROM Case WHERE SCL_FormEmail__c IN :patientEmailSet];        
        oldList = newList;
        new SCL_TA_Case_AU_WPCaseClose().afterUpdate(newList, oldList);
        new SCL_TA_Case_AU_CreatePlannedOutreach().afterUpdate(newList, oldList);  
        Test.stopTest();
        //Use getErrors() SObject method to get errors from addError without performing DML
        System.assertEquals(false, newList[0].hasErrors());
        System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void beforeInsert_test() {
        List<Case> newList = new List<Case>();
        List<Account> newAccountList = new List<Account>();
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='Duplicate', SCL_FormLastName__c='Test',SCL_FormPhone__c='2222222222', Status='2nd Outreach Attempt',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                                        
        insert newList;    
        newList = new List<Case>();
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormInsurerPhone__c='9999999999'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BITest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_OtherPhone__c='x'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='BITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormSubmitterPhone__c='19999999999X999',SCL_FormPhone__c='99999999'));        
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='BITest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));              
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='BITest5', SCL_FormLastName__c='Test5', SCL_FormEmail__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));              
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='BITest6', SCL_FormLastName__c='Test6', SCL_FormEmail__c='test6.test6@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));    
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='Duplicate', SCL_FormLastName__c='Test',SCL_FormPhone__c='2222222222', Status='2nd Outreach Attempt',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                                        
        
        // Insert Accounts  
        newAccountList.add(new Account(FirstName='BITest5', LastName='Test5', PersonEmail='test5.test5@test.com'));
        newAccountList.add(new Account(FirstName='BITest6', LastName='Test6', PersonEmail='test6.test6@test.com', SCL_MRNPersonAccount__c='X00000006'));
        insert newAccountList;              
        
        Test.startTest();
        new SCL_TA_Case_BI_CheckDuplicateRecord().beforeInsert(newList);  
        new SCL_TA_Case_BI_AccountQueries.Service().beforeInsert(newList);
        newList.add(new Case(SCL_FormCampaignName__c = 'LMCEvents', SCL_FormFirstName__c='BITest5', SCL_FormLastName__c='Test5', SCL_FormEmail__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));
        new SCL_TA_Case_BI_MatchAccount().beforeInsert(newList);
        new SCL_TA_Case_BI_RouteCaseToTeam().beforeInsert(newList);
        new SCL_TA_Case_BI_UpdateWithPlannedOutreach.Service().beforeInsert(newList);              
        Test.stopTest();
        //Use getErrors() SObject method to get errors from addError without performing DML
        System.debug('Errors:'+newList[0].getErrors());
        System.assertEquals(true, newList[0].hasErrors());
        System.assertEquals(1, newList[0].getErrors().size());        
    }
    
    @IsTest
    private static void afterInsert_test() {
        List<Case> newList = new List<Case>();
        List<Account> newAccountList = new List<Account>();
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));      
        insert newList;    
        newList = new List<Case>();
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='AITest6', SCL_FormLastName__c='Test6', SCL_FormEmail__c='test6.test6@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId,SCL_FormInsurerPhone__c='9999999999', SCL_OtherPhone__c='x'));                  
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId,SCL_FormSubmitterPhone__c='19999999999X999',SCL_FormPhone__c='99999999'));      
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AITest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));      
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='AITest1', SCL_FormLastName__c='Test1', SCL_MRN__c='X00000001', SCL_FormEmail__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));        
        newList.add(new Case(SCL_FormCampaignName__c = 'pill planner', SCL_FormFirstName__c='AITest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', Status='Pending Verification', RecordTypeId=SCL_GatewayUtils.wpBHRecordTypeId));              
        newList.add(new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AITest5', SCL_FormLastName__c='Test5', SCL_FormEmail__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));                    
        
        // Insert Accounts  
        newAccountList.add(new Account(FirstName='AITest5', LastName='Test5', PersonEmail='test5.test5@test.com'));
        newAccountList.add(new Account(FirstName='AITest6', LastName='Test6', PersonEmail='test6.test6@test.com', SCL_MRNPersonAccount__c='X00000006'));
        insert newAccountList;                    
        Test.startTest();
        new SCL_TA_Case_AI_WPCaseClose().afterInsert(newList);  
        new SCL_TA_Case_AI_CreatePlannedOutreach().afterInsert(newList);
        /*try{
insert newList;
}catch(Exception e){
SCL_GatewayUtils.publishException(newList,'insert',e);
}*/
        Test.stopTest();
        //Use getErrors() SObject method to get errors from addError without performing DML
        System.assertEquals(false, newList[0].hasErrors());
        System.assertEquals(0, newList[0].getErrors().size());        
    }
}