public class BusScheduleCache {
    private Cache.OrgPartition part;
    
    public BusScheduleCache() {
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.BusSchedule');
    }
    
    public void putSchedule(String busLine, Time[] schedule) {
        // Get partition
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.BusSchedule');
        
        // Add cache value to the partition. Usually, the value is obtained from a callout
        orgPart.put(busLine, schedule);
    }
    
    public Time[] getSchedule(String busLine) {
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.BusSchedule');
        Time[] listTimes = new Time[]{};
        Time[] listTimes1 = (Time[])orgPart.get('BusSchedule');
        if (listTimes1 == null) {
            listTimes.add(Time.newInstance(8, 0, 0, 0));
            listTimes.add(Time.newInstance(17, 0, 0, 0));
        } else {
            listTimes = listTimes1;
        }
        return listTimes;
    }
}