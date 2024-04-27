public without sharing class EventTriggerHandler {

    public static void onBeforeInsert(List<Event> eventsNew){

        EventTriggerHelper.validateEventsSchedule(eventsNew);

    }

    public static void onAfterInsert(List<Event> eventsNew,
                                    Map<Id, Event> eventsNewMap){
        
        EventTriggerHelper.shareEvent(eventsNew);

    }

    public static void onBeforeUpdate(List<Event> eventsNew,
                                    Map<Id, Event> eventsNewMap,
                                    List<Event> eventsOld,
                                    Map<Id, Event> eventsOldMap){

        EventTriggerHelper.validateEventsSchedule(eventsNew);
        
    }

    public static void onAfterUpdate(List<Event> eventsNew,
                                    Map<Id, Event> eventsNewMap,
                                    List<Event> eventsOld,
                                    Map<Id, Event> eventsOldMap){


        //EventTriggerHelper.updateShareEvent(eventsNewMap, eventsOldMap);
        
    }
}