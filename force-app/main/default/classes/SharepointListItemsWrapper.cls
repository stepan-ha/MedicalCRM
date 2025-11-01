public class SharepointListItemsWrapper {
    public String nextLink;
    public cls_value[] value;

    public class cls_value{
        public String id;
        public cls_fields fields;
    }
    public class cls_fields{
        public String id;
    }

    public static SharepointListItemsWrapper parse(String jsonBody){
        String clearedJsonBody = jsonBody.replaceAll('@odata.', '');
        return (SharepointListItemsWrapper) JSON.deserialize(clearedJsonBody, SharepointListItemsWrapper.class);
    }
}