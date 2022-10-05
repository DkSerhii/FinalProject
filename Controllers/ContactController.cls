public class ContactController {

    @AuraEnabled(Cacheable=true)
    public static List<Contact> getKidsByTeacherId() {
        Contact teacher = ContactSelector.selectTeacherByCurrentUser();

        return ContactSelector.selectKidsByGroup(teacher.Group__c);
    }
}