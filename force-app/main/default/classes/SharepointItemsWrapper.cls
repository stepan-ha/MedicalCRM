public class SharepointItemsWrapper {
    @AuraEnabled public String context;	
	@AuraEnabled public cls_value[] value;
	public class cls_value {
		@AuraEnabled public String downloadUrl;
		@AuraEnabled public Datetime createdDateTime;	
		@AuraEnabled public String eTag;	
		@AuraEnabled public String id;	
		@AuraEnabled public Datetime lastModifiedDateTime;
		@AuraEnabled public String name;	
		@AuraEnabled public String webUrl;	
		@AuraEnabled public String cTag;	
		@AuraEnabled public Decimal size;
		@AuraEnabled public cls_createdBy createdBy;
		@AuraEnabled public cls_lastModifiedBy lastModifiedBy;
		@AuraEnabled public cls_parentReference parentReference;
		@AuraEnabled public cls_fileSystemInfo fileSystemInfo;
		@AuraEnabled public cls_folder folder;
		@AuraEnabled public cls_file file;
		@AuraEnabled public cls_shared shared;
		@AuraEnabled public cls_listItem listItem;

	}

	public class cls_listItem{
		@AuraEnabled public cls_fields fields;
	}

	public class cls_fields{
		@AuraEnabled public String id;
		@AuraEnabled public String LastModifiedBy;
	}

	public class cls_createdBy {
		@AuraEnabled public cls_application application;
		@AuraEnabled public cls_user user;
	}

	public class cls_file {
		@AuraEnabled public String mimeType;
	}

	public class cls_application {
		@AuraEnabled public String id;	
		@AuraEnabled public String displayName;	
	}
	public class cls_user {
		@AuraEnabled public String displayName;	
	}
	public class cls_lastModifiedBy {
		@AuraEnabled public cls_application application;
		@AuraEnabled public cls_user user;
	}
	public class cls_parentReference {
		@AuraEnabled public String driveType;	
		@AuraEnabled public String driveId;	
		@AuraEnabled public String id;	
		@AuraEnabled public String path;	
		@AuraEnabled public String siteId;	
	}
	public class cls_fileSystemInfo {
		@AuraEnabled public String createdDateTime;	
		@AuraEnabled public String lastModifiedDateTime;
    }

	public class cls_folder {
		@AuraEnabled public Decimal childCount;	
	}
	public class cls_shared {
		@AuraEnabled public String scope;	
	}

	private static String clearJSON(String json){
		String clearJSON = json.contains('@odata.')?json.replaceAll('@odata.', ''):json;
		clearJSON = clearJSON.contains('@microsoft.graph.')?clearJSON.replaceAll('@microsoft.graph.', ''):clearJSON;

		return clearJSON;
	}
	
	public static SharepointItemsWrapper parse(String json){
		String clearJSON = clearJSON(json);
		System.debug(clearJSON);
		return (SharepointItemsWrapper) System.JSON.deserialize(clearJSON, SharepointItemsWrapper.class);
	}

		
}