({    
    doInit : function(component, event, helper) {
        var action = component.get("c.getDescription");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var textForCopy = response.getReturnValue();
                helper.copyTextHelper(component,event,textForCopy);
            }
        });
        $A.enqueueAction(action);      
    },    
    doneRendering: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    }
})