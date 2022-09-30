public with sharing class ContactService {

    public static void validateDifferentParents(List<Contact> contacts) {
        for (Contact con : contacts) {
            if (con.First_Parent__c != null && con.Second_Parent__c != null) {
                checkParents(con);
            }
        }
    }

    public static void checkParents(Contact con) {
        if (con.First_Parent__c == con.Second_Parent__c) {
            con.addError('Parents should be different');
        }
    }

    public static void checkGroupChange(List<Contact> contacts, Map<Id, Contact> contactsByIds) {
        List<Contact> contactsToCheck = new List<Contact>();

        for (Contact newContact : contacts) {
            Contact oldContact = contactsByIds.get(newContact.Id);
            if (newContact.Group__c != oldContact.Group__c && newContact.Group__c != null) {
                contactsToCheck.add(newContact);
            }
        }

        if (!contactsToCheck.isEmpty()) {
            validateGroupSize(contactsToCheck);
        }
    }

    public static void validateGroupSize(List<Contact> contacts) {
        RecordType recTypeKid = [SELECT Id FROM RecordType WHERE Name = 'Kid'];
        RecordType recTypeTeacher = [SELECT Id FROM RecordType WHERE Name = 'Teacher'];
        List<Contact> kids = new List<Contact>();
        List<Contact> teachers = new List<Contact>();

        for (Contact con : contacts) {
            if (con.Group__c != null) {
                if (con.RecordTypeId == recTypeKid.Id) {
                    kids.add(con);
                }
                if (con.RecordTypeId == recTypeTeacher.Id) {
                    teachers.add(con);
                }
            }
        }
        if (!kids.isEmpty()) {
            String validateRule = 'Kids';
            Map<Id, Group__c> groupsByIds =
                    new Map<ID, Group__c>(GroupSelector.getAllGroupsWithContacts(recTypeKid.Id));
            checkGroupSize(kids, groupsByIds, validateRule);
        }
        if (!teachers.isEmpty()) {
            String validateRule = 'Teachers';
            Map<Id, Group__c> groupsByIds =
                    new Map<ID, Group__c>(GroupSelector.getAllGroupsWithContacts(recTypeTeacher.Id));
            checkGroupSize(kids, groupsByIds, validateRule);
        }
    }

    public static void checkGroupSize(List<Contact> contacts, Map<Id, Group__c> groupsByIds, String validateRule) {
        Map<Id, Integer> groupSizeById = new Map<Id, Integer>();

        for (Contact con : contacts) {
            Group__c contactsGroup = groupsByIds.get(con.Group__c);
            Integer groupSize = groupSizeById.get(contactsGroup.Id);

            if (groupSize == null) {
                groupSize = contactsGroup.Contacts__r.size();
                groupSize++;
                groupSizeById.put(contactsGroup.Id, groupSize);
                errorCheck(con, groupSize, validateRule);
            } else {
                groupSize++;
                groupSizeById.put(contactsGroup.Id, groupSize);
                errorCheck(con, groupSize, validateRule);
            }
        }
    }

    public static void errorCheck(Contact con, Integer groupSize, String validateRule) {
        if (validateRule == 'Kids') {
            if (groupSize > 22) {
                con.addError('Max size of group is 22 kids');
            }
        }
        if (validateRule == 'Teachers') {
            if (groupSize > 1) {
                con.addError('Only one teacher in group');
            }
        }
    }
}