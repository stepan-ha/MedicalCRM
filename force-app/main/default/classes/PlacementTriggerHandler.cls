public with sharing class PlacementTriggerHandler {
    
    public static void onBeforeInsert(List<Placement__c> placementsNew){

        PlacementTriggerHelper.validatePlacementsSchedule(placementsNew);

    }

    public static void onAfterInsert(List<Placement__c> placementsNew,
                                    Map<Id, Placement__c> placementsNewMap){
        
    }

    public static void onBeforeUpdate(List<Placement__c> placementsNew,
                                    Map<Id, Placement__c> placementsNewMap,
                                    List<Placement__c> placementsOld,
                                    Map<Id, Placement__c> placementsOldMap){

        PlacementTriggerHelper.validatePlacementsSchedule(placementsNew);
        
    }

    public static void onAfterUpdate(List<Placement__c> placementsNew,
                                    Map<Id, Placement__c> placementsNewMap,
                                    List<Placement__c> placementsOld,
                                    Map<Id, Placement__c> placementsOldMap){
        
    }


}