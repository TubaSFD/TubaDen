/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_SCL_WPRN_HealthDaysMeasurementTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_SCL_WPRN_HealthDaysMeasura2ITrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new SCL_WPRN_HealthDaysMeasurement__c());
    }
}