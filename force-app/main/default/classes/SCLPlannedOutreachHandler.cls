public with sharing class SCLPlannedOutreachHandler {
/*
//public with sharing class SCLPlannedOutreachHandler implements SCLInterfaceTrigger {
    
    List<SCL_PlannedOutreach__c> newTrigger = Trigger.New;
    static SCL_PlannedOutreachEventService poes;
    static {
        poes = null;
    }

    public SCLPlannedOutreachHandler() {
    }
    
    public void bulkBefore() {
        if (newTrigger == null) return;

        if (newTrigger.size() == 1) {
            //  One-at-a-time so handle it as UI so it is sycnhronous with SAVE data pipeline
            poes = new SCL_PlannedOutreachEventService();
            poes.PlannedOutreachBusinessRules(newTrigger[0]);
            System.debug('bulkBefore:  poes = [' + poes + ']');
        }
    }
    
    public void bulkAfter() 
    {
        if (newTrigger == null) return;
        
        List<SCL_PlannedOutreachEvent__e> poList = new List<SCL_PlannedOutreachEvent__e>();    	
        if (newTrigger.size() > 1) {
            // Event Bus execution is asynchronous to the SAVE data pipeline (process on the event bus for bulk loads only)
            List <SCL_PlannedOutreachEvent__e > poeList = new List <SCL_PlannedOutreachEvent__e >();
            for (SCL_PlannedOutreach__c po : newTrigger) {            
                SCL_PlannedOutreachEvent__e  poe = new SCL_PlannedOutreachEvent__e ();
                poe.SCL_PlannedOutreachID__c = po.Id;
                poeList.add(poe);
            }                    
            if (poeList.size() > 0) Eventbus.publish(poeList);
        } else {
            System.debug('bulkAfter:  poes = [' + poes + ']');
            if (poes != null && poes.newCase != null) {
                insert poes.newCase;
            }
        }
    }
        
    public void beforeInsert(SObject so)
    {
    }
    
    public void beforeUpdate(SObject oldSo, SObject so)
    {   
    }
    
    public void beforeDelete(SObject so)
    {   
    }
    
    public void afterInsert(SObject so)
    {
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {                  
    }
    
    public void afterDelete(SObject so)
    {
    }
    
    public void andFinally() 
    {
    }
*/
}