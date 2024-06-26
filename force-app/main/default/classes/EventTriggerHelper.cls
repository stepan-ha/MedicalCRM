public without sharing class EventTriggerHelper {
    
    public static void validateEventsSchedule(List<Event> eventsNew){

        Map<Id, List<Event>> userToEventMap = new Map<Id, List<Event>>();

        for(Event eventItem : eventsNew){

            if(userToEventMap.containsKey(eventItem.OwnerId)){

                userToEventMap.get(eventItem.OwnerId).add(eventItem);

            }
            else{

                userToEventMap.put(eventItem.OwnerId, new List<Event>{eventItem});

            }

        }

        System.debug('userToEventMap: ' + userToEventMap);



        List<Event> meetingWithEvents = [SELECT Id, StartDateTime, EndDateTime, OwnerId
                                        FROM Event 
                                        WHERE OwnerId IN : userToEventMap.keySet()];


        System.debug('meetingWithEvents: ' + meetingWithEvents);

        for(Event eventItem : meetingWithEvents){

            if(userToEventMap.containsKey(eventItem.OwnerId)){

                System.debug('containsKey');

                for(Event eventItemTrigger : userToEventMap.get(eventItem.OwnerId)){

                    if(eventItemTrigger.StartDateTime<=eventItem.EndDateTime && 
                    eventItemTrigger.EndDateTime>=eventItem.StartDateTime){
                        if(!eventItemTrigger.isCoppy__c)
                        eventItemTrigger.addError('This time slot is already booked! Please select another time for that meeting');
                    }

                }

            }

        }

    }


    public static void shareEvent(List<Event> events){

        List<Event> newEvents = new List<Event>();

        Set<Id> contactIds = new Set<Id>();

        for(Event eventItem : events){

            contactIds.add(eventItem.WhoId);

        }


        Map<Id, Id> contactToUserMap = new Map<Id, Id>();

        List<User> userList = [SELECT Id, ContactID FROM User WHERE ContactID IN:contactIds];

        for(User userItem : userList){

            contactToUserMap.put(userItem.ContactID, userItem.Id);

        }

        System.debug('contactToUserMap: ' + contactToUserMap);


        

        for(Event eventItem : events){

            if(!eventItem.isCoppy__c)
            newEvents.add(new Event(Description = eventItem.Description, 
                                    Subject = eventItem.Subject, 
                                    StartDateTime = eventItem.StartDateTime, 
                                    EndDateTime = eventItem.EndDateTime,
                                    OwnerId = contactToUserMap.get(eventItem.WhoId),
                                    isCoppy__c = true,
                                    Copy_From_Entity__c = eventItem.Id));

        }

        System.debug('newEvents: ' + newEvents);

        insert newEvents;

    }


    /*public static void updateShareEvent(Map<Id, Event> eventsNewMap, Map<Id, Event> eventsOldMap){

        Map<Id, Id> eventToEntity = new Map<Id, Id>();

        for(Id oldEventItemId : eventsOldMap.keySet()){

            eventToEntity.put(Id, eventsOldMap.get(oldEventItemId).Copy_From_Entity__c!=null?
                                    eventsOldMap.get(oldEventItemId).Copy_From_Entity__c:
                                    eventsOldMap.get(oldEventItemId).Id);

        }

        Map<Id, Event> relatedEventList = new Map<Id, Event>([SELECT Id, Copy_From_Entity__c, Start_Date__c, End_Date__c, Description 
                                                            FROM Event
                                                            WHERE Id IN: eventToEntity.keySet()
                                                            OR Copy_From_Entity__c IN: eventToEntity.keySet()]);

        List<Event> eventsToUpdate = new List<Event>();

        for(Id relatedEventItemId : relatedEventList.keySet()){

            if(!eventsNewMap.containsKey(relatedEventItemId)){
                
                eventsToUpdate.add(new Event (Id = relatedEventItemId,
                                                ));

            }

        }


    }*/


}