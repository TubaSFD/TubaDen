/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_SCL_WPRN_HealthDaysMeasura2ITrigger on SCL_WPRN_HealthDaysMeasurement__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(SCL_WPRN_HealthDaysMeasurement__c.SObjectType);
}