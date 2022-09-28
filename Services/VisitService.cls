public class VisitService {

    public static void validateNotMoreThanOneVisit(List<Visit__c> visits) {
        Map<Id, Visit__c> visitById = new Map<Id, Visit__c>();

        for (Visit__c visit : visits) {
            visitById.put(visit.Contact__c, visit);
        }

        List<Visit__c> existingVisits = [
                SELECT Contact__c
                FROM Visit__c
                WHERE Contact__c = :visitById.keySet() AND Visit_Date__c = TODAY
        ];

        if (existingVisits != null) {
            for (Visit__c visit : existingVisits) {
                Visit__c visitError = visitById.get(visit.Contact__c);
                visitError.addError('Only one visit per day can exist');
            }
        }
    }
}