@IsTest(SeeAllData=true)
public class SCL_TA_PO_Test {
    @IsTest
    private static void beforeUpdate_test() {
      List<SCL_PlannedOutreach__c> newList = new List<SCL_PlannedOutreach__c>();
      List<SCL_PlannedOutreach__c> oldList = new List<SCL_PlannedOutreach__c>();
        
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test1', SCL_LastName__c='Test1', SCL_MRN__c='X00000001', SCL_Email__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed',IMH_ApptDeptPhone__c='9999999999',SCL_Phone__c='19999999999X999'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test2', SCL_LastName__c='Test2', SCL_Email__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed',IMH_ApptDeptPhone__c='99999999',SCL_Phone__c='999999999X999'));
	  insert newList;
      oldList = newList;  
              
      Test.startTest();
      new SCL_TA_PO_BU_AccountQueries.Service().beforeUpdate(newList, oldList);
      new SCL_TA_PO_BU_MatchAccount().beforeUpdate(newList, oldList);        
      new SCL_TA_PO_BU_UpdateWithCase.Service().beforeUpdate(newList, oldList);        
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void afterUpdate_test() {
      List<SCL_PlannedOutreach__c> newList = new List<SCL_PlannedOutreach__c>();
      List<SCL_PlannedOutreach__c> oldList = new List<SCL_PlannedOutreach__c>();
        
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test1', SCL_LastName__c='Test1', SCL_MRN__c='X00000001', SCL_Email__c='test1.test1@test.com', SCL_Source__c='Epic Data Feed'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test2', SCL_LastName__c='Test2', SCL_Email__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed'));
	  insert newList;
      oldList = newList;  
              
      Test.startTest();
      new SCL_TA_PO_BU_AccountQueries.Service().beforeUpdate(newList, oldList);
      new SCL_TA_PO_BU_MatchAccount().beforeUpdate(newList, oldList);        
      new SCL_TA_PO_BU_UpdateWithCase.Service().beforeUpdate(newList, oldList);        
      new SCL_TA_PO_AU_CreateCase().afterUpdate(newList, oldList);        
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void beforeInsert_test() {
      List<SCL_PlannedOutreach__c> newList = new List<SCL_PlannedOutreach__c>();
      List<Account> newAccountList = new List<Account>();
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test3', SCL_LastName__c='Test3', SCL_MRN__c='X00000003', SCL_Email__c='test3.test3@test.com', SCL_Source__c='Epic Data Feed',IMH_ApptDeptPhone__c='9999999999',SCL_Phone__c='19999999999X999'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test4', SCL_LastName__c='Test4', SCL_MRN__c='X00000004', SCL_Email__c='test4.test4@test.com', SCL_Source__c='Data Feed',IMH_ApptDeptPhone__c='99999999',SCL_Phone__c='999999999X999'));              
	  
      // Insert Accounts  
      newAccountList.add(new Account(FirstName='Test5', LastName='Test5', PersonEmail='test5.test5@test.com'));
      newAccountList.add(new Account(FirstName='Test6', LastName='Test6', SCL_MRNPersonAccount__c='X00000006'));
      insert newAccountList;
        
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test5', SCL_LastName__c='Test5', SCL_Email__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test6', SCL_LastName__c='Test6', SCL_MRN__c='X00000006', SCL_Email__c='test6.test6@test.com', SCL_Source__c='Data Feed'));              
	  for (Integer i = 0; i < 150; i++) {
          String j = String.valueOf(i).leftPad(4, '0');          
          newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test'+j, SCL_LastName__c='Test'+j, SCL_MRN__c='X11111'+j, SCL_Email__c='test'+j+'.test'+j+'@test.com', SCL_Source__c='Data Feed'));              
      }	        
        
      Test.startTest();
      new SCL_TA_PO_BI_AccountQueries.Service().beforeInsert(newList);
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test3', SCL_LastName__c='Test3', SCL_MRN__c='X00000003', SCL_Email__c='test3.test3@test.com', SCL_Source__c='Epic Data Feed'));        
      new SCL_TA_PO_BI_MatchAccount().beforeInsert(newList);
	  new SCL_TA_PO_BI_UpdateWithCase.Service().beforeInsert(newList);        
      List<Case> cases = [SELECT Id, SCL_MRN__c FROM Case WHERE SCL_CampaignNumber__c='C00032'];      
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
    }
    
    @IsTest
    private static void afterInsert_test() {
      List<SCL_PlannedOutreach__c> newList = new List<SCL_PlannedOutreach__c>();
      List<Account> newAccountList = new List<Account>();
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test3', SCL_LastName__c='Test3', SCL_MRN__c='X00000003', SCL_Email__c='test3.test3@test.com', SCL_Source__c='Epic Data Feed'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test4', SCL_LastName__c='Test4', SCL_MRN__c='X00000004', SCL_Email__c='test4.test4@test.com', SCL_Source__c='Data Feed'));              
	  newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test5', SCL_LastName__c='Test5', SCL_Email__c='test5.test5@test.com', SCL_Source__c='Epic Data Feed'));      
      newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test6', SCL_LastName__c='Test6', SCL_MRN__c='X00000006', SCL_Email__c='test6.test6@test.com', SCL_Source__c='Data Feed'));              
      for (Integer i = 0; i < 150; i++) {
          String j = String.valueOf(i).leftPad(4, '0');          
          newList.add(new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test'+j, SCL_LastName__c='Test'+j, SCL_MRN__c='X11111'+j, SCL_Email__c='test'+j+'.test'+j+'@test.com', SCL_Source__c='Data Feed'));              
      }  
      // Insert Accounts  
      newAccountList.add(new Account(FirstName='Test5', LastName='Test5', PersonEmail='test5.test5@test.com'));
      newAccountList.add(new Account(FirstName='Test6', LastName='Test6', SCL_MRNPersonAccount__c='X00000006'));
      insert newAccountList;
              
      Test.startTest();	  
      new SCL_TA_PO_BI_AccountQueries.Service().beforeInsert(newList);
      new SCL_TA_PO_BI_MatchAccount().beforeInsert(newList);
      // add this to get 1 error.  
      newList[0].addError('Test Error: Skip this record');
	  new SCL_TA_PO_BI_UpdateWithCase.Service().beforeInsert(newList);  
      new SCL_TA_PO_AI_CheckMissingRecord().afterInsert(newList);
      new SCL_TA_PO_AI_CreateCase().afterInsert(newList);  
      Test.stopTest();      
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(true, newList[0].hasErrors());
      System.assertEquals(1, newList[0].getErrors().size());        
    }
}