@isTest
public class SCL_AppointmentsArchiveTest {

    static testmethod void testData() {
        
        //Custom Settings Data
		SCL_ComponentParameters__c instance = new SCL_ComponentParameters__c();
        instance.Name = 'Appointments Archive Age';
        instance.SCL_AppointmentsArchiveAge__c = 15;
        insert instance;

        SCL_Appointment__c appointmentInstance = new SCL_Appointment__c();
        insert appointmentInstance;
        
        Datetime yesterday = Datetime.now().addDays(-20);
        Test.setCreatedDate(appointmentInstance.Id, yesterday);
        
        Test.startTest();
        	SchedulableContext sc = null;
        	SCL_AppointmentsArchiveSchedulable scheduleObj = new SCL_AppointmentsArchiveSchedulable();
            SCL_AppointmentsArchive obj = new SCL_AppointmentsArchive();
            Database.executeBatch(obj);
        	scheduleObj.execute(sc);
        Test.stopTest();
        
    }
}