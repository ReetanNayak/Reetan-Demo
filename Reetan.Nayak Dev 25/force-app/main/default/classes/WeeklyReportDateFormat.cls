/**
* @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
* @Date Original: 3 Dec 2013 Last Modified:
 * @Description: This controller is used to prepare the weeked date.
*/
global class WeeklyReportDateFormat{

    /**
    * @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
    * @Date Original: 3 Dec 2013 Last Modified:
    * @Description: This controller is used to prepare the weeked date for THIS week and return.
    **/
    WebService static String generateReportDateForThisWeek() {
        User usreDetails = [SELECT id, Sub_Region__c FROM User WHERE Id=:Userinfo.getUserId() LIMIT 1];
        String weeklyReportNameThisWk = null;// System.Label.Weekly_Report_Data_ID+weeklyReportNameThisWeek+System.Label.Weekly_Report_Date+dateFormat;
        if(usreDetails.Sub_Region__c ==  System.Label.Weekly_Report_Korea_User){
           date todayDate = date.today();
           date weekendDate = todayDate.toStartofWeek()+5;
           Integer day = weekendDate.day();
           Integer month = weekendDate.Month();
           Integer year = weekendDate.year();
           //String dateFormat = month+'/'+day+'/'+year; 
           String dateFormat = year+'. '+month+'. '+day; 
           weeklyReportNameThisWk = System.Label.Weekly_Report_Korea+System.Label.Weekly_Report_Date+dateFormat;
        }else if(usreDetails.Sub_Region__c == System.label.Weekly_Report_Subregion_Name){
           
            date todayDate = date.today();
            date weekendDate = todayDate.toStartofWeek()+5;
            Integer day = weekendDate.day();
            Integer month = weekendDate.Month();
            Integer year = weekendDate.year();
            String dateFormat = year+'/'+month+'/'+day;
            
            Date todayThisWeek = Date.Today();
            Date weekStartThisWeek = todayThisWeek.toStartofWeek()+1;
            Integer dayThisWeekFrom = weekStartThisWeek.Day();
            Integer monthThisWeekFrom = weekStartThisWeek.Month();
            Integer yearThisWeekFrom = weekStartThisWeek.Year();
            String startDateThisWeek = yearThisWeekFrom+'/'+monthThisWeekFrom+'/'+dayThisWeekFrom;
    
            Date weekEndThisWeek = todayThisWeek.toStartofWeek()+7;
            Integer dayThisWeekTo = weekEndThisWeek.Day();
            Integer monthThisWeekTo = weekEndThisWeek.Month();
            Integer yearThisWeekTo = weekEndThisWeek.Year();
            String endDateThisWeek = yearThisWeekTo+'/'+monthThisWeekTo+'/'+dayThisWeekTo;
    
            String weeklyReportNameThisWeek = System.Label.Weekly_Report_Name_Prefix+startDateThisWeek+ ' - ' +endDateThisWeek;
            weeklyReportNameThisWk = System.Label.Weekly_Report_Data_ID+weeklyReportNameThisWeek+System.Label.Weekly_Report_Date+dateFormat;
            return weeklyReportNameThisWk;
        }else{
          weeklyReportNameThisWk = System.Label.Weekly_Report_Korea;
        }
        return weeklyReportNameThisWk;
   }

    
    
   /**
    * @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
    * @Date Original: 3 Dec 2013 Last Modified:
    * @Description: This controller is used to prepare the weeked date for LAST week.
     **/
    WebService static String generateReportDateForLastWeek(){
        
        User usreDetails = [SELECT id, Sub_Region__c FROM User WHERE Id=:Userinfo.getUserId() LIMIT 1];
        String weeklyReportNameLastWk = null; // System.Label.Weekly_Report_Data_ID+weeklyReportNameLastWeek+System.Label.Weekly_Report_Date+dateFormat;
        if(usreDetails.Sub_Region__c == System.Label.Weekly_Report_Korea_User){
            date todayDate = date.today();
            date weekendDate = todayDate.toStartofWeek()-2;
            Integer day = weekendDate.day();
            Integer month = weekendDate.Month();
            Integer year = weekendDate.year();
            String dateFormat = year+'. '+month+'. '+day;
            weeklyReportNameLastWk = System.Label.Weekly_Report_Korea+System.Label.Weekly_Report_Date+dateFormat;
            return weeklyReportNameLastWk;
        }else if(usreDetails.Sub_Region__c == System.label.Weekly_Report_Subregion_Name){
            date todayDate = date.today();
            date weekendDate = todayDate.toStartofWeek()-2;
            Integer day = weekendDate.day();
            Integer month = weekendDate.Month();
            Integer year = weekendDate.year();
            String dateFormat = year+'/'+month+'/'+day;   
            
            Date todayLastWeek = Date.Today();
            Date weekStartLastWeek = todayLastWeek.toStartofWeek()-6;
            Integer dayLastWeekFrom = weekStartLastWeek.Day();
            Integer monthLastWeekFrom = weekStartLastWeek.Month();
            Integer yearLastWeekFrom = weekStartLastWeek.Year();
            String startDateLastWeek = yearLastWeekFrom+'/'+monthLastWeekFrom+'/'+dayLastWeekFrom;
    
            Date weekEndLastWeek = todayLastWeek.toStartofWeek();
            Integer dayLastWeekTo = weekEndLastWeek.Day();
            Integer monthLastWeekTo = weekEndLastWeek.Month();
            Integer yearLastWeekTo = weekEndLastWeek.Year();
            String endDateLastWeek = yearLastWeekTo+'/'+monthLastWeekTo+'/'+dayLastWeekTo;
            String weeklyReportNameLastWeek = System.Label.Weekly_Report_Name_Prefix+startDateLastWeek+ ' - ' +endDateLastWeek;
            weeklyReportNameLastWk = System.Label.Weekly_Report_Data_ID+weeklyReportNameLastWeek+System.Label.Weekly_Report_Date+dateFormat;
            return weeklyReportNameLastWk;
           
        }else{
            weeklyReportNameLastWk = System.Label.Weekly_Report_Korea;
        }
        return weeklyReportNameLastWk;
   }
     
    
    
   /**
    * @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
    * @Date Original: 3 Dec 2013 Last Modified:
    * @Description: This controller is used to prepare the weeked date for NEW week.
     **/
    WebService static String generateReportDateForNewWeek(){
        
        system.debug('Before..... ');
        
        User usreDetails = [SELECT id, Sub_Region__c FROM User WHERE Id=:Userinfo.getUserId() LIMIT 1];   
        system.debug('usreDetails ..... '+ usreDetails );
        
        String weeklyReportnameNewWk = null;
        if(usreDetails.Sub_Region__c == System.Label.Weekly_Report_Korea_User){
           system.debug('Sub_Region__c ..... '+ usreDetails.Sub_Region__c );
           
           weeklyReportnameNewWk = System.Label.Weekly_Report_Korea;
           system.debug('weeklyReportnameNewWk ..... '+ weeklyReportnameNewWk);
           
        }else if(usreDetails.Sub_Region__c == System.label.Weekly_Report_Subregion_Name){
            
            Date todayNewWeek = Date.Today();
            Date weekStartNewWeek = todayNewWeek.toStartofWeek()+1;
            Integer dayNewWeekFrom = weekStartNewWeek.Day();
            Integer monthNewWeekFrom = weekStartNewWeek.Month();
            Integer yearNewWeekFrom = weekStartNewWeek.Year();
            //String startDateNewWeek = monthNewWeekFrom+'/'+dayNewWeekFrom+'/'+yearNewWeekFrom;
            String startDateNewWeek = yearNewWeekFrom+'/'+monthNewWeekFrom+'/'+dayNewWeekFrom;
    
            Date weekEndNewWeek = todayNewWeek.toStartofWeek()+7;
            Integer dayNewWeekTo = weekEndNewWeek.Day();
            Integer monthNewWeekTo = weekEndNewWeek.Month();
            Integer yearNewWeekTo = weekEndNewWeek.Year();
            //String endDateLastWeek = monthNewWeekTo+'/'+dayNewWeekTo+'/'+yearNewWeekTo;
            String endDateLastWeek = yearNewWeekTo+'/'+monthNewWeekTo+'/'+dayNewWeekTo;
    
            String weeklyReportNameNewWeek = System.Label.Weekly_Report_Name_Prefix+startDateNewWeek+ ' - '+endDateLastWeek;
            weeklyReportnameNewWk = System.Label.Weekly_Report_Data_ID+weeklyReportNameNewWeek;
            return weeklyReportnameNewWk;
        }else{
            weeklyReportnameNewWk = System.Label.Weekly_Report_Korea;
        }
        return weeklyReportnameNewWk;
    }
    
    
   /**
    * @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
     * @Date Original: 3 Dec 2013 Last Modified:
    * @Description: This controller is used to prepare the weeked date for CUSTOM week.
    **/
    WebService static String generateReportDateForCustomWeek(){
        User usreDetails = [SELECT id, Sub_Region__c FROM User WHERE Id=:Userinfo.getUserId() LIMIT 1];
        String weeklyReportNameCustomWk = null; //System.Label.Weekly_Report_Date_Custom+weeklyReportNameCustomWeek+System.Label.Weekly_From_Date+''+System.Label.Weekly_To_Date+'';
        if(usreDetails.Sub_Region__c == System.Label.Weekly_Report_Korea_User){
           weeklyReportNameCustomWk = System.Label.Weekly_Report_Korea;
        } else if(usreDetails.Sub_Region__c == System.label.Weekly_Report_Subregion_Name){
            
            Date todayCustomWeek = Date.Today();
            Date weekStartCustomWeek = todayCustomWeek.toStartofWeek()+1;
            Integer dayCustomWeekFrom = weekStartCustomWeek.Day();
            Integer monthCustomWeekFrom = weekStartCustomWeek.Month();
            Integer yearCustomWeekFrom = weekStartCustomWeek.Year();
            String startDateCustomWeek = yearCustomWeekFrom+'/'+monthCustomWeekFrom+'/'+dayCustomWeekFrom;
    
            Date weekEndCustomWeek = todayCustomWeek.toStartofWeek()+7;
            Integer dayCustomWeekTo = weekEndCustomWeek.Day();
            Integer monthCustomWeekTo = weekEndCustomWeek.Month();
            Integer yearCustomWeekTo = weekEndCustomWeek.Year();
            String endDateCustomWeek = yearCustomWeekTo+'/'+monthCustomWeekTo+'/'+dayCustomWeekTo;
      
            String weeklyReportNameCustomWeek = System.Label.Weekly_Report_Name_Prefix+startDateCustomWeek +'~'+endDateCustomWeek ;
            weeklyReportNameCustomWk = System.Label.Weekly_Report_Date_Custom+weeklyReportNameCustomWeek+System.Label.Weekly_From_Date+startDateCustomWeek+System.Label.Weekly_To_Date+endDateCustomWeek;
            return weeklyReportNameCustomWk;
       }else{
          weeklyReportNameCustomWk = System.Label.Weekly_Report_Korea;
       }
       return weeklyReportNameCustomWk;
   }
   
   /**
    * @Author Original: Ranjeet Singh (502249731) Birlasoft/GEHC
    * @Date Original: 30 Jan 2014 Last Modified:
    * @Description: This method is used to Enable/Disable team report information. 
    **/
   WebService static void enableAndDisableTeamReport(string id){
       system.debug('Called Method.');
      Weekly_Report__c wr = [SELECT id, Comment_Edit__c FROM Weekly_Report__c WHERE id=:id];  
      if(wr.Comment_Edit__c)
         wr.Comment_Edit__c = false;
      else
        wr.Comment_Edit__c = true;
      update wr; 
   }

}