public class DuplicateContactTestClass {
   
   public static testMethod void testContactDuplicateTrigger() {
		Contact existingContact = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'js@gmail.com');
		insert existingContact;
		
		Contact duplicateContact = new Contact(FirstName = 'John', LastName = 'Smith', Email = 'js@gmail.com');
		try {
		   insert duplicateContact;
		}
		catch (Exception e) {
		   System.debug('We want to see this.  This means the trigger is working.');
		} 
   }
}