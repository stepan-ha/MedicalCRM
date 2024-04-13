public with sharing class PlacementTriggerHelper {
    
    public static void validatePlacementsSchedule(List<Placement__c> placements){

        Map<Id, List<Placement__c>> facilityToPLacementsMap = new Map<Id, List<Placement__c>>();

        Date minStartDate = placements[0].Start_Date__c;
        Date maxEndDate = placements[0].End_Date__c;

        Set<Id> placementIds = new Set<Id>();

        for(Placement__c placementItem : placements){
            placementIds.add(placementItem.Id);

            if(facilityToPLacementsMap.containsKey(placementItem.Facility__c)){
                facilityToPLacementsMap.get(placementItem.Facility__c).add(placementItem);
            }
            else{
                facilityToPLacementsMap.put(placementItem.Facility__c, new List<Placement__c>{placementItem});
            }

            if(placementItem.Start_Date__c < minStartDate){

                minStartDate = placementItem.Start_Date__c;

            }
            if(placementItem.End_Date__c > maxEndDate){

                maxEndDate = placementItem.End_Date__c;

            }

        }

        Map<Id, Map<Date, Integer>> newFacilityScheduleMap = new Map<Id, Map<Date, Integer>>();

        for(Id facilityId : facilityToPLacementsMap.keySet()){

            Map<Date, Integer> dateMap = new Map<Date, Integer>();

            for(Placement__c placementItem : facilityToPLacementsMap.get(facilityId)){

                for(Date dateIterator = placementItem.Start_Date__c; dateIterator<= placementItem.End_Date__c; dateIterator = dateIterator.addDays(1)){

                    if(dateMap.containsKey(dateIterator)){
                        dateMap.put(dateIterator, dateMap.get(dateIterator) + 1);
                    }
                    else{
                        dateMap.put(dateIterator, 1);
                    }

                }

            }

            newFacilityScheduleMap.put(facilityId, dateMap);

        }


        Map<Id, Facility__c> facilityMap = new Map<Id, Facility__c> ([SELECT Id, Number_of_beds__c,
                                                                            (SELECT Id, Start_Date__c, 
                                                                            End_Date__c FROM Placements__r 
                                                                            WHERE (Start_Date__c <=: maxEndDate
                                                                            AND End_Date__c >=: minStartDate)
                                                                            AND Id NOT IN: placementIds
                                                                            )
                                                                    FROM Facility__c
                                                                    WHERE Id IN: facilityToPLacementsMap.keySet()]);

        Map<Id, Map<Date, Integer>> oldFacilityScheduleMap = new Map<Id, Map<Date, Integer>>();


        for(Id facilityId : facilityMap.keySet()){

            Map<Date, Integer> dateMap = new Map<Date, Integer>();

            for(Placement__c placementItem : facilityMap.get(facilityId).Placements__r){

                for(Date dateIterator = placementItem.Start_Date__c; dateIterator<= placementItem.End_Date__c; dateIterator = dateIterator.addDays(1)){

                    if(dateMap.containsKey(dateIterator)){
                        dateMap.put(dateIterator, dateMap.get(dateIterator) + 1);
                    }
                    else{
                        dateMap.put(dateIterator, 1);
                    }

                }

            }

            oldFacilityScheduleMap.put(facilityId, dateMap);

        }

        Map<Id, Set<Date>> errorMap = new Map<Id, Set<Date>>();

        for(Id facilityId : newFacilityScheduleMap.keySet()){

            for(Date dateIterator : newFacilityScheduleMap.get(facilityId).keySet()){

                if(!oldFacilityScheduleMap.get(facilityId).containsKey(dateIterator)&&
                facilityMap.get(facilityId).Number_of_beds__c<newFacilityScheduleMap.get(facilityId).get(dateIterator)){

                    System.debug('FirstDessision');

                    if(errorMap.containsKey(facilityId)){
                        errorMap.get(facilityId).add(dateIterator);
                    }
                    else{
                        errorMap.put(facilityId, new Set<Date>{dateIterator});
                    }

                }

                if(oldFacilityScheduleMap.get(facilityId).containsKey(dateIterator)&&
                facilityMap.get(facilityId).Number_of_beds__c < (newFacilityScheduleMap.get(facilityId).get(dateIterator)+oldFacilityScheduleMap.get(facilityId).get(dateIterator))){

                    System.debug('SecondDessision');

                    System.debug('dateIterator: ' + dateIterator);

                    System.debug('facilityMap.get(facilityId).Number_of_beds__c: ' + facilityMap.get(facilityId).Number_of_beds__c);

                    System.debug('newFacilityScheduleMap.get(facilityId).get(dateIterator): ' + newFacilityScheduleMap.get(facilityId).get(dateIterator));

                    System.debug('oldFacilityScheduleMap.get(facilityId).get(dateIterator): ' + oldFacilityScheduleMap.get(facilityId).get(dateIterator));

                    if(errorMap.containsKey(facilityId)){
                        errorMap.get(facilityId).add(dateIterator);
                    }
                    else{
                        errorMap.put(facilityId, new Set<Date>{dateIterator});
                    }

                }

            }

        }

        if(!errorMap.isEmpty()){

            for(Id facilityId : errorMap.keySet()){

                for(Placement__c placementItem : facilityToPLacementsMap.get(facilityId)){

                    for(Date dateItem : errorMap.get(facilityId)){

                        if(placementItem.Start_Date__c<= dateItem && placementItem.End_Date__c>= dateItem){

                            placementItem.addError(System.Label.Placement_Error_Message);

                        }

                    }

                }

            }

        }

    }

}