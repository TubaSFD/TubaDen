@IsTest(SeeAllData=true)
public class SCL_TA_ExceptionLog_Test {        
    @IsTest
    private static void beforeUpdate_test() {
      List<SCL_ExceptionLog__c> newList = new List<SCL_ExceptionLog__c>(); 
      List<SCL_ExceptionLog__c> oldList = new List<SCL_ExceptionLog__c>(); 
      Exception e = new SCLTriggerException('Test Exception'); 
      String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();          
      Account acc = new Account(FirstName='Test5', LastName='Test5', PersonEmail='test5.test5@test.com');
      newList.add(new SCL_ExceptionLog__c(SCL_ObjectName__c = 'Account', SCL_TriggerOperation__c = 'insert', SCL_Exception__c=exceptionDetail, SCL_ExternalID__c='Acct-test5.test5@test.comtest5test5', SCL_Object__c = JSON.serialize(acc), SCL_Retries__c = 0));            
      oldList = newList;  
      insert newList;  
      Test.startTest();	  
      new SCL_TA_ExceptionLog_BU_IncrementRetries().beforeUpdate(newList,oldList);      
      Test.stopTest();           
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
	}
}