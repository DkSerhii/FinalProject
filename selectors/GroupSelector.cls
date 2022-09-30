public with sharing class GroupSelector {

    public static List<Group__c> getAllGroupsWithContacts(Id contactRecordType) {
        return [SELECT Id, (SELECT Id FROM Contacts__r WHERE RecordTypeId = :contactRecordType)
        FROM Group__c];
    }
}