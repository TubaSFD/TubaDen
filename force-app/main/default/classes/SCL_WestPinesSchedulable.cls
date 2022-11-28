//Story Number
//STY-00058
global class SCL_WestPinesSchedulable implements Schedulable{
    global void execute(SchedulableContext sc)
    {
      SCL_WestPinesAutoClose westPinesBatch = new SCL_WestPinesAutoClose();
      database.executebatch(westPinesBatch, 100);
    } 

}