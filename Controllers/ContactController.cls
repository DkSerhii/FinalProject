public class ContactController {

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getKidsByTeacherId() {
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Kid').getRecordTypeId();
        Contact teacher = [SELECT Group__c FROM Contact WHERE OwnerId = :UserInfo.getUserId() LIMIT 1];

        return [
                SELECT Name, (SELECT Id, Kid_leave__c FROM Visits__r WHERE Visit_Date__c = TODAY LIMIT 1)
                FROM Contact
                WHERE Group__c = :teacher.Group__c AND RecordTypeId = :recordTypeId
        ];
    }
}