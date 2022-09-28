public with sharing class GroupSelector {

    public static List<Group__c> getAllGroupsWithKids() {
        RecordType recordType = [SELECT Id FROM RecordType WHERE Name = 'Kid'];
        return [SELECT Id, (SELECT Id FROM Contacts__r WHERE RecordTypeId = :recordType.Id)
        FROM Group__c];
    }
}