@IsTest(SeeAllData=true)
public class SCL_TA_EE_Test {        
    @IsTest
    private static void afterInsert1_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();            
      Exception e = new SCLTriggerException('Test Exception'); 
      ee.SCL_TriggerOperation__c = 'insert';
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      ee.SCL_Exception__c = exceptionDetail;  
      ee.SCL_ObjectName__c = 'Account';      
      Account acc = new Account(FirstName='Test5', LastName='Test5', PersonEmail='test5.test5@test.com');
      ee.SCL_Object__c = JSON.serialize(acc);  
      newList.add(ee);   
      Test.startTest();	        
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();       
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());      
    }
    
    @IsTest
    private static void afterInsert2_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();   
      Exception e = new SCLTriggerException('Test Exception'); 
      ee.SCL_TriggerOperation__c = 'insert';
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      ee.SCL_Exception__c = exceptionDetail;        
      ee.SCL_ObjectName__c = 'Case';      
      Case case1 = new Case(SCL_FormCampaignName__c = 'New Lutheran Newsletter', SCL_FormFirstName__c='AITest2', SCL_FormLastName__c='Test2', SCL_FormEmail__c='test2.test2@test.com', SCL_Source__c='Epic Data Feed', RecordTypeId=SCL_GatewayUtils.sclMarketingRecordTypeId);      
      ee.SCL_Object__c = JSON.serialize(case1);  
      newList.add(ee);   
      Test.startTest();	
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();      
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());
    }
    
    @IsTest
    private static void afterInsert3_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();      
      Exception e = new SCLTriggerException('Test Exception'); 
      ee.SCL_TriggerOperation__c = 'insert';
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      ee.SCL_Exception__c = exceptionDetail;  
      ee = new SCL_ExceptionEvent__e();               
      ee.SCL_ObjectName__c = 'SCL_PlannedOutreach__c';      
      SCL_PlannedOutreach__c po = new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test3', SCL_LastName__c='Test3', SCL_MRN__c='X00000003', SCL_Email__c='test3.test3@test.com', SCL_Source__c='Epic Data Feed');      
      ee.SCL_Object__c = JSON.serialize(po);  
      newList.add(ee);        
      Test.startTest();
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();    
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());      
    }
    
    @IsTest
    private static void afterInsert4_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();      
      Exception e = new SCLTriggerException('Test Exception'); 
      ee.SCL_TriggerOperation__c = 'insert';
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      ee.SCL_Exception__c = exceptionDetail;  
      ee = new SCL_ExceptionEvent__e();               
      ee.SCL_ObjectName__c = 'SCL_PlannedOutreach__c';      
      SCL_PlannedOutreach__c po1 = new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00032', SCL_CampaignName__c = 'Inpatient Anti-Coag', SCL_FirstName__c='Test4', SCL_LastName__c='Test4', SCL_MRN__c='X00000004', SCL_Email__c='test4.test4@test.com', SCL_Source__c='Epic Data Feed');      
      po1.addError('Unknown Error');
      ee.SCL_Object__c = JSON.serialize(po1);        
      newList.add(ee);      
      Test.startTest();
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();    
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());      
    }
    
    @IsTest
    private static void afterInsert5_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();        
      Exception e = new SCLTriggerException('Test Exception'); 
      ee.SCL_TriggerOperation__c = 'insert';
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      ee.SCL_Exception__c = exceptionDetail;  
      ee.SCL_ObjectName__c = 'SCL_Appointment__c';      
      SCL_Appointment__c appt = new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test2', SCL_ApptLastName__c = 'Test2', SCL_AppointmentId__c = '2222222222', SCL_MRN__c='X222222222', SCL_PersonEmail__c='test2.test2@test.com');        
      ee.SCL_Object__c = JSON.serialize(appt);    
      newList.add(ee);   
      Test.startTest();	        
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();       
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());      
    }   
    @IsTest
    private static void afterInsert6_test() {
      List<SCL_ExceptionEvent__e> newList = new List<SCL_ExceptionEvent__e>(); 
      SCL_ExceptionEvent__e ee = new SCL_ExceptionEvent__e();      
      Exception e = new SCLTriggerException('Test Exception');       
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();                
      ee = new SCL_ExceptionEvent__e();               
      ee.SCL_ObjectName__c = 'SCL_PlannedOutreach__c';                  
      for (Integer i = 0; i < 150; i++) {
          ee = new SCL_ExceptionEvent__e();  
          ee.SCL_Exception__c = exceptionDetail;  
          ee.SCL_TriggerOperation__c = 'insert';
          String j = String.valueOf(i).leftPad(4, '0');          
          SCL_PlannedOutreach__c po = new SCL_PlannedOutreach__c(SCL_CampaignNumber__c = 'C00067', SCL_CampaignName__c = 'LMCEvents', SCL_FirstName__c='Test'+j, SCL_LastName__c='Test'+j, SCL_MRN__c='X11111'+j, SCL_Email__c='test'+j+'.test'+j+'@test.com', SCL_Source__c='Data Feed');              
          ee.SCL_Object__c = JSON.serialize(po);  
          newList.add(ee);  
      }            
      Test.startTest();
      Database.SaveResult sr = EventBus.publish(ee);
      new SCL_TA_EE_AI_ProcessEvents().afterInsert(newList);      
      Test.stopTest();    
      // Verify SaveResult value
      System.assertEquals(true, sr.isSuccess());      
    }
    
}