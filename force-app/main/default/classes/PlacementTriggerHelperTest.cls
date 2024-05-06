
@isTest
private class PlacementTriggerHelperTest {

    @TestSetup
    static void makeData(){

        List<Facility__c> facilityList = new List<Facility__c>();

        facilityList.add(new Facility__c(Number_of_beds__c = 3));

        facilityList.add(new Facility__c(Number_of_beds__c = 3));

        insert facilityList;


        List<Placement__c> placements = new List<Placement__c>();


        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-3),
                                        End_Date__c = Date.today().addDays(3),
                                        Facility__c = facilityList[0].id));

        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-7),
                                        End_Date__c = Date.today().addDays(2),
                                        Facility__c = facilityList[0].id));

        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-3),
                                        End_Date__c = Date.today().addDays(10),
                                        Facility__c = facilityList[0].id));

        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-3),
                                        End_Date__c = Date.today().addDays(12),
                                        Facility__c = facilityList[1].id));

        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-7),
                                        End_Date__c = Date.today().addDays(12),
                                        Facility__c = facilityList[1].id));

        placements.add(new Placement__c(Start_Date__c = Date.today().addDays(-7),
                                        End_Date__c = Date.today().addDays(-3),
                                        Facility__c = facilityList[1].id));

        insert placements;

    }

    @isTest
    static void testPlacementTriggerNegative() {
        
        List<Facility__c> facilityList = [SELECT Id 
                                        FROM Facility__c];

        List<Placement__c> errorPlacements = new List<Placement__c>();

        errorPlacements.add(new Placement__c(Start_Date__c = Date.today().addDays(-7),
                                        End_Date__c = Date.today().addDays(12),
                                        Facility__c = facilityList[0].id));
        errorPlacements.add(new Placement__c(Start_Date__c = Date.today().addDays(-7),
                                        End_Date__c = Date.today().addDays(12),
                                        Facility__c = facilityList[1].id));

        try {
            insert errorPlacements;
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }

    }

    @isTest
    static void testPlacementTriggerPossitive() {
        
        List<Facility__c> facilityList = [SELECT Id 
                                        FROM Facility__c];

        List<Placement__c> placementList = new List<Placement__c>();

        placementList.add(new Placement__c(Start_Date__c = Date.today().addDays(13),
                                        End_Date__c = Date.today().addDays(14),
                                        Facility__c = facilityList[0].id));
        placementList.add(new Placement__c(Start_Date__c = Date.today().addDays(14),
                                        End_Date__c = Date.today().addDays(17),
                                        Facility__c = facilityList[1].id));

    }

    @isTest
    static void testPlacementTriggerUpdateNegative() {
        
       List<Facility__c> facilityList = [SELECT Id 
                                        FROM Facility__c];

        List<Placement__c> placementList = new List<Placement__c>();

        Placement__c placementItem = new Placement__c(Start_Date__c = Date.today().addDays(13),
                                        End_Date__c = Date.today().addDays(14),
                                        Facility__c = facilityList[0].id);

        placementList.add(placementItem);
        placementList.add(new Placement__c(Start_Date__c = Date.today().addDays(14),
                                        End_Date__c = Date.today().addDays(17),
                                        Facility__c = facilityList[1].id));

        insert placementList;

        try {
            placementItem.Start_Date__c = Date.today().addDays(-7);
            placementItem.End_Date__c = Date.today().addDays(17);

            update placementItem;
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
            placementItem.Start_Date__c = Date.today().addDays(15);
            placementItem.End_Date__c = Date.today().addDays(17);
            update placementItem;
            System.assert(true);
        }

    }

    @isTest
    static void testPlacementTriggerInserNegative2() {
        
       Facility__c facilityItem = new Facility__c(Number_of_beds__c = 1);

       insert facilityItem;

        List<Placement__c> placementList = new List<Placement__c>();

        placementList.add(new Placement__c(Start_Date__c = Date.today().addDays(1),
                                        End_Date__c = Date.today().addDays(14),
                                        Facility__c = facilityItem.id));
        placementList.add(new Placement__c(Start_Date__c = Date.today().addDays(1),
                                        End_Date__c = Date.today().addDays(17),
                                        Facility__c = facilityItem.id));

        try {
            

            insert placementList;
            System.assert(false);
        } catch (Exception e) {
            System.assert(true);
        }

    }
}