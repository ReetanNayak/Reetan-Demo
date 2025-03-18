public class DatePage_CTRL {
    Private Date startDate = date.newInstance(0001, 1, 1);
    Public Date selectedDate{get;set;}
    public String dayValue{get;set;}
    public Account acc {get;set;}
    
    public DatePage_CTRL() {
        selectedDate = date.today();
        acc = new Account();
    }

    public void calculateDayOfDate() {
        List<String> listDay = new List<String>{'Saturday' , 'Sunday' , 'Monday' , 'Tuesday' , 'Wednesday' , 'Thursday' , 'Friday'};
        selectedDate = acc.SLAExpirationDate__c;
        Integer remainder = Math.mod(startDate.daysBetween(selectedDate) , 7);
        dayValue = listDay.get(remainder);
    }



}