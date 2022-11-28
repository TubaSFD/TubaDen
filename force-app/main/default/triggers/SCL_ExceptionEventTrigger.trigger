trigger SCL_ExceptionEventTrigger on SCL_ExceptionEvent__e (after insert) {
	new MetadataTriggerHandler().run();
}