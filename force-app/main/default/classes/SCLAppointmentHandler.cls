public with sharing class SCLAppointmentHandler {
    /*
    public with sharing class SCLAppointmentHandler implements SCLInterfaceTrigger {
    List<SCL_Appointment__c> newTrigger = Trigger.New;
    List<String> epicPatientIdStr = new List<String>();
    List<String> epicPatientEmailStr = new List<String>();
    List<SCL_Appointment__c> epicAppointmentList = new List<SCL_Appointment__c>();
    Map<String,Account> epicPatientIdMap = new Map<String,Account>();
    private static boolean stopRecursion = false;
    // Constructor
    public SCLAppointmentHandler() {
    }
    
    public void bulkBefore() {
        try {
            // Begin creation of string set with patient Ids.
            if (!stopRecursion) {
                if (Trigger.isUpdate || Trigger.isInsert) {
                    for (SCL_Appointment__c app1 : newTrigger) {
                        if(String.isNotBlank(app1.SCL_MRN__c)) {
                            if (!epicPatientIdStr.contains(app1.SCL_MRN__c)) {
                                epicPatientIdStr.add(app1.SCL_MRN__c);
                                if(String.isNotBlank(app1.SCL_PersonEmail__c)) {
                                	epicPatientEmailStr.add(app1.SCL_PersonEmail__c);
                                }
                                epicAppointmentList.add(app1);
                            }
                        }
                    }
                    // Create map of Epic patient Id values and associated SF Ids from Person Account
                    if (!epicPatientIdStr.isEmpty()) {
                        epicPatientIdMap = SCLAppointmentGateway.getEpicPatientSFId(epicPatientIdStr,epicPatientEmailStr,epicAppointmentList);
                    }
                    // Loop through Trigger.new records and SCL_Patient__c and SCL_PersonEmail__c to the mapped value in epicPatientIdMap.
                    for (SCL_Appointment__c app2 : newTrigger) {
                        if (!epicPatientIdMap.isEmpty()) {
                            if(String.isNotBlank(app2.SCL_MRN__c)) {
                                Account acc = epicPatientIdMap.get(app2.SCL_MRN__c);
                                if (acc != null) {
                                    app2.SCL_Patient__c = acc.Id;
                                    if (acc.PersonEmail != null) {
                                        app2.SCL_PersonEmail__c = acc.PersonEmail;
                                        System.debug('Account Id:'+acc.Id+';MRN:'+app2.SCL_MRN__c+';Email:'+acc.PersonEmail);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }
    
    public void bulkAfter()
    {

    }
        
    public void beforeInsert(SObject so)
    {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {
        
    }
    
    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {
                   
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void andFinally()
    {

    }
	*/
}