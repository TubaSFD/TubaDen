public class SCL_CopyToClipboard {
    @AuraEnabled
    public static String getDescription(String recordId) {
        List<Case> caseList = new List<Case>();
        caseList = [SELECT Id,SCL_BenefitLetterContent__c FROM Case WHERE Id=:recordId LIMIT 1];
        return(caseList[0].SCL_BenefitLetterContent__c); 
    }
}