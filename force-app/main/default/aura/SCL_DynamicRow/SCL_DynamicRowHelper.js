({
    createObjectData: function(component, event) {
        var RowItemList = component.get("v.entryList");
        RowItemList.push({
            'sobjectType': 'SCL_Entry__c',
            'SCL_Category__c': '',
            'SCL_Type__c': '',
            'SCL_Amount__c': '',
            'SCL_Frequency__c':'',
            'SCL_RelatedDate__c': '',
            'SCL_Notes__c': ''
        });
        
        component.set("v.entryList", RowItemList);
    },
    
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var allContactRows = component.get("v.entryList");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].SCL_Category__c === '' || allContactRows[indexVar].SCL_Category__c === '--None--') {
                isValid = false;
                //alert('Category Can\'t be Blank on Row Number ' + (indexVar + 1));
            }
        }
        if(!isValid){
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams({
                "type":"error",
                "title": "Error!",
                "message": "Please select category"                        
            });
            resultsToast.fire();
        }
        return isValid;
    },
})