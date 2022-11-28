/*
Name: SCL_GatewayUtils
Purpose: Helper class to handle common static values and functionalities across all other classes
Author: Allan Casalla
Date: 12/21/2021

Change Log
3/24/2022 - Allan Casalla - Change the retrieval of RecordTypeId from using SOQL to using Schema class
6/30/2022 - Allan Casalla - Change the type of cpAccountFields from List to Set
8/16/2022 - Tuba Ciftci - Add a new method to format the phone number fields with or without extension like (999) 999-9999 or (999) 999-9999 x999
8/23/2022 - Abdul Mohammed - added medicalRecordTypeId
10/24/2022- Tuba Ciftci - Add the retrieval of RecordTypeNames for Case Object using Custom Metadata
*/
public without sharing class SCL_GatewayUtils {
    public static final Integer DML_SIZE_LIMIT = 150;         
    public static Set<String> cpAccountFields = null;    
    public static Id prospectRecordTypeId = null;    
    public static Id patientRecordTypeId = null;
    public static Id sclMarketingRecordTypeId = null;    
    public static Id wpBHRecordTypeId = null;    
    public static Id pillPlannerRecordTypeId = null; 
    public static Id clinicalContactRecordTypeId = null;    
    public static Id medicalRecordTypeId = null;
    public static Id pharmacyQueueId = null;    
    public static Id wpFinancialQueueId = null;        
    public static String patientInterfaceAccountFields = null;
    public static string caseRecordTypes = null;
    public static List<SCL_POToAccountFields__c> ptaFields = null;        
    public static List<SCL_PlannedOutreachToCaseFields__c> ptcFields = null;                
    public static Map<String,String> caseCampaignMap = new Map<String,String>();       
    public static Map<String,String> caseRecordTypeIdMap = new Map<String,String>();           
    public static List<SCL_CaseToAccountFields__c> ctaFields = null;
    public static List<SCL_CaseToPlannedOutreachFields__c> ctpFields = null;        
    public static Map<String,String> poCampaignMap = new Map<String,String>();            
    
    /*
	Purpose:  Change the type of cpAccountFields from List to Set
	Author: Allan Casalla
	*/
    static {
        if (cpAccountFields == null) {
            List<FieldDefinition> cpAccountListFields = [SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.DeveloperName='Account' AND Label LIKE 'CP:%' AND DataType='Checkbox'];
            cpAccountFields = new Set<String>();
        	for (FieldDefinition cpAccountListField: cpAccountListFields) { 
            	cpAccountFields.add(cpAccountListField.QualifiedApiName);                    	
        	}  
        }
    }
    
    /*
	Purpose:  Change the retrieval of RecordTypeId from using SOQL to using Schema class
	Author: Allan Casalla
	*/ 
    static {        
        if (patientRecordTypeId == null) patientRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SCL_Patient').getRecordTypeId();        
    }
    
    static {        
        if (prospectRecordTypeId == null) prospectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SCL_Prospect').getRecordTypeId();        
    }    
                
    static {        
        if (sclMarketingRecordTypeId == null) sclMarketingRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCL_Marketing').getRecordTypeId();        
    }
    
    static {        
        if (wpBHRecordTypeId == null) wpBHRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCL_BehavioralIntake').getRecordTypeId();        
    }
    
    static {        
        if (pillPlannerRecordTypeId == null) pillPlannerRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCL_PharmacyPillPlanner').getRecordTypeId();        
    }
    
    /*
	Purpose:  Add the retrieval of RecordTypeId for SCL_Clinical using Schema class
	Author: Allan Casalla
	*/ 
    static {        
        if (clinicalContactRecordTypeId == null) clinicalContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('SCL_Clinical').getRecordTypeId();        
    }
    
     /*
	Purpose: Add the retrieval of RecordTypeNames for Case Object using Custom Metadata
	Author: Tuba Ciftci
	*/ 
 
  static {
        if (caseRecordTypes == null) caseRecordTypes = [SELECT IMH_Fields__c FROM IMH_Case_Record_Types__mdt LIMIT 1].IMH_Fields__c;      
    }
    
    /*
	Purpose:  Added the Medical Record Type
	Author: Abdul Mohammed
	*/
    static {        
        if (medicalRecordTypeId == null) medicalRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('SCL_Medical').getRecordTypeId();        
    }
    
    static {
        if (pharmacyQueueId == null) pharmacyQueueId = [SELECT Queue.Id FROM QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name = 'Pharmacy Team' LIMIT 1].Queue.Id;            
    }
    
    static {
        if (wpFinancialQueueId == null) wpFinancialQueueId = [SELECT Queue.Id FROM QueueSObject WHERE Queue.Type ='Queue' AND Queue.Name = 'WP Financial Counselor' LIMIT 1].Queue.Id;
    }
    
    static {
        if (patientInterfaceAccountFields == null) patientInterfaceAccountFields = [SELECT SCL_Fields__c FROM SCL_InterfaceSetting__mdt LIMIT 1].SCL_Fields__c;            
    }    
    
	static {
        if (ptaFields == null) ptaFields = SCL_POToAccountFields__c.getall().values();                 
    }
    
    static {
        if (ptcFields == null) ptcFields = SCL_PlannedOutreachToCaseFields__c.getall().values();                 
    }
    
    static {        
        if ((caseCampaignMap == null) || caseCampaignMap.isEmpty()) {
            List<SCL_CreateCampaign__c> poCaseCampaigns = SCL_CreateCampaign__c.getall().values();   
            for (SCL_CreateCampaign__c poCaseCampaign: poCaseCampaigns) {
                if ((poCaseCampaign.SCL_SourceObject__c == 'SCL_PlannedOutreach__c') && (poCaseCampaign.SCL_DestinationObject__c == 'Case') && (poCaseCampaign.SCL_CampaignNumber__c != null) && poCaseCampaign.SCL_Active__c) caseCampaignMap.put(poCaseCampaign.SCL_CampaignNumber__c,poCaseCampaign.SCL_RecordTypeName__c);
            }
        }
    }
    
    static {        
        if ((caseRecordTypeIdMap == null) || caseRecordTypeIdMap.isEmpty()) {            
            List<RecordType> caseRecordTypeIds = [SELECT Id,Name FROM RecordType WHERE SObjectType='Case'];
            for (RecordType caseRecordTypeId : caseRecordTypeIds) {  
        		caseRecordTypeIdMap.put(caseRecordTypeId.Name,caseRecordTypeId.Id);                            
        	}
        }
    }
    
    static {
        if (ctaFields == null) ctaFields = SCL_CaseToAccountFields__c.getall().values();              
    }
    
    static {
        if (ctpFields == null) ctpFields = SCL_CaseToPlannedOutreachFields__c.getall().values();                 
    }
    
    static {
        if ((poCampaignMap == null) || poCampaignMap.isEmpty()) {                         
            List<SCL_CreateCampaign__c> casePOCampaigns = SCL_CreateCampaign__c.getall().values();   
            for (SCL_CreateCampaign__c casePOCampaign: casePOCampaigns) {
                if ((casePOCampaign.SCL_SourceObject__c == 'Case') && (casePOCampaign.SCL_DestinationObject__c == 'SCL_PlannedOutreach__c') && (casePOCampaign.SCL_CampaignNumber__c != null) && casePOCampaign.SCL_Active__c) poCampaignMap.put(casePOCampaign.SCL_CampaignName__c,casePOCampaign.SCL_CampaignNumber__c);
            }            
        }
    }
    
    public static Boolean isMatchedValue (String firstValue, String firstValueType, String secondValue) {
        Boolean isMatchedValue = false;
  		switch on firstValueType {
            when 'Boolean' { isMatchedValue = (Boolean.valueOf(firstValue) == Boolean.valueOf(secondValue)); }
            when 'Integer' { isMatchedValue = (Integer.valueOf(firstValue) == Integer.valueOf(secondValue)); }
            when 'Double' { isMatchedValue = (Double.valueOf(firstValue) == Double.valueOf(secondValue)); }
            when else { isMatchedValue = (firstValue == secondValue); }
        }      
        return isMatchedValue;
    }
    
    public static List<SCL_ExceptionEvent__e> getEEList(List<SCL_ExceptionEvent__e> inEEList,Integer rowLimit,String order) {            	
        List<SCL_ExceptionEvent__e> outEEputList = new List<SCL_ExceptionEvent__e>();
        if (!inEEList.isEmpty()) {                         
            if (inEEList.size() < rowLimit) rowLimit = inEEList.size();            
            if (order == 'asc') {                
                for (Integer i=0; i<rowLimit; i++) {                                       
                    outEEputList.add(inEEList[i]);                                        
                }
            } else {            
                for (Integer i=inEEList.size()-1; i>(inEEList.size()-rowLimit-1); i--) {                                        
                    outEEputList.add(inEEList[i]);                                                            
                }                
            }
        }
        return outEEputList;
    }
    
    public static List<List<SObject>> getArrayListOfSObject(List<SObject> soList) {
    	List<List<SObject>> arrayListSObject = new List<List<SObject>>();
        List<SObject> ofListSobject = new List<SObject>();        
        if (!soList.isEmpty()) {             
            if (soList.size() > DML_SIZE_LIMIT) {
                Integer soListSize = soList.size();                
                for (Integer i=DML_SIZE_LIMIT; i<soListSize; i++) {                                    
                    ofListSobject.add(soList[DML_SIZE_LIMIT]);
                    soList.remove(DML_SIZE_LIMIT);                    
                }
            }
            arrayListSObject.add(soList);
            arrayListSObject.add(ofListSobject);               			           
        }
        return arrayListSObject;
    }
    
    public static List<List<SObject>> getListOfListOfSObject(List<SObject> soList) {
    	List<List<SObject>> listOfListSObject = new List<List<SObject>>();
        List<SObject> sObjectList;    
        if (!soList.isEmpty()) {                                    
            for (Integer i=0 ; i<(soList.size()/DML_SIZE_LIMIT)+1; i++) {
                sObjectList = new List<SObject>();        
                for (Integer j=(i*DML_SIZE_LIMIT); (j<(i*DML_SIZE_LIMIT)+DML_SIZE_LIMIT) && j<soList.size(); j++) {
                    sObjectList.add(soList.get(j));
                }
                listOfListSObject.add(sObjectList);
            }
        }
        return listOfListSObject;
    }
    
	//publish Exception Events  
    public static void publishException(List<SObject> sObjList, String triggerOperation, Exception e) {        
        if (sObjList.isEmpty()) return;
        String exceptionDetail = e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString();        
        List<SCL_ExceptionEvent__e> eeList = new List<SCL_ExceptionEvent__e>();
        SCL_ExceptionEvent__e ee;
        
        String sObjectName = sObjList[0].getSObjectType().getDescribe().getName();                   
        for (SObject sObj : sObjList) {            
            ee = new SCL_ExceptionEvent__e();                
            ee.SCL_ObjectName__c = sObjectName;             
            ee.SCL_TriggerOperation__c = triggerOperation; 
            ee.SCL_Exception__c = exceptionDetail;
            ee.SCL_Object__c = JSON.serialize(sObj);            
            eeList.add(ee);
        }                
        if (eeList.size()>0) eventBus.publish(eeList);              
    }   
    
   //format the phone number fields with or without extension like (999) 999-9999 or (999) 999-9999 x999
    public static String formatPhoneNumber(String phone) {
        String nonDigits = '[^0-9]';
        List<String> phoneNumberList = phone.toLowerCase().split('x');
        String formattedNumber = '';
        if (phoneNumberList.size()==0) return formattedNumber;                         
        //remove all kind of non numeric characters 
        phoneNumberList[0] = phoneNumberList[0].replaceAll(nonDigits,'');
        if(phoneNumberList[0].length()==10){
           formattedNumber = '(' + phoneNumberList[0].substring(0,3) + ') ' + phoneNumberList[0].substring(3,6) + '-' + phoneNumberList[0].substring(6,10);
        }
        else if(phoneNumberList[0].length()>10){
           formattedNumber = '(' + phoneNumberList[0].substring(phoneNumberList[0].length()-10,phoneNumberList[0].length()-7) + ') ' + phoneNumberList[0].substring(phoneNumberList[0].length()-7,phoneNumberList[0].length()-4) + '-' + phoneNumberList[0].substring(phoneNumberList[0].length()-4,phoneNumberList[0].length());   
        }
        else{
            formattedNumber = phoneNumberList[0];
        }
        
        if(phoneNumberList.size()>1 && String.isNotBlank(phoneNumberList[1]) ) {
           formattedNumber += (' x'+phoneNumberList[1].replaceAll(nonDigits,''));
        }      
        return formattedNumber;
    } 
}