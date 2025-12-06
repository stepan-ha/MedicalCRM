public with sharing class GraphApiService {


    static final String NAMED_CRED = 'Graph_API';

    private final static  String BASE_URL {
        get{return /*Sharepoint_graph_api_settings__mdt.getInstance('Graph_Api_Setup').Base_URL__c*/'callout:Graph_API/';} set;
    }

    private final static  String SITE_URL {
        get{return /*Sharepoint_graph_api_settings__mdt.getInstance('Graph_Api_Setup').Site_URL__c*/'sites/{siteId}/';} set;
    }

    private final static  String DRIVE_URL{
        get{return /*Sharepoint_graph_api_settings__mdt.getInstance('Graph_Api_Setup').Drive_URL__c*/'drives/{driveId}/';} set;
    } 
    
    private final static  String ITEM_URL {
        get{return /*Sharepoint_graph_api_settings__mdt.getInstance('Graph_Api_Setup').Item_URL__c*/'items/{itemId}';} set;
    }

    private final static String ROOT_URL {
        get{return /*Sharepoint_graph_api_settings__mdt.getInstance('Graph_Api_Setup').Root_URL__c*/'drive/root/children';} set;
    }
    
    public static String getListItemId(String siteId, String driveId, String itemId, String token){
        try{

            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId)+'?expand=listItem');
            System.debug(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId)+'?expand=listItem');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Accept', '*/*');
            if(Test.isRunningTest()){
                req.setHeader('Test', 'getListItemId');
            }
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while getting the itemListInfo (GraphApiService.getItemsInFolder)\n' + res.getBody(), res.getStatusCode());
            }

            return SharepointItemExtendedWrapper.parse(res.getBody()).listItem.id;
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public static String getToken(){

        try{

            Http http = new Http();
    
            HttpRequest tokenRequest = new HttpRequest();
            
            tokenRequest.setEndpoint('callout:' + NAMED_CRED + '/oauth2/token');
            tokenRequest.setMethod('POST');
            tokenRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            String params = '';
    
            tokenRequest.setBody(params);

            tokenRequest.setTimeout(80000);
    
            HttpResponse response = http.send(tokenRequest);
            
            if(!(response.getStatusCode()<300)){
                throw new RestApiException('Error while obtaining the token (GraphApiService.getToken)\n' + response.getBody(), response.getStatusCode());
            }
            
            Map<String, Object> responceMap = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
    
            System.debug(String.valueOf(responceMap.get('access_token')));

    
            return String.valueOf(responceMap.get('access_token'));
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }


    public static SharepointItemsWrapper getItemsInFolder(String siteId, String driveId, String folderId){

        try{

            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', folderId)+'/children?expand=listItem');
            System.debug(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', folderId)+'/children?expand=listItem');
            req.setHeader('Accept', '*/*');
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while getting the items (GraphApiService.getItemsInFolder)\n' + res.getBody(), res.getStatusCode());
            }

            return SharepointItemsWrapper.parse(res.getBody());
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public static SharepointItemsWrapper getItemsInDrive(String siteId, String driveId){

        try{

            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + 'root/children?expand=listItem&$orderby=name');
            System.debug(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + 'root/children?expand=listItem&$orderby=name');
            req.setHeader('Accept', '*/*');
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while getting the items (GraphApiService.getItemsInDrive)\n' + res.getBody(), res.getStatusCode());
            }

            return SharepointItemsWrapper.parse(res.getBody());
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }


    public static String returnNewFolderId(String siteId, String driveId, String parentFolderId, String folderName){

        String folderID = '';
        try{

            Http http = new Http();

            system.debug('siteId: ' + siteId);
            system.debug('driveId: ' + driveId);
            system.debug('parentFolderId: ' + parentFolderId);
            system.debug('folderName: ' + folderName);
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('POST');
            String endpointURL = BASE_URL+SITE_URL.replace('{siteId}', siteId);

            if (parentFolderId == '') {
                endpointURL += 'drives/' + driveId + '/root/children';//ROOT_URL;
            } else {
                //endpointURL += DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', parentFolderId)+'/children';
                endpointURL += DRIVE_URL.replace('{driveId}', driveId) +'root/children';
            }

            req.setEndpoint(endpointURL);
            req.setBody('{"name": "' + folderName + '","folder": {}}');
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', '*/*');

            System.debug('GraphApiService.returnNewFolderId() --  endpoint -->> ' + req.getEndpoint());
    
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while creating the folder (GraphApiService.returnNewFolderId)\n' + res.getBody(), res.getStatusCode());
            }
            folderID = SharepointFolderWrapper.parse(res.getBody()).id;
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
        }
        return folderID;
    }

    public static String returnNewInnerFolderId(String siteId, String driveId, String parentFolderId, String token, String folderName){

        String folderID = null;
        try{

            Http http = new Http();

            system.debug('siteId: ' + siteId);
            system.debug('driveId: ' + driveId);
            system.debug('parentFolderId: ' + parentFolderId);
            system.debug('token: ' + token);
            system.debug('folderName: ' + folderName);
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('POST');
            String endpointURL = BASE_URL+SITE_URL.replace('{siteId}', siteId);

            endpointURL += 'drives/' + driveId + '/items/'+ parentFolderId + '/children';

            req.setEndpoint(endpointURL);
            req.setBody('{"name": "' + folderName + '","folder": {}}');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setTimeout(120000);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Accept', '*/*');

            System.debug('GraphApiService.returnNewFolderId() --  endpoint -->> ' + req.getEndpoint());
    
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while creating the folder (GraphApiService.returnNewFolderId)\n' + res.getBody(), res.getStatusCode());
            }
            folderID = SharepointFolderWrapper.parse(res.getBody()).id;
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
        }
        return folderID;
    }

    public static SharepointPreviewItemWrapper previewItem(String siteId, String driveId, String itemId, String token){
        try{
            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('POST');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId) + '/preview');
    
            req.setHeader('Authorization', 'Bearer ' + token);
    
            req.setHeader('Content-Length', '0');
        
            req.setHeader('Accept', 'application/json');
    
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while creating preview link for the item (GraphApiService.previewItem)\n' + res.getBody(), res.getStatusCode());
            }

            return SharepointPreviewItemWrapper.parse(res.getBody());
        }
        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public static SharepointListWrapper getListId(String siteId, String driveId, String token){
        Http http = new Http();
    
        HttpRequest req = new HttpRequest();

        req.setMethod('GET');
    
        req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + 'drives/' + driveId + '?$expand=list');

        System.debug(BASE_URL+SITE_URL.replace('{siteId}', siteId) + 'drives/' + driveId + '?$expand=list');

        req.setHeader('Authorization', 'Bearer ' + token);

        req.setHeader('Accept', 'application/json');

        HttpResponse res = http.send(req);

        System.debug(res.getBody());
        System.debug('Status: ' + res.getStatusCode());

        if(!(res.getStatusCode()<300)){
            throw new RestApiException('Error while getting the list item (GraphApiService.getListId)\n' + res.getBody(), res.getStatusCode());
        }

        return SharepointListWrapper.parse(res.getBody());
    }


    public static Boolean moveItem(String siteId, String driveId, String itemId, String itemName, String folderId, String token){
        try{
            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('PATCH');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId));
    
            req.setHeader('Authorization', 'Bearer ' + token);
            
            req.setHeader('Content-type', 'application/json');
    
            req.setBody('{"parentReference": {"id": "' + folderId + '"},"name": "' + itemName + '"}');
        
            req.setHeader('Accept', 'application/json');
    
            HttpResponse res = http.send(req);

            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            

            if(!Test.isRunningTest()){
                SharepointListWrapper obj = GraphApiService.getListId(siteId, driveId, token);

                String listId =  obj.list_Wrapper.id;

                String listItemId = GraphApiService.getListItemId(siteId, driveId, itemId, token);
            }

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while moving the item (GraphApiService.moveItem)\n' + res.getBody(), res.getStatusCode());
            }
            
            return true;
        }
        catch(RestApiException e){
            System.debug(e.getMessage());
            return false;
        }
    }

    public static Boolean copyItem(String siteId, String driveId, String itemId, String itemName, String folderId, String token){
        try{
            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('POST');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', itemId) + '/copy');
    
            req.setHeader('Authorization', 'Bearer ' + token);
            
            req.setHeader('Content-type', 'application/json');
    
            req.setBody('{"parentReference": {"id": "' + folderId + '"},"name": "' + itemName + '"}');
    
            system.debug('{"parentReference": {"id": "' + folderId + '"},"name": "' + itemName + '"}');
        
            req.setHeader('Accept', 'application/json');
    
            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());

            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while copy the item (GraphApiService.copyItem)\n' + res.getBody(), res.getStatusCode());
            }

            return true;
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return false;
        }
    }

    public static SharepointListItemsWrapper getListItems(String siteId, String listId, String token){
            try{

                Http http = new Http();
        
                HttpRequest req = new HttpRequest();
        
                req.setMethod('GET');
        
                req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + 'lists/' + listId + '/' + 'items');
        
                req.setHeader('Authorization', 'Bearer ' + token);
            
                req.setHeader('Accept', '*/*');
    
                HttpResponse res = http.send(req);
        
                System.debug(res.getBody());
                System.debug('Status: ' + res.getStatusCode());
        
                if(!(res.getStatusCode()<300)){
                    throw new RestApiException('Error while get the list items (GraphApiService.getListItems)\n' + res.getBody(), res.getStatusCode());
                }
                
                return SharepointListItemsWrapper.parse(res.getBody());
            }

            catch(RestApiException e){
                System.debug(e.getMessage());
                return null;
            }
    }

    public static SharepointListItemsWrapper getListItems(String nextLink, String token){
        try{
            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(nextLink);
    
            req.setHeader('Authorization', 'Bearer ' + token);
        
            req.setHeader('Accept', '*/*');

            HttpResponse res = http.send(req);
    
            System.debug(res.getBody());
            System.debug('Status: ' + res.getStatusCode());
    
            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while get the list items (GraphApiService.getListItems)\n' + res.getBody(), res.getStatusCode());
            }
            
            return SharepointListItemsWrapper.parse(res.getBody());
        }
        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public static Blob getFileContent(String siteId, String driveId, String fileId, String token){
        try{

            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(BASE_URL+SITE_URL.replace('{siteId}', siteId) + DRIVE_URL.replace('{driveId}', driveId) + ITEM_URL.replace('{itemId}', fileId) + '/content');
    
            req.setHeader('Authorization', 'Bearer ' + token);
        
            req.setHeader('Accept', '*/*');

            HttpResponse res = http.send(req);
    
            System.debug('Status: ' + res.getStatusCode());
    
            if(!(res.getStatusCode()<300)){//302 error
                throw new RestApiException('Error while getting the file content (GraphApiService.getFileContent)\n' + res.getBody(), res.getStatusCode());
            }
            
            return res.getBodyAsBlob();
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public static Blob downloadFile(String downloadURL){
        try{

            Http http = new Http();
    
            HttpRequest req = new HttpRequest();
    
            req.setMethod('GET');
    
            req.setEndpoint(downloadURL);
        
            req.setHeader('Accept', '*/*');

            HttpResponse res = http.send(req);
    
            System.debug('Status: ' + res.getStatusCode());
    
            if(!(res.getStatusCode()<300)){
                throw new RestApiException('Error while getting the file content (GraphApiService.getFileContent)\n' + res.getBody(), res.getStatusCode());
            }
            
            return res.getBodyAsBlob();
        }

        catch(RestApiException e){
            System.debug(e.getMessage());
            return null;
        }
    }

    public class RestApiException extends Exception {
        public final Integer statusCode { private set; get; }
        public RestApiException(final String message, final Integer statusCode){
            this(message);
            this.statusCode = statusCode;

        }
    }

}