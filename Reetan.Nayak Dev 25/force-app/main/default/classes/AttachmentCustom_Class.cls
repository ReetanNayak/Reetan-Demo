public class AttachmentCustom_Class {

    public AttachmentCustom_Class(ApexPages.StandardController controller) {

    }

    Public Attachment myfile;

    Public Attachment getmyfile() {
        myfile = new Attachment();
        return myfile;
    }
   
    Public Pagereference SaveDoc(){
        String accid = System.currentPagereference().getParameters().get('id');

        Attachment a = new Attachment(parentId = accid, name=myfile.name, body = myfile.body);
         
         /* insert the attachment */
         insert a;
        return NULL;
    }   
}