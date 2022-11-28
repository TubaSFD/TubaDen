({
 
    // function call on component Load
    doInit: function(component, event, helper) {

        helper.createObjectData(component, event);
    },
 
    // function for save the Records 
    Save: function(component, event, helper) {
        // first call the helper function in if block which will return true or false.
        // this helper function check the "first Name" will not be blank on each row.
        if (helper.validateRequired(component, event)) {

            var action = component.get("c.saveEntries");
            action.setParams({
                entryList: component.get("v.entryList"),
                recordId: component.get("v.recordId")
            });
            // set call back 
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if (state === "SUCCESS") {

                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "Success!",
                        "message": "Entries has been created successfully."
                    });
                    resultsToast.fire(); 
                    
                	var dismissActionPanel = $A.get("e.force:closeQuickAction");
        			dismissActionPanel.fire();

                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
    },
 
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        helper.createObjectData(component, event);
    },
 
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList = component.get("v.entryList");
        AllRowsList.splice(index, 1);
        component.set("v.entryList", AllRowsList);
    },
})