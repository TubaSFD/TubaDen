// Tests that Appointment will able to link account
@isTest
public class SCLAppointmentTriggerTester {
    @isTest static void testAppointmentTrigger(){
        /*
    	// Create patient - represents an inbound person account
        Account acc = new Account();
        acc.RecordTypeId = '0124x000000UaEiAAK';
        acc.FirstName = 'FirstPatient1';
        acc.LastName = 'LastPatient1';
        acc.PersonEmail = 'Patient1@test.com';
    	acc.SCL_MyChartStatus__pc = 'Activated';
    	acc.SCL_MRNPersonAccount__c = 'X011111111';
    	Database.UpsertResult sr = Database.upsert(acc, false);
        
        // Create first appointment - represents an inbound appointment where MRN is the same as the MRN on the Account created above.
        SCL_Appointment__c appt = new SCL_Appointment__c();
        appt.SCL_AppointmentID__c = '2100152704';
        appt.SCL_MRN__c = 'X011111111';
        appt.SCL_Status__c = 'Scheduled';
        appt.SCL_DateScheduled__c = Date.today();
        appt.SCL_AppointmentDate__c = Date.today();
        DateTime dt = DateTime.now();
        appt.SCL_AppointmentTime__c = dt.addHours(8);
        appt.SCL_VisitTypeID__c = '40042';
        appt.SCL_VisitTypeName__c  = 'MYC CO PATIENT COVID VACCINE';
        appt.SCL_LocationID__c = '60100';
        appt.SCL_LocationName__c = 'SCLH PHARMACY SERVICES';
    	appt.SCL_LocationExtName__c = 'Boulder County Immunization';
        appt.SCL_LocationAddress__c = 'South Public Road, Lafayette, Colorado 80027';
        appt.SCL_DepartmentID__c = '60109';
        appt.SCL_DepartmentName__c = 'OP PHARMACY 2';
        
    	Database.UpsertResult sr1 = Database.upsert(appt, false);
        
        SCL_Appointment__c appt1 = [SELECT Id,SCL_Patient__c FROM SCL_Appointment__c WHERE SCL_MRN__c='X011111111'];
        System.debug('Appt1 Id: ' + appt1.Id + ' ;appt1.SCL_Patient__c: ' + appt1.SCL_Patient__c + ' ;acc.Id: ' + acc.Id);
        System.assertEquals(acc.Id, appt1.SCL_Patient__c); 
        
        // Create second appointment - represents an inbound appointment where there is no matching account.
        SCL_Appointment__c appt2 = new SCL_Appointment__c();
        appt2.SCL_AppointmentID__c = '2100152705';
        appt2.SCL_MRN__c = 'X022222222';
		appt2.SCL_ApptFirstName__c = 'FirstPatient2'; 
		appt2.SCL_ApptLastName__c = 'LastPatient2';
		appt2.SCL_PersonEmail__c = 'Patient2@test.com';
        appt2.SCL_Status__c = 'Scheduled';
        appt2.SCL_DateScheduled__c = Date.today();
        appt2.SCL_AppointmentDate__c = Date.today();
        DateTime dt1 = DateTime.now();
        appt2.SCL_AppointmentTime__c = dt1.addHours(8);
        appt2.SCL_VisitTypeID__c = '40042';
        appt2.SCL_VisitTypeName__c  = 'MYC CO PATIENT COVID VACCINE';
        appt2.SCL_LocationID__c = '60100';
        appt2.SCL_LocationName__c = 'SCLH PHARMACY SERVICES';
    	appt2.SCL_LocationExtName__c = 'Boulder County Immunization';
        appt2.SCL_LocationAddress__c = 'South Public Road, Lafayette, Colorado 80027';
        appt2.SCL_DepartmentID__c = '60109';
        appt2.SCL_DepartmentName__c = 'OP PHARMACY 2';
        
    	Database.UpsertResult sr3 = Database.upsert(appt2, false);
        
        SCL_Appointment__c appt3 = [SELECT Id,SCL_Patient__c,SCL_ApptFirstName__c,SCL_ApptLastName__c,SCL_PersonEmail__c FROM SCL_Appointment__c WHERE SCL_MRN__c='X022222222'];
        
		Account acc1 = [SELECT Id,FirstName,LastName,PersonEmail FROM Account WHERE SCL_MRNPersonAccount__c = 'X022222222' LIMIT 1];
		 
        System.debug('Appt3 Id: ' + appt3.Id + ' ;appt3.SCL_Patient__c: ' + appt3.SCL_Patient__c + ' ;acc1.Id: ' + acc1.Id);
        System.assertEquals(acc1.Id, appt3.SCL_Patient__c);
		System.assertEquals(acc1.FirstName, appt3.SCL_ApptFirstName__c);
		System.assertEquals(acc1.LastName, appt3.SCL_ApptLastName__c);
		System.assertEquals(acc1.PersonEmail, appt3.SCL_PersonEmail__c);
        
        // CAB: CHG0062002
        // Create second patient - represents an inbound person account
        Account acc2 = new Account();
        acc2.RecordTypeId = '0124x000000UaEiAAK';
        acc2.FirstName = 'FirstPatient2';
        acc2.LastName = 'LastPatient2';
        acc2.PersonEmail = 'Patient1@test.com';
    	acc2.SCL_MyChartStatus__pc = 'Activated';    	
    	Database.UpsertResult sr4 = Database.upsert(acc2, false);
        
        // Create third appointment - represents an inbound appointment where there is no matching account.
        SCL_Appointment__c appt4 = new SCL_Appointment__c();
        appt4.SCL_AppointmentID__c = '2100152706';
        appt4.SCL_MRN__c = 'X033333333';
		appt4.SCL_ApptFirstName__c = 'FirstPatient2'; 
		appt4.SCL_ApptLastName__c = 'LastPatient2';
		appt4.SCL_PersonEmail__c = 'Patient1@test.com';
        appt4.SCL_Status__c = 'Scheduled';
        appt4.SCL_DateScheduled__c = Date.today();
        appt4.SCL_AppointmentDate__c = Date.today();
        DateTime dt2 = DateTime.now();
        appt4.SCL_AppointmentTime__c = dt1.addHours(8);
        appt4.SCL_VisitTypeID__c = '40042';
        appt4.SCL_VisitTypeName__c  = 'MYC CO PATIENT COVID VACCINE';
        appt4.SCL_LocationID__c = '60100';
        appt4.SCL_LocationName__c = 'SCLH PHARMACY SERVICES';
    	appt4.SCL_LocationExtName__c = 'Boulder County Immunization';
        appt4.SCL_LocationAddress__c = 'South Public Road, Lafayette, Colorado 80027';
        appt4.SCL_DepartmentID__c = '60109';
        appt4.SCL_DepartmentName__c = 'OP PHARMACY 2';
        
    	Database.UpsertResult sr5 = Database.upsert(appt4, false);
        
        SCL_Appointment__c appt5 = [SELECT Id,SCL_Patient__c,SCL_ApptFirstName__c,SCL_ApptLastName__c,SCL_MRN__c,SCL_PersonEmail__c FROM SCL_Appointment__c WHERE SCL_AppointmentID__c='2100152706'];
        
		Account acc3 = [SELECT Id,FirstName,LastName,SCL_MRNPersonAccount__c,PersonEmail FROM Account WHERE SCL_MRNPersonAccount__c = 'X033333333' LIMIT 1];
        
        System.debug('Appt5 Id: ' + appt5.Id + ' ;appt5.SCL_Patient__c: ' + appt5.SCL_Patient__c + ' ;acc3.Id: ' + acc3.Id);
        System.assertEquals(acc3.Id, appt5.SCL_Patient__c);
		System.assertEquals(acc3.SCL_MRNPersonAccount__c, appt5.SCL_MRN__c);
		*/
    }

}