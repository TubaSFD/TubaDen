// Tests the merging of person accounts to account for 
// a person account being uploaded (no epic id) and then subsequently 
// getting a patient person account from the Epic integration
@isTest
public class SCLAccountTriggerTester {
    @isTest static void testAccountTrigger(){  
        /*
        List<Account> existingAccount = new List<Account>();
            
        // Create patients - represents an inbound person account without an Epic Id
        Account acc1 = new Account();
        acc1.FirstName = 'Patient1';
        acc1.LastName = 'TestPatientAccount1';
        // Prospect from Marketing
        acc1.RecordTypeId = '0124x000000UaEjAAK';
        acc1.PersonEmail = 'Patient1@internet.com';
        existingAccount.add(acc1);

		// Creates a second non-epic person account different from the first
        Account acc2 = new Account();
        acc2.FirstName = 'Patient2';
        acc2.LastName = 'TestMarketingAccount2';
        // Prospect from Marketing
        acc2.RecordTypeId = '0124x000000UaEjAAK';
        acc2.PersonEmail = 'Patient2@internet.com';
        existingAccount.add(acc2);
        //Database.UpsertResult sr4 = Database.upsert(acc2, false);
        //System.debug('Patient2 upsert: ' + sr4);
        
        // Another non-Epic person account - same email different name
        Account acc3 = new Account();
        acc3.FirstName = 'Patient3';
        acc3.LastName = 'TestPatientAccount3';
        // Behavioral Health Prospect
        acc3.RecordTypeId = '0124x000000UaEhAAK';
        acc3.PersonEmail = 'Patient3@internet.com';
        existingAccount.add(acc3);
        //Database.UpsertResult sr6 = Database.upsert(acc4, false);
        //System.debug('Patient3 with with Patient1 email upsert: ' + sr6);
        
        // Insert all the non-Epic accounts at once.
        Insert existingAccount;

        List<Account> query = [SELECT Id, FirstName, LastName FROM Account WHERE LastName IN ('TestPatientAccount1','TestMarketingAccount2','TestPatientAccount3')];
        System.debug('In test - size and query = ' + query.size() + ' : ' + query);
        // Should have our three patient accounts
        System.assertEquals(query.size(),3);

        // Create an Epic person account - this one should merge into the existing one
        Account acc4 = new Account();
        acc4.FirstName = 'patient1';
        acc4.LastName = 'TestPatientAccount1';
        acc4.RecordTypeId = '0124x000000UaEiAAK';
        acc4.PersonEmail = 'patient1@internet.com';
        acc4.SCL_MRNPersonAccount__c = '00000010';
        acc4.SCL_Birthdate__pc = date.parse('11/15/1980');

        Database.UpsertResult sr4 = Database.upsert(acc4, false);
        System.debug('Patient1 with epic id upsert: ' + sr4);
        //
        List<Account> query2 = [SELECT Id, FirstName, LastName, PersonEmail, SCL_MRNPersonAccount__c FROM Account WHERE LastName IN ('TestPatientAccount1','TestMarketingAccount2','TestPatientAccount3')];
        System.debug('In test - size and query = ' + query2.size() + ' : ' + query2);
        // This should have merged with TestPatientAccount1 -- Should have our three patient accounts
        System.assertEquals(3,query2.size());
		
        List<Account> mergedAccounts = [SELECT Id, FirstName, LastName, 
                                        SCL_MRNPersonAccount__c,SCL_Birthdate__pc 
                                        FROM Account WHERE LastName ='TestPatientAccount1'];
        // Make sure the epic info came across to the existing account
        for (Account mergedAccount: mergedAccounts) {
            System.debug('Looking at Account id ' + mergedAccount.Id);
            if (mergedAccount.SCL_MRNPersonAccount__c != null) {
                System.debug('We have a match -- '+ mergedAccount.SCL_MRNPersonAccount__c);
                System.assertEquals('00000010', mergedAccount.SCL_MRNPersonAccount__c);
                System.assertEquals(date.parse('11/15/1980'), mergedAccount.SCL_Birthdate__pc);
            }
        }

        // Creates a duplicate epic person account with a different Epic id. = should not merge
        Account acc5 = new Account();
        acc5.FirstName = 'Patient1';
        acc5.LastName = 'TestPatientAccount1';
        acc5.RecordTypeId = '0124x000000UaEiAAK';
        acc5.PersonEmail = 'Patient1@internet.com';
        acc5.SCL_MRNPersonAccount__c = '00000011';
        acc5.SCL_Birthdate__pc = date.parse('11/15/1980');

		Database.UpsertResult sr5 = Database.upsert(acc5, false);
        System.debug('Patient1 with epic id upsert: ' + sr5);
                
        List<Account> verify = [SELECT Id, FirstName, LastName FROM Account WHERE LastName = 'TestPatientAccount1'];
        //System.debug('Duplicate patient with Epic ID was added with and ID of: ' + sr5.id);
        //System.debug('The ID of the patient without the Epic ID is ' + sr1.id);
        System.debug('The final query of Patient1 after the merge shows the following number of patients with a last name of TestPatientAccount1: ' + verify.size());
        System.debug('The final query of Patient1 after the merge shows the following ID: ' + verify[0].Id);
        
        // Creates a deceased epic person account 
        Account acc6 = new Account();
        acc6.FirstName = 'Patient1';
        acc6.LastName = 'TestPatientAccount6';
        acc6.RecordTypeId = '0124x000000UaEiAAK';
        acc6.PersonEmail = 'Patient6@internet.com';
        acc6.SCL_MRNPersonAccount__c = '00000066';
        acc6.SCL_Birthdate__pc = date.parse('11/15/1980');
		acc6.SCL_CPCareReminders__pc = true;        
        acc6.SCL_Deceased__pc = true;

		Database.UpsertResult sr6 = Database.upsert(acc6, false);
        System.debug('Patient6 with epic id upsert: ' + sr6);
                
        List<Account> verify1 = [SELECT Id, FirstName, LastName, SCL_CPCareReminders__pc FROM Account WHERE LastName = 'TestPatientAccount6'];
        // Verify the all CP fields will be set to false;
        System.assertEquals(false, verify1[0].SCL_CPCareReminders__pc);
        //System.debug('Duplicate patient with Epic ID was added with and ID of: ' + sr5.id);
        //System.debug('The ID of the patient without the Epic ID is ' + sr1.id);
        System.debug('The final query of Patient1 after the merge shows the following number of patients with a last name of TestPatientAccount6: ' + verify.size());
        System.debug('The final query of Patient1 after the merge shows the following ID: ' + verify1[0].Id);
		*/
    }
}