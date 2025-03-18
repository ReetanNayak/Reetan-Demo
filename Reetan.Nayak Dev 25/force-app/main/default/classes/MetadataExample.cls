public class MetadataExample {
    
    public void updateMetadata() {
        Metadata.CustomMetadata customMetaData = new Metadata.CustomMetadata();
        customMetaData.fullName = 'MyNamespace__MyMetadataTypeName.MyMetadataRecordName';
        
        Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
         customField.field = 'customField__c';
        customField.value = 'New value';
        
        customMetadata.values.add(customField);
        Metadata.DeployContainer deployContainer = new Metadata.DeployContainer();
        deployContainer.addMetadata(customMetadata);
        
        Id asyncResultId = Metadata.Operations.enqueueDeployment(deployContainer,null);
    }
}