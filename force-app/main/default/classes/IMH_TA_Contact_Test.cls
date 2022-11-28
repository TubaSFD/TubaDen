@IsTest(SeeAllData=true)
public class IMH_TA_Contact_Test {    
    @IsTest
    private static void beforeUpdate_test() {
        List<Contact> newList = new List<Contact>();
        List<Contact> oldList = new List<Contact>();
        
        newList.add(new Contact(FirstName = 'Test1', LastName = 'Test1', Phone='9999999999',Fax='19999999999X999',MobilePhone='99999999')); 
        newList.add(new Contact(FirstName = 'Test2', LastName = 'Test2', Phone='x',Fax='1x999999999',OtherPhone='x99999999'));              
        insert newList;        
        oldList = newList;  
        
        Test.startTest();
        new IMH_TA_Contact_BU_GetContactInfo.Service().beforeUpdate(newList, oldList);
        Test.stopTest();
        //Use getErrors() SObject method to get errors from addError without performing DML
        System.assertEquals(false, newList[0].hasErrors());
        System.assertEquals(0, newList[0].getErrors().size());  
    }
    
 @IsTest
    private static void beforeInsert_test() {
       List<Contact> newList = new List<Contact>();
       List<Contact> oldList = new List<Contact>();
        
      newList.add(new Contact(FirstName = 'Test1', LastName = 'Test1', Phone='9999999999',Fax='19999999999X999',MobilePhone='99999999')); 
      newList.add(new Contact(FirstName = 'Test2', LastName = 'Test2', Phone='x',Fax='1x999999999',MobilePhone='x99999999'));             
      insert newList;      
      oldList = newList;  
      Test.startTest();
        
      new IMH_TA_Contact_BI_GetContactInfo.Service().beforeInsert(newList);
      Test.stopTest();
      //Use getErrors() SObject method to get errors from addError without performing DML
      System.assertEquals(false, newList[0].hasErrors());
      System.assertEquals(0, newList[0].getErrors().size());        
    }    
}