public class SCL_AddEntryController {
    @AuraEnabled
    public static void saveEntries(List<SCL_Entry__c> entryList, ID recordId){
        List<SCL_Entry__c> entriesToInsert = new List<SCL_Entry__c>();
        for(SCL_Entry__c instance : entryList){
            instance.SCL_Case__c = recordId;
            instance.SCL_DateReported__c = System.today();
            entriesToInsert.add(instance);
        }
        insert entriesToInsert;
    }
    
    @AuraEnabled
    public static List<String> getCategory(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = SCL_Entry__c.SCL_Category__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        return options;
    }    
    
    /////////////////////////////////////////////////////    
    @AuraEnabled
    public static Map<String, List<String>> getDependentPicklistValues(String dependentPicklistLabel) {
        Schema.sObjectField dependToken = dependentPicklistLabel == 'Type' ? SCL_Entry__c.SCL_Type__c  : SCL_Entry__c.SCL_LevelOfCare__c;
        Schema.DescribeFieldResult depend = dependToken.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        if (controlToken == null) {
            return new Map<String, List<String>>();
        }
        
        Schema.DescribeFieldResult control = controlToken.getDescribe();
        List<Schema.PicklistEntry> controlEntries;
        if(control.getType() != Schema.DisplayType.Boolean) {
            controlEntries = control.getPicklistValues();
        }
        
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
            if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
                List<String> base64chars = String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                    Object controlValue =
                        (controlEntries == null
                         ?   (Object) (index == 1)
                         :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                    Integer bitIndex = index / 6;
                    if (bitIndex > base64chars.size() - 1) {
                        break;
                    }
                    Integer bitShift = 5 - Math.mod(index, 6);
                    if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                        continue;
                    if (!dependentPicklistValues.containsKey((String) controlValue)) {
                        dependentPicklistValues.put((String) controlValue, new List<String>());
                    }
                    dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
                }
            }
        }
        system.debug('Dependent :: ' + dependentPicklistValues);
        return dependentPicklistValues;
    }
    ///////////////////////////////////////
    
}