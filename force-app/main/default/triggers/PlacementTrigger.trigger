trigger PlacementTrigger on Placement__c (before insert, after insert, after update, before update) {

    if(Trigger.isBefore&&Trigger.isInsert){
        PlacementTriggerHandler.onBeforeInsert(((List<Placement__c>)Trigger.new));
    }
    else if(Trigger.isAfter&&Trigger.isInsert){
        PlacementTriggerHandler.onAfterInsert(((List<Placement__c>)Trigger.new), 
                                            ((Map<Id, Placement__c>)Trigger.newMap));
    }
    else if(Trigger.isBefore&&Trigger.isUpdate){
        PlacementTriggerHandler.onBeforeUpdate(((List<Placement__c>)Trigger.new), 
                                                ((Map<Id, Placement__c>)Trigger.newMap),
                                                ((List<Placement__c>)Trigger.old),
                                                ((Map<Id, Placement__c>)Trigger.oldMap));
    }
    else if(Trigger.isAfter&&Trigger.isUpdate){
        PlacementTriggerHandler.onAfterUpdate(((List<Placement__c>)Trigger.new), 
                                                ((Map<Id, Placement__c>)Trigger.newMap),
                                                ((List<Placement__c>)Trigger.old),
                                                ((Map<Id, Placement__c>)Trigger.oldMap));
    }


}