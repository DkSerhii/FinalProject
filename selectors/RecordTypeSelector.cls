public with sharing class RecordTypeSelector {

    public static RecordType selectKid() {
        return [SELECT Id FROM RecordType WHERE Name = 'Kid'];
    }

    public static RecordType selectTeacher() {
        return [SELECT Id FROM RecordType WHERE Name = 'Teacher'];
    }

    public static RecordType selectParent() {
        return [SELECT Id FROM RecordType WHERE Name = 'Parent'];
    }
}