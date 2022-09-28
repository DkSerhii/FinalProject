public class VisitTriggerHandler {

    public static void handle(List<Visit__c> visits, System.TriggerOperation triggerOperation) {

        switch on triggerOperation {
            when BEFORE_INSERT {
                VisitService.validateNotMoreThanOneVisit(visits);
            }
        }
    }
}