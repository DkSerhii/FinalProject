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
        Map<Id, Group__c> groupsByIds = new Map<ID, Group__c>(GroupSelector.getAllGroupsWithKids());
        Map<Id, Integer> groupSizeById = new Map<Id, Integer>();

        for (Contact newContact : contacts) {
            Contact oldContact = contactsByIds.get(newContact.Id);

            if (newContact.Group__c != oldContact.Group__c && newContact.Group__c != null) {
                Group__c contactsGroup = groupsByIds.get(newContact.Group__c);
                Integer groupSize = groupSizeById.get(contactsGroup.Id);

                if (groupSize == null) {
                    groupSize = contactsGroup.Contacts__r.size();
                    groupSize++;
                    groupSizeById.put(contactsGroup.Id, groupSize);
                    validateGroupSize(newContact, groupSize);
                } else {
                    groupSize++;
                    groupSizeById.put(contactsGroup.Id, groupSize);
                    validateGroupSize(newContact, groupSize);
                }
            }
        }
    }

    public static void checkGroupSize(List<Contact> contacts) {
        Map<Id, Group__c> groupsByIds = new Map<ID, Group__c>(GroupSelector.getAllGroupsWithKids());
        Map<Id, Integer> groupSizeById = new Map<Id, Integer>();

        for (Contact con : contacts) {
            if (con.Group__c != null) {
                Group__c contactsGroup = groupsByIds.get(con.Group__c);
                Integer groupSize = groupSizeById.get(contactsGroup.Id);

                if (groupSize == null) {
                    groupSize = contactsGroup.Contacts__r.size();
                    groupSize++;
                    groupSizeById.put(contactsGroup.Id, groupSize);
                    validateGroupSize(con, groupSize);
                } else {
                    groupSize++;
                    groupSizeById.put(contactsGroup.Id, groupSize);
                    validateGroupSize(con, groupSize);
                }
            }
        }
    }

    public static void validateGroupSize(Contact con, Integer groupSize) {
        if (groupSize > 22) {
            con.addError('Max size of group is 22 kids');
        }
    }
}