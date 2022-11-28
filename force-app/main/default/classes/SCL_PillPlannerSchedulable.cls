//Story Number
//STY-00050
global class SCL_PillPlannerSchedulable implements Schedulable{
    
    global void execute(SchedulableContext sc)
    {
    SCL_PillPlannerAutoClose pillPlannerBatch = new SCL_PillPlannerAutoClose();
      database.executebatch(pillPlannerBatch, 100);
    } 

}