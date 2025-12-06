public with sharing class SharepointItemExtendedWrapper {
	public String createdDateTime;	//2023-08-30T07:40:00Z
	public String eTag;	//"{B92CF3E7-6B9D-49B4-A6DD-DBCF0E00921A},1"
	public String id;	//016OCX3IHH6MWLTHLLWRE2NXO3Z4HABEQ2
	public String lastModifiedDateTime;	//2023-08-30T07:40:00Z
	public String name;	//Test Permission
	public String webUrl;	//https://54zm7z.sharepoint.com/sites/test/Shared%20Documents/Test%20Permission
	public String cTag;	//"c:{B92CF3E7-6B9D-49B4-A6DD-DBCF0E00921A},0"
	public Integer size;	//76603
	public cls_createdBy createdBy;
	public cls_lastModifiedBy lastModifiedBy;
	public cls_parentReference parentReference;
	public cls_fileSystemInfo fileSystemInfo;
	public cls_folder folder;
	public cls_shared shared;
	public cls_listItem listItem;
	
    public class cls_createdBy {
		public cls_user user;
	}
	public class cls_application {
		public String id;	//0f5f69f4-15dd-470c-a09c-33b374039909
		public String displayName;	//connectedAppAzure
	}
	public class cls_user {
		public String displayName;	//SharePoint App
	}
	public class cls_lastModifiedBy {
		public cls_application application;
		public cls_user user;
	}
	public class cls_parentReference {
		public String id;	//f0ac9cac-2f35-4911-86b3-981a2dd92c97
		public String siteId;	//54zm7z.sharepoint.com,30cf715c-51d2-4754-acf9-e7d9549e7f25,c7ad2fbf-0fff-417d-a6a6-d15a87e39072
	}
	public class cls_fileSystemInfo {
		public String createdDateTime;	//2023-08-30T07:40:00Z
		public String lastModifiedDateTime;	//2023-08-30T07:40:00Z
	}
	public class cls_folder {
		public Integer childCount;	//5
	}
	public class cls_shared {
		public String scope;	//users
	}
	public class cls_listItem {
		public String createdDateTime;	//2023-08-30T07:40:00Z
		public String id;	//1850
		public String lastModifiedDateTime;	//2023-08-30T07:40:00Z
		public String webUrl;	//https://54zm7z.sharepoint.com/sites/test/Shared%20Documents/Test%20Permission
		public cls_createdBy createdBy;
		public cls_lastModifiedBy lastModifiedBy;
		public cls_parentReference parentReference;
		public cls_contentType contentType;
		public String context;	//https://graph.microsoft.com/v1.0/$metadata#sites('54zm7z.sharepoint.com%2C30cf715c-51d2-4754-acf9-e7d9549e7f25%2Cc7ad2fbf-0fff-417d-a6a6-d15a87e39072')/drives('b%21XHHPMNJRVEes-efZVJ5_Jb8vrcf_D31BpqbRWofjkHLhC0b95Tx2T40yIZlnB_xk')/items('016OCX3IHH6MWLTHLLWRE2NXO3Z4HABEQ2')/listItem/fields/$entity
		public cls_fields fields;
	}
	public class cls_contentType {
		public String id;	//0x012000D7DD0ABDBBBD8343A6AE04776868FBEE
		public String name;	//Folder
	}
	public class cls_fields {
		public String etag;	//"b92cf3e7-6b9d-49b4-a6dd-dbcf0e00921a,1"
		public String FileLeafRef;	//Test Permission
		public cls_MediaServiceImageTags[] MediaServiceImageTags;
		public String id;	//1850
		public String ContentType;	//Folder
		public String Created;	//2023-08-30T07:40:00Z
		public String AuthorLookupId;	//1073741822
		public String Modified;	//2023-08-30T07:40:00Z
		public String EditorLookupId;	//1073741822
		public String CheckinComment;	//
		public String LinkFilenameNoMenu;	//Test Permission
		public String LinkFilename;	//Test Permission
		public String ItemChildCount;	//3
		public String FolderChildCount;	//2
		public String ComplianceFlags;	//
		public String ComplianceTag;	//
		public String ComplianceTagWrittenTime;	//
		public String ComplianceTagUserId;	//
		public String CommentCount;	//
		public String LikeCount;	//
		public String DisplayName;	//
		public String AppAuthorLookupId;	//7
		public String AppEditorLookupId;	//7
		public String Edit;	//0
		public String UIVersionString;	//1.0
		public String ParentVersionStringLookupId;	//1850
		public String ParentLeafNameLookupId;	//1850
	}
	public class cls_MediaServiceImageTags {
	}
	public static SharepointItemExtendedWrapper parse(String json){
		return (SharepointItemExtendedWrapper) System.JSON.deserialize(json, SharepointItemExtendedWrapper.class);
	}

}