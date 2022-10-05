public with sharing class ContactSelector {

    public static Contact selectTeacherByCurrentUser() {
        return [SELECT Group__c FROM Contact WHERE OwnerId = :UserInfo.getUserId() LIMIT 1];
    }

    public static List<Contact> selectKidsByGroup(String groupName) {
        RecordType kidRecordType = RecordTypeSelector.selectKid();
        return [
                SELECT Name, (SELECT Id, Kid_leave__c FROM Visits__r WHERE Visit_Date__c = TODAY LIMIT 1)
                FROM Contact
                WHERE Group__c = :groupName AND RecordTypeId = :kidRecordType.Id
        ];
    }
}