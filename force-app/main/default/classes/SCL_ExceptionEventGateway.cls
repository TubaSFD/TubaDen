public without sharing class SCL_ExceptionEventGateway {    
    public static void processExceptionEvents(List<SCL_ExceptionEvent__e> eeList) {         
        List<SCL_ExceptionLog__c> elList = new List<SCL_ExceptionLog__c>();
        Map<String,SCL_ExceptionLog__c> elMap = new Map<String,SCL_ExceptionLog__c>();
        SCL_ExceptionLog__c el;
        String sObjectName = eeList[0].SCL_ObjectName__c;
        String externalIdFieldName = '';
        Integer index = 0;    
        SCL_ExceptionEvent__e ee;
        Integer size = eeList.size(); 
        
        try {
            for (Integer i = 0; i < size; ++i) {              
                if (Limits.getCpuTime() >= (Limits.getLimitCpuTime() * 0.97)) throw new SCLTriggerException('Apex CPU time limit exceeded');                            
                ee = eeList[i];
                index++;
                el = new SCL_ExceptionLog__c();                
                el.SCL_EventUuid__c = ee.EventUuid;
                el.SCL_ObjectName__c = sObjectName;
                
                switch on sObjectName {                            
                    when 'Account' { 
                        Account acc = (Account) JSON.deserialize(ee.SCL_Object__c,Account.class);
                        el.SCL_RecordId__c = acc.Id;
                        String externalID = String.isNotBlank(acc.SCL_MRNPersonAccount__c) ? acc.SCL_MRNPersonAccount__c : (acc.PersonEmail + acc.FirstName + acc.LastName);
                        el.SCL_ExternalID__c = 'Acct-' + externalID.toLowercase();
                        el.SCL_Object__c = JSON.serialize(acc); 
                        externalIdFieldName = 'SCL_MRNPersonAccount__c';
                    }
                    when 'Case' {                                                    
                        Case case1 = (Case) JSON.deserialize(ee.SCL_Object__c,Case.class);
                        el.SCL_RecordId__c = case1.Id;                        
                        case1.SCL_ExternalID__c = (case1.SCL_FormCampaignName__c + case1.SCL_FormEmail__c + case1.SCL_FormFirstName__c  + case1.SCL_FormLastName__c).toLowercase().replace('null','');                    
                        el.SCL_ExternalID__c = 'Case-' + case1.SCL_ExternalID__c;                        
                        el.SCL_Object__c = JSON.serialize(case1); 
                        externalIdFieldName = 'SCL_ExternalID__c';
                    }
                    when 'SCL_PlannedOutreach__c' {	                        
                        SCL_PlannedOutreach__c po = (SCL_PlannedOutreach__c) JSON.deserialize(ee.SCL_Object__c,SCL_PlannedOutreach__c.class);
                        el.SCL_RecordId__c = po.Id;
                        po.SCL_ExternalID__c = String.isNotBlank(po.SCL_MRN__c) ? (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_MRN__c) : (po.SCL_CampaignNumber__c + po.SCL_FirstName__c + po.SCL_Email__c);                    
                        el.SCL_ExternalID__c = 'PO-' + po.SCL_ExternalID__c.toLowercase();  
                        el.SCL_Object__c = JSON.serialize(po); 
                        externalIdFieldName = 'SCL_ExternalID__c';
                    }                        
                    when 'SCL_Appointment__c' {		                                                                                    
                        SCL_Appointment__c appt = (SCL_Appointment__c) JSON.deserialize(ee.SCL_Object__c,SCL_Appointment__c.class);
                        el.SCL_RecordId__c = appt.Id;
                        el.SCL_ExternalID__c = 'Appt-' + appt.SCL_AppointmentID__c;                    
                        el.SCL_Object__c = JSON.serialize(appt); 
                        externalIdFieldName = 'SCL_AppointmentID__c';
                    }
                } 
                
                el.SCL_TriggerOperation__c = ee.SCL_TriggerOperation__c; 
                el.SCL_Exception__c = ee.SCL_Exception__c;            
                elMap.put(el.SCL_ExternalID__c,el);
                if (elMap.size() == 100) {            
                    upsertExceptionLog(elMap,sObjectName,externalIdFieldName);  
                    elMap.clear();
                }
            }
            if (!elMap.keySet().isEmpty()) {
                upsertExceptionLog(elMap,sObjectName,externalIdFieldName);  
            }            
            elList = null;
            elMap = null;                        
        } catch (Exception e) {
            if (index > 100) {
                processExceptionEvents(eeList);
            } else {                
                Integer eeLeft = eeList.size()-100;
                if (eeLeft < 0) eeLeft = eeList.size();                                
                processExceptionEvents(SCL_GatewayUtils.getEEList(eeList,eeLeft,'desc'));
            }                        
            String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();     
            System.debug('processExceptionEvents exception: '+exceptionDetail);
        }
    }
        
    private static void upsertExceptionLog(Map<String,SCL_ExceptionLog__c> elMap,String sObjectName,String externalIdFieldName) {                        
        Map<String,SObject> sObjectMap = new Map<String,SObject>();                   
        try {
            Database.upsert(elMap.Values(), SCL_ExceptionLog__c.SCL_ExternalID__c, false);
            Schema.SObjectField externalIdField = Schema.getGlobalDescribe().get(sObjectName).getDescribe().fields.getMap().get(externalIdFieldName);                           
            SObject sfObject;            
            List<SCL_ExceptionLog__c> elList = [SELECT Id,SCL_Resolved__c,SCL_Retries__c,SCL_ExternalID__c,SCL_Object__c FROM SCL_ExceptionLog__c WHERE SCL_ExternalID__c IN :elMap.keySet()];
            for (SCL_ExceptionLog__c el : elList) {                 
                if (el.SCL_Resolved__c || el.SCL_Retries__c > 3) continue;                                  
                switch on sObjectName {
                    when 'Account' {		                            
                        sfObject = (Account) JSON.deserialize(el.SCL_Object__c, Account.class);                        
                    }
                    when 'SCL_PlannedOutreach__c' {		                        
                        sfObject = (SCL_PlannedOutreach__c) JSON.deserialize(el.SCL_Object__c, SCL_PlannedOutreach__c.class);                                            
                    }
                    when 'Case' {		
                        sfObject = (Case) JSON.deserialize(el.SCL_Object__c, Case.class);                                                
                    }
                    when 'SCL_Appointment__c' {		
                        sfObject = (SCL_Appointment__c) JSON.deserialize(el.SCL_Object__c, SCL_Appointment__c.class);                    
                    }
                }            
                sObjectMap.put(el.SCL_ExternalID__c,sfObject);
            }
            
            if (sObjectMap.size() > 0) reprocessSobject(sObjectMap,externalIdField,sObjectName,externalIdFieldName);                    
            sObjectMap = null;
            externalIdField = null;                        
        } catch (Exception e) {
            String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();        
            System.debug('upsertExceptionLog exception: '+exceptionDetail);
        }
    }    
        
    private static void reprocessSobject(Map<String,SObject> sObjectMap,Schema.SObjectField externalIdField,String sObjectName,String externalIdFieldName) {                
        Map<String,SCL_ExceptionLog__c> elMap = new Map<String,SCL_ExceptionLog__c>();        
        SCL_ExceptionLog__c el;
        Boolean entityIsDeleted;
        try {
            List<String> externalIdList= new List<String>(sObjectMap.keySet());                                    
            SObject sfObject; 
            Database.UpsertResult result;                        
            List<Database.UpsertResult> results = Database.upsert(sObjectMap.Values(),externalIdField,false);
            for (Integer index = 0, size = results.size(); index < size; index++) {                
                entityIsDeleted = false;
                el = new SCL_ExceptionLog__c();                 
                el.SCL_ExternalID__c = externalIdList[index];                
                el.SCL_Resolved__c = false;             
                if(results[index].isSuccess()) {                    
                    el.SCL_Resolved__c = true;                                    
                } else {                          
                    if (sObjectName == 'SCL_PlannedOutreach__c') {                        
                        for (Database.Error err : results[index].getErrors()) {                                                                                        
                            if (err.getStatusCode()+'' == 'ENTITY_IS_DELETED') {                                
                                entityIsDeleted = true;
                                break;
                            }
                        }  
                    } 
                    if (entityIsDeleted) {                        
                        SCL_PlannedOutreach__c po = (SCL_PlannedOutreach__c) sObjectMap.Values()[index]; 
                        String firstName = po.SCL_FirstName__c;
                        String mrn = po.SCL_MRN__c;
                        String email = po.SCL_Email__c;                                
                        po.SCL_FirstName__c = '';    
                        po.SCL_MRN__c = '';
                        po.SCL_Email__c = '';                        
                        result = Database.upsert(po,externalIdField,false);                                                         
                        if (result.isSuccess()) {                             
                            po.SCL_FirstName__c = firstName;
                            po.SCL_MRN__c = mrn;
                            po.SCL_Email__c = email;
                            result = Database.upsert(po,externalIdField,false);                             
                            if (result.isSuccess()) {                                   
                                el.SCL_Object__c = JSON.serialize(po);
                                el.SCL_Resolved__c = true;                                                    
                            }
                        }                                                      
                    }                
                }
                elMap.put(el.SCL_ExternalID__c,el);                           
            }                        
            if (elMap.size() > 0) upsertExceptionLog(elMap,sObjectName,externalIdFieldName);              
            elMap = null;
            externalIdList = null;         
            results = null;                     
        } catch (Exception e) {
            String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();        
            System.debug('reprocessSobject exception: '+exceptionDetail);
        }
    }   
}