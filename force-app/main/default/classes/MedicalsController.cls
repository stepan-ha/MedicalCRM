public with sharing class MedicalsController {
    

    @AuraEnabled
    public static void updateMedicals(String recordId, String dataJSON){

        update new Medical_Note__c(Id = recordId, Medicine__c = dataJSON);

    }

    @AuraEnabled
    public static String getMedicals(String recordId){

        Medical_Note__c medicalNote = [SELECT Id, Medicine__c FROM Medical_Note__c WHERE Id =: recordId LIMIT 1];

        return medicalNote.Medicine__c;

    }

}