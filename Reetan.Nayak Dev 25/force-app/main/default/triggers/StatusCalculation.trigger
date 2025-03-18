trigger StatusCalculation on Batch__c (After Insert,Before delete){
     if(Trigger.isAfter){
        if(Trigger.isInsert){
            double tottime = 0.0;
            Batch__c batRec=Trigger.new[0];          
            Batch__c bat=[select Id,Name,CourseId__c,Total_Hours__c,Time_Diff__c,Start_Date__c,Status__c,Session_Det__c,Start_Time__c,End_Time__c from Batch__c where Id=:batRec.Id Limit 1];
            Integer No_Of_Periods;
            Double timeDiff;
            Integer shour=integer.valueOf(bat.Start_Time__c.split(':')[0]);
            String smin=bat.Start_Time__c.split(':')[1];
            Integer ehour=integer.valueOf(bat.End_Time__c.split(':')[0]);
            String emin=bat.End_Time__c.split(':')[1];
             
            if(shour < ehour ){
                if(smin.subString(0,2) == emin.subString(0,2))
                    timeDiff=ehour-shour;    
                else 
                    if(smin.subString(0,2) == '00' && emin.subString(0,2) == '30')
                        timeDiff=(ehour-shour) + .50;
                    else
                        if(smin.subString(0,2) == '30' && emin.subString(0,2) == '00')
                            timeDiff=(ehour-shour) - .50;     
            }else
                if(smin.subString(0,2) ==  emin.subString(0,2) )
                    timeDiff=(12+ehour)-shour;
                else       
                    if(smin.subString(0,2) == '00' && emin.subString(0,2) == '30')
                            timeDiff=((12+ehour)-shour) + .50;
                    else
                        if(smin.subString(0,2) == '30' && emin.subString(0,2) == '00')
                            timeDiff=((12+ehour)-shour) - .50;
            System.debug('Diff..............is...'+timeDiff);
            
            //calculate No Of Periods for Batch
            
            No_Of_Periods = Integer.valueOf(tottime/timeDiff);
            Integer val1=No_Of_Periods/5;
            Integer RemPeriod=No_Of_Periods-val1*5;
            Integer addWeekend=bat.Start_Date__c.toStartOfWeek().daysBetween(bat.Start_Date__c);
            
            //calculate for Including weekend.. 
            if(bat.Session_Det__c == 'Include Weekend'){
                bat.End_Date__c = bat.Start_Date__c.addDays(No_Of_Periods-1);
             }
            //calculate for Excluding weekend.. 
            if(bat.Session_Det__c == 'Exclude Weekend'){
                if(5-addWeekend < RemPeriod)
                    bat.End_Date__c = bat.Start_Date__c.addDays(No_Of_Periods+val1*3-1);
                else
                    bat.End_Date__c = bat.Start_Date__c.addDays(No_Of_Periods+val1*2-1);
            }
            //calculate for only weekend..
            if(bat.Session_Det__c == 'Only Weekend'){
                Integer remdWeek= No_Of_Periods-2*(No_Of_Periods/2);
                if(remdWeek == 1)
                    bat.End_Date__c = bat.Start_Date__c.addDays(7*(No_Of_Periods/2));
                    
                if(bat.Start_Date__c.toStartOfWeek().daysBetween(bat.Start_Date__c) == 6 && remdWeek == 0)
                    bat.End_Date__c = bat.Start_Date__c.addDays(7*(No_Of_Periods/2 - 1)+1);
                    
                if(bat.Start_Date__c.toStartOfWeek().daysBetween(bat.Start_Date__c) == 7 && remdWeek == 0)
                    bat.End_Date__c = bat.Start_Date__c.addDays(7*(No_Of_Periods/2) -1 );
                         
            }
           
            try{
                List<Session__c> ssList=[Select Id,Name,Session_Name__c,Session_Type__c,Duration_In_Hour__c from Session__c where CourseId__c=:bat.CourseId__c  limit 50]; 
                Course__c crs=[select Id,Name from Course__c where Id=:bat.CourseId__c];    
                List<SessionEntry__c> sEntryList=new  List<SessionEntry__c>();
                for(Session__c ss:ssList){
                    sEntryList.add(new SessionEntry__c(
                                   Session_Name__c=ss.Session_Name__c,
                                   Session_Type__c=ss.Session_Type__c,
                                   Batch__c=bat.Id,
                                   Start_Time__c=bat.Start_Time__c,
                                   End_Time__c=bat.End_Time__c,
                                   Course_Name__c=crs.Name,
                                   Status__C='Not Started'));
                }
                bat.Total_Hours__c=tottime;
                bat.Time_Diff__c= timeDiff; 
                bat.Status__C='Not Started';
                upsert bat;
                Insert sEntryList;
            }catch(Exception e){}
         }  
        
    }
     
 }