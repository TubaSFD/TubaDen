@isTest

private class SCL_NearbyAccountsTest {
		
    
    private static testMethod void testAccountOne(){
        //Custom Setting Data
		SCL_ComponentParameters__c instance = new SCL_ComponentParameters__c();
        instance.Name = 'Nearby Accounts Test';
        instance.SCL_NearbyAccountsRowLimit__c = 1;
        insert instance;
        
        Id recordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SCL_Medical'].Id;
        List<Account> accounts = new List<Account>();
        Account acc = new Account();
        acc.ShippingStreet = '2300 Steele St';
        acc.ShippingCity= 'Denver';
        acc.ShippingState = 'CO';
        acc.ShippingPostalCode = '80205';
        acc.ShippingLatitude = 39.753785;
        acc.ShippingLongitude = -104.958988;
        acc.ShippingGeocodeAccuracy = 'Address';
        acc.Name = 'Denver Zoo';
        acc.RecordTypeId = recordTypeId;
        accounts.add(acc);
        
        Account acc1 = new Account();
        acc1.ShippingStreet = '2500 York St';
        acc1.ShippingCity= 'Denver';
        acc1.ShippingState = 'CO';
        acc1.ShippingPostalCode = '80205';
        acc1.ShippingLatitude = 39.753234;
        acc1.ShippingLongitude = -104.95711;
        acc1.ShippingGeocodeAccuracy = 'Address';
        acc1.Name = 'City Park Golf Course';
        acc1.RecordTypeId = recordTypeId;
        accounts.add(acc1); 
        
        Account acc2 = new Account();
        acc2.ShippingStreet = '2500 York St';
        acc2.ShippingCity= 'Denver';
        acc2.ShippingState = 'CO';
        acc2.ShippingPostalCode = '80205';
        acc2.ShippingLatitude = 39.753789;
        acc2.ShippingLongitude = -104.95822;
        acc2.ShippingGeocodeAccuracy = 'Address';
        acc2.Name = 'Denver Zoo - Monkey Island';
        acc2.RecordTypeId = recordTypeId;
        accounts.add(acc2); 
        
        insert accounts;
        
        Test.startTest();
        List<SCL_NearbyAccounts.AccountWrapper> nearbyAccs = SCL_NearbyAccounts.getAccounts(String.valueOf(acc.Id));
        Test.stopTest();
        
        System.assertEquals(nearbyAccs.size(),1);
    }
    
}