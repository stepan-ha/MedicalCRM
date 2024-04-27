trigger EventTrigger on Event (before insert, before update, after insert, after update){

    if(Trigger.isBefore&&Trigger.isInsert){
        EventTriggerHandler.onBeforeInsert(((List<Event>)Trigger.new));
    }
    else if(Trigger.isAfter&&Trigger.isInsert){
        EventTriggerHandler.onAfterInsert(((List<Event>)Trigger.new), 
                                            ((Map<Id, Event>)Trigger.newMap));
    }
    else if(Trigger.isBefore&&Trigger.isUpdate){
        EventTriggerHandler.onBeforeUpdate(((List<Event>)Trigger.new), 
                                                ((Map<Id, Event>)Trigger.newMap),
                                                ((List<Event>)Trigger.old),
                                                ((Map<Id, Event>)Trigger.oldMap));
    }
    else if(Trigger.isAfter&&Trigger.isUpdate){
        EventTriggerHandler.onAfterUpdate(((List<Event>)Trigger.new), 
                                                ((Map<Id, Event>)Trigger.newMap),
                                                ((List<Event>)Trigger.old),
                                                ((Map<Id, Event>)Trigger.oldMap));
    }

}