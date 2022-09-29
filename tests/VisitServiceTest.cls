@IsTest
private class VisitServiceTest {

    @IsTest
    private static void validateNotMoreThanOneVisit() {
        Contact kid = new Contact(LastName = 'kid');
        insert kid;
        insert new Visit__c(Contact__c = kid.Id);

        DmlException dmlError;

        Test.startTest();
        List<Visit__c> visits = new List<Visit__c>();
        for (Integer i = 0; i < 50; i++) {
            visits.add(new Visit__c(Contact__c = kid.Id));
        }

        try {
            insert visits;
        } catch (DmlException dmlException) {
            dmlError = dmlException;
        }
        Test.stopTest();

        System.assertNotEquals(null, dmlError, 'There should be DML Error');
    }
}