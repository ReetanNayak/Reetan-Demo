public class Day_CAL_CLS {

    public List<String> calTiming{get;set;}
    public Event Events {get; set;}
    public String starttime{get;set;}
    public String endtime{get;set;}

    public Day_CAL_CLS(){
        calTiming = new List<String>();
        Events = new Event();
        calTiming.add('12:00 AM');
        for(Integer i=1;i<24;i++){
            if(i < 12)               
                calTiming.add(i+':00'+' AM');
            else if(i==12)
                calTiming.add(i+':00'+' PM');
            else 
                calTiming.add(i-12+':00'+' PM');
        }
    }
    
      public List<SelectOption> getTimeFormatHour(){
        List<SelectOption> options = new List<SelectOption>();         
        options.add(new SelectOption('', '--Select--'));         
        for(Integer s=0;s<2;s++){
        Integer hh=0;
             for(Integer i=0;i<24;i++){
                  String tm='';
                  Integer mm=i/2;
                  Integer rem=i-mm*2;
                  if(i<20){
                           if(rem==0){
                                  String j='0'+String.valueOf(hh);
                                  String p='00';
                                  tm=j+':'+p;
                                 
                            }else{
                                  String j='0'+String.valueOf(hh);
                                  String p='30';
                                  tm=j+':'+p;
                                  hh=hh+1;  
                           }  
                  }else{
                        
                        if(rem==0){
                                  String j=String.valueOf(hh);
                                  String p='00';
                                  tm=j+':'+p;
                        }else{
                              String j=String.valueOf(hh);
                              String p='30';
                              tm=j+':'+p;
                              hh=hh+1;  
                       }
                  }
                if(s==0) 
                    options.add(new  SelectOption(tm+' AM',tm+' AM'));
                else if(s==1 && i==0){
                    tm='12:00';
                    options.add(new  SelectOption(tm+' PM',tm+' PM'));
                }else if(s==1 && i==1){
                    tm='12:30';
                    options.add(new  SelectOption(tm+' PM',tm+' PM')); 
                }else 
                    options.add(new  SelectOption(tm+' PM',tm+' PM')); 
             }      
        }
            System.debug('option return is..........'+options);
       return options; 
    }
    
    public void createEvent(){
        try{
            Datetime dts = DateTime.parse('4/23/2012 '+''+ starttime);
            Datetime dte = DateTime.parse('4/23/2012 '+''+ endtime);
            Events.StartDateTime=dts;
            Events.EndDateTime=dte;
            Insert Events;
        }catch(Exception e){}
    }
}