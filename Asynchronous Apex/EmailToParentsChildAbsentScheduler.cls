public class EmailToParentsChildAbsentScheduler implements Schedulable{
    public static String everyWeekday = '0 0 20 ? * MON,TUE,WED,THU,FRI *';

    public void execute(SchedulableContext sc) {
        Map<String, Object> params = new Map<String, Object>();
        Flow.Interview.Send_Email_To_Parent_When_Child_was_absent sendEmailFlow =
                new Flow.Interview.Send_Email_To_Parent_When_Child_was_absent(params);
        sendEmailFlow.start();
    }

    public void scheduleJobWeekday() {
        EmailToParentsChildAbsentScheduler scheduledJob = new EmailToParentsChildAbsentScheduler();
        System.schedule('EmailToParentsChildAbsentScheduler - every weekday at 20:00',
                everyWeekday, scheduledJob);
    }
}