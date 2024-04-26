({
    init : function(component, event, helper) {
        var flow = component.find("myFlow");
        flow.startFlow("Create_Event_Flow");
    },

    statusChange : function (cmp, event) {
            if (event.getParam('status') === "FINISHED") {
                /*var redirectToNewRecord = $A.get("e.force:navigateToSObject" );

                redirectToNewRecord.setParams({
                        "recordId": cmp.get( "v.recordId" ),
                        "slideDevName": "detail"
                });
                redirectToNewRecord.fire();*/

                window.location.reload()
            }
    }
})
