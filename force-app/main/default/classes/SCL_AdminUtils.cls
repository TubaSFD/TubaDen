/*
Name: SCL_AdminUtils
Purpose: Helper class to handle administrator tasks
Author: Allan Casalla
Date: 05/12/2022

Change Log
05/12/2022 - Allan Casalla - Add transferRecordOwnership method to mass transfer the records ownership
*/
public with sharing class SCL_AdminUtils {        
	/*
	Purpose:  Mass transfer the records ownership
	Author: Allan Casalla
	*/
    public static void transferRecordOwnership(String fromOwnerName, String toOwnerName, List<String> sfObjects) {                
        if (String.isBlank(fromOwnerName) || String.isBlank(toOwnerName) || (sfObjects == null)) return;                        
        try {
            Id fromId = [SELECT Id, Name FROM User WHERE Name = :fromOwnerName LIMIT 1].Id;
            System.debug('(From) User Id of ' + fromOwnerName + ': '+fromId);
			Id toId = [SELECT Id, Name FROM User WHERE Name = :toOwnerName LIMIT 1].Id;
            System.debug('(To) User Id of ' + toOwnerName + ': '+toId);
            for (String sfObject: sfObjects) { 
                String ownerField = '';  
                SObject so = (SObject)(Type.forName('Schema.'+ sfObject).newInstance());                  
                 
                if (so.getSobjectType().getDescribe().fields.getMap().containsKey('OwnerId')) {
                	ownerField = 'OwnerId';
                } else if (so.getSobjectType().getDescribe().fields.getMap().containsKey('SCL_CoveredBy__c')) {
                    ownerField = 'SCL_CoveredBy__c';
                } else {
                    continue;
                }
                
                if (!so.getSobjectType().getDescribe().fields.getMap().get(ownerField).getDescribe().isUpdateable()) continue;
                String listType = 'List<' + sfObject + '>';
                try {
                	List<SObject> objectsToUpdate = (List<SObject>)Type.forName(listType).newInstance();
                }	catch(Exception e1) {
					System.debug('An unexpected error has occurred: ' + e1.getTypeName() + '; ' +e1.getMessage() + '; '+e1.getCause() + '; ' +e1.getLineNumber() + '; '+e1.getStackTraceString());
                    continue;
				} 
                
                List<SObject> listSObject = (List<SObject>)Type.forName(listType).newInstance();
                String strQuery = 'SELECT Id,' + ownerField + ' FROM ' + sfObject + ' WHERE ' + ownerField + '= \'' + fromId + '\'';                
                listSObject = Database.query(strQuery);                       
                if(listSObject.isEmpty()) continue;
                                
                for (SObject obj: listSObject) {
                    obj.put(ownerField,toId);                       
                }
                
                update listSObject;                
                System.debug('No. of '+ sfObject +' records that have been transferred: ' + listSObject.size());
            }			
        }	catch(Exception e) {
			System.debug('An unexpected error has occurred: ' + e.getTypeName() + '; ' +e.getMessage() + '; '+e.getCause() + '; ' +e.getLineNumber() + '; '+e.getStackTraceString());
		}    
    }  
    
    public static List<String> getListOfObjects(Integer startIndex, Integer endIndex) {        
        List<String> objectList = new List<String>();
        Integer objCtr = 0;
        for (Schema.SObjectType obj : Schema.getGlobalDescribe().values()) {            
            Schema.DescribeSObjectResult objResult = obj.getDescribe();            
            if (objResult.isAccessible() && objResult.isQueryable()) {                
            	objCtr++;
                if (objCtr < startIndex+1) continue;
            	if (objCtr > endIndex+1) break;
                objectList.add(objResult.getName());                     
            }            
        }
        return objectList;
    }    
}