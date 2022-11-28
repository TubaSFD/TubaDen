@isTest
private class SCL_CopyToClipboardTest {
    @TestSetup
    static void setTestData(){
        Case testCase = new Case();
        testCase.Origin = 'Phone';
        testCase.SCL_BenefitLetterContent__c = 'Test Description';
        testCase.SCL_EpicEMR__c	= 'Person Not Found';
        testCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pharmacy Anti-Coag In-Patient').getRecordTypeId();
        insert(testCase);
    }
    @isTest static void testgetDescription(){
        Test.startTest();
        String res = SCL_CopyToClipboard.getDescription([SELECT Id From Case Limit 1].Id);
        System.assertEquals('Test Description', res);
        Test.stopTest();
    }
}