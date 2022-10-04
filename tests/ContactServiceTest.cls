@IsTest
private class ContactServiceTest {
    private static RecordType recTypeKid = RecordTypeSelector.selectKid();
    private static RecordType recTypeTeacher = RecordTypeSelector.selectTeacher();
    private static RecordType recTypeParent = RecordTypeSelector.selectParent();

    @TestSetup
    private static void setup() {
        List<Contact> contacts = new List<Contact>();
        Group__c groupWith22kids = new Group__c(Name = 'groupWith22kids');
        insert groupWith22kids;
        insert new Contact(LastName = 'Teacher', Group__c = groupWith22kids.Id, RecordTypeId = recTypeTeacher.Id);


        for (Integer i = 0; i < 72; i++) {
            if (i < 50) {
                Contact kidWithoutGroup = new Contact(LastName = 'Kid' + i, RecordTypeId = recTypeKid.Id);
                contacts.add(kidWithoutGroup);
                Contact teacherWithoutGroup = new Contact(LastName = 'Teacher' + i, RecordTypeId = recTypeTeacher.Id);
                contacts.add(teacherWithoutGroup);
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
        Contact parent = new Contact(LastName = 'parent', RecordTypeId = recTypeParent.Id);
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
    private static void insertKidsWhenFullGroup() {
        Group__c fullGroup = [SELECT Id FROM Group__c];
        DmlException insertError;

        List<Contact> kids = new List<Contact>();
        Integer recordsQuantity = 50;

        Test.startTest();
        for (Integer i = 0; i < recordsQuantity; i++) {
            kids.add(new Contact(LastName = 'kid' + i, RecordTypeId = recTypeKid.Id, Group__c = fullGroup.Id));
        }
        try {
            insert kids;
        } catch (DmlException dmlError) {
            insertError = dmlError;
        }
        Test.stopTest();

        System.assertNotEquals(null, insertError, 'There should be an error');
    }

    @IsTest
    private static void updateKidsWhenFullGroup() {
        Group__c fullGroup = [SELECT Id FROM Group__c];
        DmlException updateError;

        List<Contact> kidsWithoutGroup = [
                SELECT Id
                FROM Contact
                WHERE RecordTypeId = :recTypeKid.Id
                AND Group__c = NULL
        ];
        List<Contact> kidsWithGroup = new List<Contact>();

        Test.startTest();
        for (Contact con : kidsWithoutGroup) {
            con.Group__c = fullGroup.Id;
            kidsWithGroup.add(con);
        }
        try {
            update kidsWithGroup;
        } catch (DmlException dmlError) {
            updateError = dmlError;
        }
        Test.stopTest();

        System.assertNotEquals(null, updateError, 'There should be an error');
    }

    @IsTest
    private static void insertTeachersWhenFullGroup() {
        Group__c fullGroup = [SELECT Id FROM Group__c];
        DmlException insertError;

        List<Contact> kids = new List<Contact>();
        Integer recordsQuantity = 50;

        Test.startTest();
        for (Integer i = 0; i < recordsQuantity; i++) {
            kids.add(new Contact(LastName = 'kid' + i, RecordTypeId = recTypeTeacher.Id, Group__c = fullGroup.Id));
        }
        try {
            insert kids;
        } catch (DmlException dmlError) {
            insertError = dmlError;
        }
        Test.stopTest();

        System.assertNotEquals(null, insertError, 'There should be an error');
    }

    @IsTest
    private static void updateTeachersWhenFullGroup() {
        Group__c fullGroup = [SELECT Id FROM Group__c];
        DmlException updateError;

        List<Contact> kidsWithoutGroup = [
                SELECT Id
                FROM Contact
                WHERE RecordTypeId = :recTypeTeacher.Id
                AND Group__c = NULL
        ];
        List<Contact> kidsWithGroup = new List<Contact>();

        Test.startTest();
        for (Contact con : kidsWithoutGroup) {
            con.Group__c = fullGroup.Id;
            kidsWithGroup.add(con);
        }
        try {
            update kidsWithGroup;
        } catch (DmlException dmlError) {
            updateError = dmlError;
        }
        Test.stopTest();

        System.assertNotEquals(null, updateError, 'There should be an error');
    }
}