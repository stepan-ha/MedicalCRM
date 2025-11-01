public class SharepointListWrapper {
    public cls_list list_Wrapper;
    public String id;

    public class cls_list {
        public String id;
    }

    public static SharepointListWrapper parse(String jsonString){
        String clearedJsonString = jsonString.replaceAll('list', 'list_Wrapper');
        return (SharepointListWrapper) JSON.deserialize(clearedJsonString, SharepointListWrapper.class);
    }
}