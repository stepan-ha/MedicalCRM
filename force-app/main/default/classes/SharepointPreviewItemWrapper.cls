public with sharing class SharepointPreviewItemWrapper {
    
    @AuraEnabled public String context;	
	@AuraEnabled public String getUrl;	
	@AuraEnabled public cls_postParameters postParameters;
	@AuraEnabled public cls_postUrl postUrl;

	public class cls_postParameters {
	}

	public class cls_postUrl {
	}

	private static String clearJSON(String json){
		String clearJSON = json.contains('@odata.')?json.replaceAll('@odata.', ''):json;
		clearJSON = clearJSON.contains('@microsoft.graph.')?clearJSON.replaceAll('@microsoft.graph.', ''):clearJSON;

		return clearJSON;
	}

	public static SharepointPreviewItemWrapper parse(String json){
		String clearJSON = clearJSON(json);

		return (SharepointPreviewItemWrapper) System.JSON.deserialize(clearJSON, SharepointPreviewItemWrapper.class);
	}
}