trigger VisitTrigger on Visit__c (before insert) {
    VisitTriggerHandler.handle(Trigger.new, Trigger.operationType);
}