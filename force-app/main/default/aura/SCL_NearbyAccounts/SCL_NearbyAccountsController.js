({
    
    fetchAccounts : function(component, event, helper) {
        console.log('============ fetchAccounts ============');
        component.set('v.mycolumns', [
            {label: 'Account Name', fieldName: 'linkName', type: 'url', sortable:true,
            typeAttributes: {label: { fieldName: 'name' }, target: '_blank'}},
            {label: 'Type', fieldName: 'accountType', type: 'Text', sortable:true},
            {label: 'Tier', fieldName: 'accountTier', type: 'Text', sortable:true},
            {label: 'Physical Street', fieldName: 'maplinkName', type: 'url', sortable:true, 
                typeAttributes: {label: { fieldName: 'shippingStreet' }, target: '_blank'}},
            // {label: 'Street', fieldName: 'shippingStreet', type: 'text'},
            {label: 'Physical City', fieldName: 'shippingCity', type: 'Text', sortable:true},
            {label: 'Distance(Miles)', fieldName: 'distance', type: 'number', cellAttributes: { alignment: 'center' }, sortable:true}
        ]);
        var action = component.get("c.getAccounts");
        action.setParams({recordId:component.get("v.recordId")});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var records =response.getReturnValue();
                records.forEach( function( record){
                    record.linkName = '/' + record.AccId;
                    // Replace special characters within account name with spaces for google search
                    record.charsafename = record.name.replace('/',' ').replace('(',' ').replace(')',' ').replace('&',' ');
                    console.log('record.charsafename: ' + record.charsafename);
                    //  record.charsafename + ' ' + 
                    record.maplinkName = 'https://google.com/maps/search/' + record.shippingStreet + ' ' + record.shippingCity;
                    console.log('JSON.stringify(record): ' + JSON.stringify(record));
                    console.log('record.maplinkName: ' + record.maplinkName);
                });
                component.set("v.acctList", records);
                helper.sortData(component, component.get("v.sortedBy"), component.get("v.sortedDirection"));
            }
        });
        $A.enqueueAction(action);
    },

    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
        
    navigate: function(cmp, event, helper) {
        console.log('event.target: ' + event.target);
        console.log('event.target.href: ' + event.target.href);
        const urlString = event.target.href;
        var urlEvent = $A.get("e.force:navigateToURL");
        console.log('urlEvent: ' + urlEvent);
        urlEvent.setParams({
            "url": urlString
        });
        urlEvent.fire();
    }

})