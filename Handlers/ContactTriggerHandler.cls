public with sharing class ContactTriggerHandler {

    public static void handle(List<Contact> contacts, Map<Id, Contact> contactsByIds,
            System.TriggerOperation triggerOperation) {

        switch on triggerOperation {
            when BEFORE_INSERT {
                ContactService.validateDifferentParents(contacts);
                ContactService.validateGroupSize(contacts);
            }
            when BEFORE_UPDATE {
                ContactService.validateDifferentParents(contacts);
                ContactService.checkGroupChange(contacts, contactsByIds);
            }
        }
    }
}