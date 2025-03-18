public class Mapping_CTRL {
    
    public map<string,integer> data {get;set;}
    
    public Mapping_CTRL(){
        data = new map<string,integer>();
        for(Account acc: [Select Id, Name, (Select Id, Name, Email from Contacts), Phone from Account]){
            integer count = data.get(acc.name);
            if(count != null)
                count++;
            else
                count = 1;
            data.put(acc.name, count);
        }
    }
}