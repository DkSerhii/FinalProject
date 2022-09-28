trigger ContactTrigger on Contact (before insert, before update) {
    ContactTriggerHandler.handle(Trigger.new, Trigger.oldMap, Trigger.operationType);
}