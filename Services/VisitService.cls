public class VisitService {

    public static void validateNotMoreThanOneVisit(List<Visit__c> visits) {
        Map<Id, Visit__c> visitById = new Map<Id, Visit__c>();

        for (Visit__c visit : visits) {
            visitById.put(visit.Contact__c, visit);
        }

        List<Visit__c> existingVisits = VisitSelector.selectTodayVisits(visitById);

        if (existingVisits != null) {
            for (Visit__c visit : existingVisits) {
                Visit__c visitError = visitById.get(visit.Contact__c);
                visitError.addError('Only one visit per day can exist');
            }
        }
    }
}