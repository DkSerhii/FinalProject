public class VisitController {

    @AuraEnabled
    public static void createVisitByKidId(Id kidId) {
        insert new Visit__c(Contact__c = kidId, Visit_Date__c = Date.today(), Kid_arrive__c = currentTime());
    }

    @AuraEnabled
    public static void updateKidLeft(Id kidId) {
        Visit__c visit = [SELECT Id FROM Visit__c WHERE Visit_Date__c = TODAY AND Contact__c = :kidId];
        if (visit != null) {
            visit.Kid_leave__c = currentTime();
            update visit;
        }
    }

    private static Time currentTime() {
        Datetime formattedDate = Datetime.now().addSeconds((UserInfo.getTimeZone().getOffset(Datetime.now())/1000));
        return Time.newInstance(formattedDate.hour(), formattedDate.minute(), formattedDate.second(), 0);
    }
}