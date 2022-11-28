@IsTest(SeeAllData=true)
public class SCL_AdminUtils_Test {
	@IsTest
    private static void transferRecordOwnership_test() {                    
      String fromOwnerName = 'Allan Casalla'; 
      String toOwnerName = 'Michael McKenna'; 
	  Id fromId = [SELECT Id, Name FROM User WHERE Name = :fromOwnerName LIMIT 1].Id;
	  Id toId = [SELECT Id, Name FROM User WHERE Name = :toOwnerName LIMIT 1].Id;
      
      Test.startTest();           
      Integer territories = [SELECT COUNT() FROM SCL_Territory__c WHERE OwnerId = :fromId];      
      System.debug('before transfer territories size: '+territories);              
      Integer tCodes = [SELECT COUNT() FROM SCL_TerritoryCode__c WHERE SCL_CoveredBy__c = :fromId];      
      System.debug('before transfer tCodes size: '+tCodes);            
      Integer tasks = [SELECT COUNT() FROM Task WHERE OwnerId = :fromId];      
      System.debug('before transfer tasks size: '+tasks);          
      /*  
      Integer cases = [SELECT COUNT() FROM Case WHERE OwnerId = :fromId];     
      System.debug('before transfer cases size: '+cases);          
      Integer contacts = [SELECT COUNT() FROM Contact WHERE OwnerId = :fromId];      
      System.debug('before transfer contacts size: '+contacts);         
      Integer accounts = [SELECT COUNT() FROM Account WHERE OwnerId = :fromId];
      System.debug('before transfer accounts size: '+accounts);  
	  */
              
      List<String> sfObjects = SCL_AdminUtils.getListOfObjects(0,99);        
      System.assertEquals(100, sfObjects.size()); 
      // SCL_AdminUtils.transferRecordOwnership(fromOwnerName,toOwnerName,sfObjects);  
      // sfObjects = new List<String>{'SCL_Territory__c','SCL_TerritoryCode__c','Task','Case','Contact','Account'};
      sfObjects = new List<String>{'SCL_Territory__c','SCL_TerritoryCode__c','Task'};
      // Execute transfer record ownership method    
      SCL_AdminUtils.transferRecordOwnership(fromOwnerName,toOwnerName,sfObjects);         
      territories = [SELECT COUNT() FROM SCL_Territory__c WHERE OwnerId = :fromId];      
      System.debug('after transfer territories size: '+territories);                
      System.assertEquals(0, territories);  
      tCodes = [SELECT COUNT() FROM SCL_TerritoryCode__c WHERE SCL_CoveredBy__c = :fromId];            
      System.debug('after transfer tCodes size: '+tCodes);    
      System.assertEquals(0, tCodes);  
      tasks = [SELECT COUNT() FROM Task WHERE OwnerId = :fromId];      
      System.debug('after transfer tasks size: '+tasks);    
      System.assertEquals(0, tasks);  
        
      /*  
      cases = [SELECT COUNT() FROM Case WHERE OwnerId = :fromId];      
      System.debug('after transfer cases size: '+cases);    
      System.assertEquals(0, cases);  
      contacts = [SELECT COUNT() FROM Contact WHERE OwnerId = :fromId];      
      System.debug('after transfer contacts size: '+contacts);    
      System.assertEquals(0, contacts);    
      accounts = [SELECT COUNT() FROM Account WHERE OwnerId = :fromId];
      System.debug('after transfer accounts size: '+accounts);    
      System.assertEquals(0, accounts.size());         
	  */
      Test.stopTest();            
    }
}