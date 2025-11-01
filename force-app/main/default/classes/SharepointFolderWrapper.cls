public class SharepointFolderWrapper  {

    public String eTag;
    public String id;
    public String name; 
    public Integer size; 
    public String webUrl; 
    public String cTag; 

    public cls_parentReference parentReference;

    public class cls_parentReference{
        public String driveId;
        public String driveType;
        public String id;
        public String path;
        public cls_sharepointIds sharepointIds; 
    }

    public class cls_sharepointIds{
        public String listId;
        public String listItemUniqueId;
        public String siteId;
        public String siteUrl;
    }

    public static SharepointFolderWrapper parse(String json){
        return (SharepointFolderWrapper) System.JSON.deserialize(json, SharepointFolderWrapper.class);
    }


}