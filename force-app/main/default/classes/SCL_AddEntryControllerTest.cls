@isTest
public class SCL_AddEntryControllerTest {
    static testMethod void validateHelloWorld() {
        //Test Data
        Case caseInstance = new Case(Origin='Phone', SCL_EpicEMR__c = 'Person Not Found');
        caseInstance.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Behavioral Health Intake').getRecordTypeId();
        insert caseInstance;
        
        List<SCL_Entry__c> entriesToInsert = new List<SCL_Entry__c>();
        SCL_Entry__c entryInstance = new SCL_Entry__c(SCL_Category__c = 'Abused Substance', SCL_Type__c = 'Alcohol');
        entriesToInsert.add(entryInstance);
        
        Test.startTest();
        	SCL_AddEntryController.saveEntries(entriesToInsert, caseInstance.Id);
        	SCL_AddEntryController.getCategory();
        	SCL_AddEntryController.getDependentPicklistValues('Type');
        Test.stopTest();
    }
}