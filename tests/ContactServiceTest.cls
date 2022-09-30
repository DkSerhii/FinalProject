@IsTest
private class ContactServiceTest {

    @TestSetup
    private static void setup() {
        RecordType recTypeKid = [SELECT Id FROM RecordType WHERE Name = 'Kid'];
        RecordType recTypeTeacher = [SELECT Id FROM RecordType WHERE Name = 'Teacher'];
        Group__c groupWith22kids = new Group__c(Name = 'groupWith22kids');
        insert groupWith22kids;
        insert new Contact(LastName = 'Teacher', Group__c = groupWith22kids.Id, RecordTypeId = recTypeTeacher.Id);

        List<Contact> contacts = new List<Contact>();

        for (Integer i = 0; i < 72; i++) {
            if (i < 25) {
                Contact kid = new Contact(LastName = 'Kid' + i, RecordTypeId = recTypeKid.Id);
                contacts.add(kid);
            }
            if (i < 50) {
                Contact teacher = new Contact(LastName = 'Teacher' + i, RecordTypeId = recTypeTeacher.Id);
                contacts.add(teacher);
            } else {
                Contact kidWithGroup = new Contact(LastName = 'Kid' + i, Group__c = groupWith22kids.Id,
                        RecordTypeId = recTypeKid.Id);
                contacts.add(kidWithGroup);
            }
        }
        insert contacts;
    }

    @IsTest
    private static void validateDifferentParents() {
        RecordType recTypeKid = [SELECT Id FROM RecordType WHERE Name = 'Kid'];
        RecordType recordTypeParent = [SELECT Id FROM RecordType WHERE Name = 'Parent'];
        Contact parent = new Contact(LastName = 'parent', RecordTypeId = recordTypeParent.Id);
        insert parent;
        Contact kidToInsert = new Contact(LastName = 'Kid', First_Parent__c = parent.Id, RecordTypeId = recTypeKid.Id);
        Contact kidToUpdate = new Contact(LastName = 'Kid', First_Parent__c = parent.Id, RecordTypeId = recTypeKid.Id);
        insert kidToUpdate;

        DmlException dmlErrorInsert;
        DmlException dmlErrorUpdate;

        Test.startTest();

        kidToInsert.Second_Parent__c = parent.Id;
        try {
            insert kidToInsert;
        } catch (DmlException catchError) {
            dmlErrorInsert = catchError;
        }

        kidToUpdate.Second_Parent__c = parent.Id;
        try {
            update kidToUpdate;
        } catch (DmlException catchError) {
            dmlErrorUpdate = catchError;
        }
        Test.stopTest();

        System.assertNotEquals(null, dmlErrorInsert, 'There must be error');
        System.assertNotEquals(null, dmlErrorUpdate, 'There must be error');
    }

    @IsTest
    private static void checkGroupChange() {
        Group__c fullGroup = [SELECT Id FROM Group__c];
        List<DmlException> dmlErrors = new List<DmlException>();
        Integer contactCount = [SELECT Count() FROM Contact WHERE Group__c = NULL];

        Test.startTest();
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Group__c = NULL];
        for (Contact con : contacts) {
            con.Group__c = fullGroup.Id;
        }
        try {
            update contacts;
        } catch (DmlException dmlError) {
            dmlErrors.add(dmlError);
        }
        Test.stopTest();

        System.assertNotEquals(contactCount, dmlErrors.size(), 'There must be' + contactCount + 'errors');
    }

    @IsTest
    private static void checkGroupSize() {
        RecordType recTypeKid = [SELECT Id FROM RecordType WHERE Name = 'Kid'];
        RecordType recTypeTeacher = [SELECT Id FROM RecordType WHERE Name = 'Teacher'];
        Group__c groupWith22Kids = [SELECT Id From Group__c];

        List<Contact> contacts = new List<Contact>();
        List<DmlException> dmlErrors = new List<DmlException>();
        Integer recordsQuantity = 50;

        for (Integer i = 0; i < recordsQuantity; i++) {
            Contact con = new Contact(LastName = 'Contact' + i, Group__c = groupWith22Kids.Id);
            if (i < 25) {
                con.RecordTypeId = recTypeKid.Id;
            } else {
                con.RecordTypeId = recTypeTeacher.Id;
            }
            contacts.add(con);
        }

        Test.startTest();
        try {
            insert contacts;
        } catch (DmlException dmlError) {
            dmlErrors.add(dmlError);
        }
        Test.stopTest();

        System.assertNotEquals(recordsQuantity, dmlErrors.size(), 'There must be' + recordsQuantity + 'errors');
    }
}