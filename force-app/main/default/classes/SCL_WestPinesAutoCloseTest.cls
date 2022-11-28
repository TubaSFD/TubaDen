@isTest
public class SCL_WestPinesAutoCloseTest {

    static testmethod void testData() {
        
        //Custom Settings Data
		SCL_ComponentParameters__c instance = new SCL_ComponentParameters__c();
        instance.Name = 'Auto Close Days';
        instance.SCL_PharmacyPillPlannerCaseAutoCloseDays__c = 15;
        instance.SCL_PharmacyAntiCoagCaseAutoCloseDays__c = 15;
        instance.SCL_WestPinesAutoCloseDays__c = 15;
        insert instance;
    
        // Create test Case to be updated
        // by the batch job.
        Case caseInstance = new Case();
        caseInstance.Status = 'Ready to Schedule';
        //caseInstance.Type = 'Anti-Coag In-Patient';
        caseInstance.SCL_TOCProgram__c = 'Pill Planner';
        caseInstance.SCL_EpicEMR__c = 'Person Not Found';
        caseInstance.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Behavioral Health Intake').getRecordTypeId();
        insert caseInstance;
        
        Datetime yesterday = Datetime.now().addDays(-20);
        Test.setCreatedDate(caseInstance.Id, yesterday);
                
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_WestPinesSchedulable scheduleObj = new SCL_WestPinesSchedulable();
            SCL_WestPinesAutoClose obj = new SCL_WestPinesAutoClose();
            Database.executeBatch(obj);
			scheduleObj.execute(sc);         	
        Test.stopTest();
        

    }
}