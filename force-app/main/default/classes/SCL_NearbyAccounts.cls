public class SCL_NearbyAccounts {
    
    public class AccountWrapper  implements Comparable {
        @AuraEnabled
        public String AccId;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String shippingStreet;
        @AuraEnabled
        public String shippingCity;
        @AuraEnabled
        public Double distance;
        @AuraEnabled
        public String accountType;
        @AuraEnabled
        public String accountTier;
        
        public Integer compareTo(Object compareTo) {
        AccountWrapper compareToEmp = (AccountWrapper)compareTo;
        	if (distance == compareToEmp.distance)
        		return 0;
        	if (distance > compareToEmp.distance)
        		return 1;
        	return -1;        
        }
    }
    
    @AuraEnabled
    public static List<AccountWrapper> getAccounts(String recordId){
        List<AccountWrapper> accounts = new List<AccountWrapper>();
        List<AccountWrapper> finalAccountsList = new List<AccountWrapper>();
        Integer rowLimit;
        Account currentAccount = [SELECT ShippingAddress,ShippingLatitude,ShippingLongitude, ShippingPostalCode FROM Account WHERE Id = :recordId];
        String postCodeFirstThree = currentAccount.ShippingPostalCode.left(3) +'%';
        if(currentAccount.ShippingLatitude != null && currentAccount.ShippingLongitude != null) {
			Location loc1 = Location.newInstance(currentAccount.ShippingLatitude,currentAccount.ShippingLongitude);
	        List<Account> nearAccounts = [SELECT Id, Name, ShippingStreet, ShippingCity, ShippingLatitude, ShippingLongitude, SCL_TypeCalc__c, SCL_Tier__c, ShippingGeocodeAccuracy  
                                          FROM Account 
                                          WHERE ShippingLatitude != null 
                                          AND ShippingLongitude != null 
                                          AND ShippingStreet != null 
                                          AND ShippingCity != null 
                                          AND (RecordType.DeveloperName = 'SCL_Medical' OR RecordType.DeveloperName = 'SCL_Employer') 
                                          AND Id != :currentAccount.Id 
                                          AND ShippingPostalCode LIKE :postCodeFirstThree
                                          AND (ShippingGeocodeAccuracy = 'Address' 
                                          	OR ShippingGeocodeAccuracy = 'NearAddress' 
                                            OR ShippingGeocodeAccuracy = 'Block' 
                                            OR ShippingGeocodeAccuracy = 'Street'
                                              )];
	        for(Account acc : nearAccounts){
	           Location loc2 = Location.newInstance(acc.ShippingLatitude,acc.ShippingLongitude);
	           Decimal dist = Location.getDistance(loc1, loc2, 'mi');
	           if(dist < 20.0) {
		           AccountWrapper wrapper = new AccountWrapper();
		           wrapper.accId = acc.Id;
		           wrapper.name = acc.Name;
		           wrapper.shippingStreet = acc.ShippingStreet;
                   wrapper.ShippingCity = acc.ShippingCity;
		           wrapper.distance = dist.setScale(6, RoundingMode.HALF_UP);
                   wrapper.accountType = acc.SCL_TypeCalc__c;
                   wrapper.accountTier = acc.SCL_Tier__c;
		           accounts.add(wrapper);
	            }
	        }
	        accounts.sort();
            List<SCL_ComponentParameters__c> settingValues = SCL_ComponentParameters__c.getall().values();
            for(SCL_ComponentParameters__c instance :  settingValues){
                if(instance.SCL_NearbyAccountsRowLimit__c != NULL) {
                    rowLimit = instance.SCL_NearbyAccountsRowLimit__c.intValue();
                } else {
                    rowLimit = 12;
                }
            }
            for(Integer i = 0; i < accounts.size(); i++) {
                if(i == rowlimit) {
                    break;
                }
                finalAccountsList.add(accounts[i]);
            }
        }
        return finalAccountsList;
    }
    
}