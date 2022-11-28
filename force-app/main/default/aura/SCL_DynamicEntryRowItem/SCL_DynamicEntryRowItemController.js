({
    doInit: function(component, event, helper) {
        var action = component.get("c.getCategory");
        var inputIndustry = component.find("InputCategory");
        var opts=[];
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            for(var i=0;i< a.getReturnValue().length;i++){
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            inputIndustry.set("v.options", opts);
                         
        });
        $A.enqueueAction(action); 
    },
    
    onCategoryChange: function(component, event, helper) {
        //get the value of select option
        var selectedCategory = component.find("InputCategory");
        //alert(selectedCategory.get("v.value"));
        helper.getTypeDependentPicklist(component, event, helper, selectedCategory)
    },
    
    AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
  
})