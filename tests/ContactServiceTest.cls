@IsTest
private class ContactServiceTest {

    @TestSetup
    private static void setup() {
        Group__c groupWith22kids = new Group__c(Name = 'groupWith22kids');
        insert groupWith22kids;

        List<Contact> kidsWithGroup = new List<Contact>();
        for (Integer i = 0; i < 22; i++) {
            Contact kid = new Contact(LastName = 'kid' + i, Group__c = groupWith22kids.Id);
            kidsWithGroup.add(kid);
        }
        insert kidsWithGroup;

        List<Contact> kidsWithoutGroup = new List<Contact>();
        for (Integer i = 0; i < 30; i++) {
            Contact kid = new Contact(LastName = 'kid' + i);
            kidsWithoutGroup.add(kid);
        }
        insert kidsWithoutGroup;
    }

    @IsTest
    private static void validateDifferentParents() {
        RecordType recordTypeParent = [SELECT Id FROM RecordType WHERE Name = 'Parent'];
        Contact parent = new Contact(LastName = 'parent', RecordTypeId = recordTypeParent.Id);
        insert parent;
        Contact kidToInsert = new Contact(LastName = 'kid', First_Parent__c = parent.Id);
        Contact kidToUpdate = new Contact(LastName = 'kid', First_Parent__c = parent.Id);
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

        System.assertNotEquals(null, dmlErrorInsert, 'There should be error');
        System.assertNotEquals(null, dmlErrorUpdate, 'There should be error');
    }

    @IsTest
    private static void checkGroupChange() {
        Group__c groupWith22kids = [SELECT Id FROM Group__c];
        List<DmlException> dmlErrors = new List<DmlException>();

        Test.startTest();
        List<Contact> kids = [SELECT Id FROM Contact WHERE Group__c = NULL LIMIT 30];
        for (Contact kid : kids) {
            kid.Group__c = groupWith22kids.Id;
        }
        try {
            update kids;
        } catch (DmlException dmlError) {
            dmlErrors.add(dmlError);
        }
        Test.stopTest();

        System.assertNotEquals(30, dmlErrors.size(), 'There should be 30 errors');
    }

    @IsTest
    private static void checkGroupSize() {
        Group__c groupWith22Kids = [SELECT Id From Group__c];
        List<Contact> kids = new List<Contact>();
        List<DmlException> dmlErrors = new List<DmlException>();

        for (Integer i = 0; i < 30; i++) {
            Contact kid = new Contact(LastName = 'kid' + i, Group__c = groupWith22Kids.Id);
            kids.add(kid);
        }

        Test.startTest();
        try {
            insert kids;
        } catch (DmlException dmlError) {
            dmlErrors.add(dmlError);
        }
        Test.stopTest();

        System.assertNotEquals(30, dmlErrors.size(), 'There should be 30 errors');
    }
}