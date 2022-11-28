@isTest
public class SCL_DeleteExceptionLogTest {
	static testmethod void testData() {        
        SCL_ExceptionLog__c elInstance = new SCL_ExceptionLog__c();
        elInstance.SCL_ExternalID__c = 'Acct-X111111111';        
        elInstance.SCL_Resolved__c = true;        
        insert elInstance;
        
        Datetime someDays = Datetime.now().addDays(-20);
        Test.setCreatedDate(elInstance.Id, someDays);
        List<SCL_ExceptionLog__c> elList = [SELECT Id,SCL_ExternalID__c,SCL_Resolved__c,CreatedDate FROM SCL_ExceptionLog__c WHERE SCL_Resolved__c=true];	        
        for (SCL_ExceptionLog__c el: elList) {
            System.debug('Id:'+el.Id+' ;SCL_ExternalID__c:'+el.SCL_ExternalID__c+' ;SCL_Resolved__c:'+el.SCL_Resolved__c+' ;CreatedDate:'+el.CreatedDate);
        }
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_DeleteExceptionLogSchedule scheduleObj = new SCL_DeleteExceptionLogSchedule();
            SCL_DeleteExceptionLog obj = new SCL_DeleteExceptionLog();
            Database.executeBatch(obj);
        	scheduleObj.execute(sc);
        Test.stopTest();        
    }
}