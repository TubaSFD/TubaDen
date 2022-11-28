({
	getTypeDependentPicklist : function(component, event, helper, selectedCategory) {
        var action = component.get("c.getDependentPicklistValues");
        var inputType = component.find("InputType");
        var opts=[];
        
        action.setParams({ 
            dependentPicklistLabel : 'Type' 
        });
        
        action.setCallback(this, function(a) {
            var typeMap = a.getReturnValue();
            //alert(JSON.stringify(typeMap[selectedCategory.get("v.value")]));
            var typeList = [];
            //alert('length ++ ' + typeMap[selectedCategory.get("v.value")].length);
            
            if(typeMap[selectedCategory.get("v.value")] != undefined){
                for(var i = 0; i < typeMap[selectedCategory.get("v.value")].length; i++){
                    typeList.push(typeMap[selectedCategory.get("v.value")][i]);
                }
            }
            
            //typeList.push(typeMap[selectedCategory.get("v.value")]);
           if(typeList != undefined){
                for(var i=0;i< typeList.length;i++){
                    opts.push({"class": "optionClass", label: typeList[i], value: typeList[i]});
                }
           }
            inputType.set("v.options", opts);
        });
        $A.enqueueAction(action); 
	}
})