@IsTest(SeeAllData=true)
public class SCL_TA_Account_Test {    
    @IsTest
    private static void beforeUpdate_test() {
      List<Account> newList = new List<Account>();
      List<Account> oldList = new List<Account>();
        
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', SCL_MRNPersonAccount__c='X111111111', PersonEmail='test1.test1@test.com', SCL_Deceased__pc=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId,PersonOtherPhone='9999999999',
                               	PersonMobilePhone='19999999999X999',PersonHomePhone='99999999',Phone='x')); 
      newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));              
      newList.add(new Account(FirstName = 'Test3', LastName = 'Test3', SCL_MRNPersonAccount__c='X333333333',PersonEmail='test3.test3@test.com',PersonHasOptedOutOfEmail=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));      
      newList.add(new Account(FirstName = 'TestCP1', LastName = 'TestCP1', SCL_MRNPersonAccount__c='X100000001',PersonEmail='TestCP1.TestCP1@test.com',PersonHasOptedOutOfEmail=true,SCL_CPB2B__pc=false,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));              
      newList.add(new Account(FirstName = 'TestCP2', LastName = 'TestCP2', SCL_MRNPersonAccount__c='X200000002',PersonEmail='TestCP2.TestCP2@test.com',PersonHasOptedOutOfEmail=false,SCL_CPB2B__pc=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                      
      insert newList;        
      oldList = newList;  
              
      Test.startTest();
      new SCL_TA_Account_BU_GetPersonEmails.Service().beforeUpdate(newList, oldList);
      new SCL_TA_Account_BU_RemoveCommunication().beforeUpdate(newList, oldList);              
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void afterUpdate1_test() {   
      // Add Case For Covid Vaccination Sign-up
      List<Case> caseList = new List<Case>();
      caseList.add(new Case(SCL_FormFirstName__c = 'Test3',SCL_FormLastName__c = 'Test3',SCL_FormEmail__c='test3.test3@test.com',Status='1st Outreach Attempt',SCL_FormCampaignName__c='COVID Vaccine Signup',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));      
      insert caseList;

      List<Account> oldList = new List<Account>();
      List<Account> newList = new List<Account>();              
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', SCL_MRNPersonAccount__c='X111111111', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                              
	  newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));              
	  newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));                                                  
	  newList.add(new Account(FirstName = 'TestCP1', LastName = 'TestCP1', SCL_MRNPersonAccount__c='X100000001',PersonEmail='TestCP1.TestCP1@test.com',SCL_CPB2B__pc=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));              
	  newList.add(new Account(FirstName = 'TestCP2', LastName = 'TestCP2', SCL_MRNPersonAccount__c='X200000002',PersonEmail='TestCP2.TestCP2@test.com',SCL_CPB2B__pc=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                              
      // Add Account For Covid Vaccination 
      newList.add(new Account(FirstName = 'Test3', LastName = 'Test3', SCL_MRNPersonAccount__c='X333333333', PersonEmail='test3.test3@test.com',SCL_COVIDVaccine1Status__c='Given',SCL_COVIDVaccine2Status__c='Given',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                  

      MetadataTriggerHandler.bypass('SCL_TA_Account_AI_MergeProspectAccount'); 
      MetadataTriggerHandler.bypass('SCL_TA_Account_AI_MergePatientAccount');               
	  insert newList;      
      
      MetadataTriggerHandler.clearBypass('SCL_TA_Account_AI_MergeProspectAccount'); 
      MetadataTriggerHandler.clearBypass('SCL_TA_Account_AI_MergePatientAccount');               
      Set<String> patientEmailSet = new Set<String>{'test1@test.com','test1.test1@test.com','test3.test3@test.com'};       
      oldList = [SELECT Id,IsPersonAccount,FirstName,LastName,MiddleName,SCL_MRNPersonAccount__c,PersonEmail,SCL_Deceased__pc,PersonHasOptedOutOfEmail,SCL_PersonIdKey__c,SCL_COVIDVaccine1Status__c,SCL_COVIDVaccine2Status__c,CreatedDate FROM Account WHERE PersonEmail IN :patientEmailSet AND IsPersonAccount = true];      
      newList = new List<Account>();          
      for (Account acc : oldList) {
      	  Account acc1 = acc.clone(true);     
          if (acc.PersonEmail.startsWith('test1@') || acc.PersonEmail.startsWith('test2@') || acc.PersonEmail.startsWith('test3@')) acc1.PersonEmail = acc.FirstName+'.'+acc.PersonEmail;
          newList.add(acc1);           
      }
          
      Test.startTest();   
      new SCL_TA_Account_BU_GetPersonEmails.Service().beforeUpdate(newList, oldList);
      new SCL_TA_Account_BU_RemoveCommunication().beforeUpdate(newList, oldList);                
      new SCL_TA_Account_AU_MergeProspectAccount().afterUpdate(newList, oldList);        
      new SCL_TA_Account_AU_MergePatientAccount().afterUpdate(newList, oldList);          
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
    
    @IsTest
    private static void afterUpdate2_test() {       
      List<Account> oldList = new List<Account>();
      List<Account> newList = new List<Account>();        
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', SCL_MRNPersonAccount__c='X111111111', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                              
	  newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));              
	  newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));                                            
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));                                              
	  newList.add(new Account(FirstName = 'TestCP1', LastName = 'TestCP1', SCL_MRNPersonAccount__c='X100000001',PersonEmail='TestCP1.TestCP1@test.com',PersonHasOptedOutOfEmail=true,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));              
	  newList.add(new Account(FirstName = 'TestCP2', LastName = 'TestCP2', SCL_MRNPersonAccount__c='X200000002',PersonEmail='TestCP2.TestCP2@test.com',PersonHasOptedOutOfEmail=false,RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                              
      MetadataTriggerHandler.bypass('SCL_TA_Account_AI_MergeProspectAccount'); 
      MetadataTriggerHandler.bypass('SCL_TA_Account_AI_MergePatientAccount');               
	    insert newList;      
      
      MetadataTriggerHandler.clearBypass('SCL_TA_Account_AI_MergeProspectAccount'); 
      MetadataTriggerHandler.clearBypass('SCL_TA_Account_AI_MergePatientAccount');               
      Set<String> patientEmailSet = new Set<String>{'test1@test.com','test1.test1@test.com'};       
      oldList = [SELECT Id,IsPersonAccount,FirstName,LastName,MiddleName,SCL_MRNPersonAccount__c,PersonEmail,SCL_Deceased__pc,PersonHasOptedOutOfEmail,SCL_PersonIdKey__c,CreatedDate FROM Account WHERE PersonEmail IN :patientEmailSet AND IsPersonAccount = true];      
      newList = new List<Account>();          
      for (Account acc : oldList) {
      	  Account acc1 = acc.clone(true);     
          if (acc.PersonEmail.startsWith('test1@') || acc.PersonEmail.startsWith('test2@')) acc1.PersonEmail = acc.FirstName+'.'+acc.PersonEmail;                 
          newList.add(acc1);           
      }
            
      Test.startTest();   
      new SCL_TA_Account_BU_GetPersonEmails.Service().beforeUpdate(newList, oldList);
      new SCL_TA_Account_BU_RemoveCommunication().beforeUpdate(newList, oldList);                
      new SCL_TA_Account_AU_MergeProspectAccount().afterUpdate(newList, oldList);        
      new SCL_TA_Account_AU_MergePatientAccount().afterUpdate(newList, oldList);          
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
    	   
    @IsTest
    private static void beforeInsert_test() {
      List<Account> newList = new List<Account>();
      List<Account> oldList = new List<Account>();
        
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', SCL_MRNPersonAccount__c='X111111111', PersonEmail='test1.test1@test.com',
                              SCL_Deceased__pc=true, RecordTypeId=SCL_GatewayUtils.patientRecordTypeId,PersonOtherPhone='9999999999',
                              PersonMobilePhone='19999999999X999',PersonHomePhone='99999999',Phone='x'));    
      newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));      
	  insert newList;      
      oldList = newList;  
      Test.startTest();
        
      new SCL_TA_Account_BI_GetPersonEmails.Service().beforeInsert(newList);
      new SCL_TA_Account_BI_RemoveCommunication().beforeInsert(newList);                    
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
    }
    
    @IsTest
    private static void afterInsert_test() {      
      List<Account> newList = new List<Account>();
      List<Account> oldList = new List<Account>();
        
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', SCL_MRNPersonAccount__c='X111111111', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));      
	  newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));              
      newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));
	  newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',SCL_Deceased__pc=true, RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));                  
	  insert newList;      
      
      // Add Case For Covid Vaccination Sign-up
      List<Case> caseList = new List<Case>();
      caseList.add(new Case(SCL_FormFirstName__c = 'Test3',SCL_FormLastName__c = 'Test3',SCL_FormEmail__c='test3.test3@test.com',Status='1st Outreach Attempt',SCL_FormCampaignName__c='COVID Vaccine Signup',RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId));      
      insert caseList;

      Test.startTest(); 
      newList = new List<Account>();      
      newList.add(new Account(FirstName = 'Test1', LastName = 'Test1', PersonEmail='test1.test1@test.com', SCL_Deceased__pc=true,RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));      
      newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));              
      newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', SCL_MRNPersonAccount__c='X222222222', PersonEmail='test1.test1@test.com',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));            
	  newList.add(new Account(FirstName = 'Test2', LastName = 'Test2', PersonEmail='test2.test2@test.com',RecordTypeId=SCL_GatewayUtils.prospectRecordTypeId));      	        
      // Add Account For Covid Vaccination 
      newList.add(new Account(FirstName = 'Test3', LastName = 'Test3', SCL_MRNPersonAccount__c='X333333333', PersonEmail='test3.test3@test.com',SCL_COVIDVaccine1Status__c='Given',SCL_COVIDVaccine2Status__c='Given',RecordTypeId=SCL_GatewayUtils.patientRecordTypeId));                  
      
      new SCL_TA_Account_AI_MergeProspectAccount().afterInsert(newList);
      new SCL_TA_Account_AI_MergePatientAccount().afterInsert(newList);  

      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
    }	
}