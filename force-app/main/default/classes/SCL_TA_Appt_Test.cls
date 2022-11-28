@IsTest(SeeAllData=true)
public class SCL_TA_Appt_Test {
    @IsTest
    private static void beforeUpdate_test() {
      List<SCL_Appointment__c> newList = new List<SCL_Appointment__c>();
      List<SCL_Appointment__c> oldList = new List<SCL_Appointment__c>();
      
      for (Integer i = 0; i < 200; i++) {
          String j = String.valueOf(i).leftPad(4, '0');
          newList.add(new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test'+j, SCL_ApptLastName__c = 'Test'+j, SCL_AppointmentId__c = '111111'+j, SCL_MRN__c='X11111'+j, SCL_PersonEmail__c='test'+j+'.test'+j+'@test.com'));                
      }        
      newList.add(new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test2', SCL_ApptLastName__c = 'Test2', SCL_AppointmentId__c = '2222222222', SCL_MRN__c='X222222222', SCL_PersonEmail__c='test2.test2@test.com'));        
      insert newList;    
      newList.add(new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test3', SCL_ApptLastName__c = 'Test3', SCL_AppointmentId__c = '2222222222', SCL_MRN__c='X333333333', SCL_PersonEmail__c='test3.test3@test.com'));      	        	  
      oldList = newList;  
              
      Test.startTest();
      new SCL_TA_Appt_BU_AccountQueries.Service().beforeUpdate(newList, oldList);
      new SCL_TA_Appt_BU_MatchAccount().beforeUpdate(newList, oldList);              
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());  
    }
            
    @IsTest
    private static void beforeInsert_test() {
      List<SCL_Appointment__c> newList = new List<SCL_Appointment__c>();
      List<SCL_Appointment__c> oldList = new List<SCL_Appointment__c>();
      List<Account> acctList = new List<Account>();  
      for (Integer i = 0; i < 200; i++) {
          String j = String.valueOf(i).leftPad(4, '0');
          acctList.add(new Account(FirstName = 'Test'+j, LastName = 'Test'+j, SCL_MRNPersonAccount__c='X11111'+j, PersonEmail='test'+j+'.test'+j+'@test.com'));                
      }
      insert acctList;   
      for (Integer i = 0; i < 200; i++) {
          String j = String.valueOf(i).leftPad(4, '0');
          newList.add(new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test'+j, SCL_ApptLastName__c = 'Test'+j, SCL_AppointmentId__c = '111111'+j, SCL_MRN__c='X11111'+j, SCL_PersonEmail__c='test'+j+'.test'+j+'@test.com'));                
      }      
      newList.add(new SCL_Appointment__c(SCL_ApptFirstName__c = 'Test2', SCL_ApptLastName__c = 'Test2', SCL_AppointmentId__c = '2222222222', SCL_MRN__c='X222222222', SCL_PersonEmail__c='test2.test2@test.com'));      
	  insert newList;
        
      Test.startTest();        
      new SCL_TA_Appt_BI_AccountQueries.Service().beforeInsert(newList);
      new SCL_TA_Appt_BI_MatchAccount().beforeInsert(newList);                    
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
    }        
}