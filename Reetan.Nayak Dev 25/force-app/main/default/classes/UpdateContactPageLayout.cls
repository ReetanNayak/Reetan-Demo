public class UpdateContactPageLayout {
    public Metadata.Layout addLayoutItem (){
        List<Metadata.Metadata> layoutsList  = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, 
            																new List<String> {'Contact-Contact Layout'});
        Metadata.Layout layoutMetadata = (Metadata.Layout) layoutsList.get(0);
        
        Metadata.LayoutSection contactLayoutSection  = null;
        
        for(Metadata.LayoutSection section : layoutMetadata.LayoutSections){
            if(section.label == 'Additional Information'){
               contactLayoutSection = section; 
                break;
            }
        }
        
        List<Metadata.LayoutColumn> contactColumns =  contactLayoutSection.layoutColumns ;
        List<Metadata.LayoutItem> contactLayoutItems  = contactColumns.get(0).layoutItems ;
        
        Metadata.LayoutItem newField  = new Metadata.LayoutItem();
        newField.behavior = Metadata.UiBehavior.Edit;
        newField.field = 'AMAPI__Apex_MD_API_Twitter_name__c';
        contactLayoutItems.add(newField);
        
        return layoutMetadata;
    }
}