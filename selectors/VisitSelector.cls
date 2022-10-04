public with sharing class VisitSelector {

    public static List<Visit__c> selectTodayVisits(Map<Id, Visit__c> visitById) {
        return [
                SELECT Contact__c
                FROM Visit__c
                WHERE Contact__c = :visitById.keySet() AND Visit_Date__c = TODAY
        ];
    }
}