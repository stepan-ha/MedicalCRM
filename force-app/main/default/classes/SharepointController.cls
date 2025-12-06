
public with sharing class SharepointController {
     @AuraEnabled
    public static string authorize(){
        
        return GraphApiService.getToken();

    }
    @AuraEnabled
    public static SharepointItemsWrapper openFolder(String siteId, String driveId, String folderId) {

        //Set<String> restricktedItems = MemberServiceHelper.getRestricktedItems(folderId);

        SharepointItemsWrapper responce = GraphApiService.getItemsInFolder(siteId, driveId, folderId);

        List<SharepointItemsWrapper.cls_value> itemsToShow = new List<SharepointItemsWrapper.cls_value>();

        for(SharepointItemsWrapper.cls_value item : responce.value){

            //if(!restricktedItems.contains(item.id)){

                itemsToShow.add(item);

           // }

        }        

        System.debug('itemsToShow -->> ' + itemsToShow);
        System.debug('responce -->> ' + responce);
        responce.value = itemsToShow;

        return responce;

    }

    @AuraEnabled
    public static SharepointPreviewItemWrapper previewItem(String siteId, String driveId, String itemId, String token){
        
            return GraphApiService.previewItem(siteId, driveId, itemId, token);
        
    }

    @AuraEnabled
    public static Boolean moveItem(String siteId, String driveId, String itemId, String itemName, String folderId, String token){
       
        return GraphApiService.moveItem(siteId, driveId, itemId, itemName, folderId, token);
        
    }

    @AuraEnabled
    public static Boolean copyItem(String siteId, String driveId, String itemId, String itemName, String folderId, String token){
        
        return GraphApiService.copyItem(siteId, driveId, itemId, itemName, folderId, token);

    }

    @AuraEnabled
    public static SharepointItemsWrapper getItemsInDrive(String siteId, String driveId){
        
        return GraphApiService.getItemsInDrive(siteId, driveId);
        
    }

    @AuraEnabled
    public static string downloadFile(String downloadURL, String fileName, String recordId, Boolean createLink){
        
        Blob fileItm = GraphApiService.downloadFile(downloadURL);

        ContentVersion cv = new ContentVersion();
        cv.VersionData = fileItm;
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        insert cv;

        cv = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id=: cv.Id];
        if(createLink){
            insert new ContentDocumentLink(LinkedEntityId = recordId, ContentDocumentId = cv.ContentDocumentId);
        }

        return cv.ContentDocumentId;
    }

}