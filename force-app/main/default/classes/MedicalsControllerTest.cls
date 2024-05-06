
@isTest
private class MedicalsControllerTest {

    @TestSetup
    static void makeData(){
        Account acc = new Account(Name = 'Test');

        insert acc;

        Contact testContact = new Contact(FirstName = 'Test', 
                                            LastName = 'Test', 
                                            AccountId = acc.Id,
                                            Email = 'testContactEmail@test.com');

        insert testContact;

        Medical_History__c medicalHistory = new Medical_History__c(Patient__c = testContact.Id,
                                                                    Doctor__c = UserInfo.getUserId());

        insert medicalHistory;

        Medical_Note__c note = new Medical_Note__c(Medical_History__c = medicalHistory.Id,
                                                    Medicine__c = '[{"id":1,"name":"Test Medicine 1","dosage":"1","dosageForm":"tablet","frequency":"once daily"},'+
                                                    '{"id":2,"name":"Test Medicine 2","dosage":"2","dosageForm":"capsule","frequency":"twice daily"},'+
                                                    '{"id":3,"name":"Test Medicine 3","dosage":"1","dosageForm":"liquid","frequency":"once daily"},'+
                                                    '{"id":4,"name":"Test Medicine 4","dosage":"1","dosageForm":"tablet","frequency":"once daily"},'+
                                                    '{"id":5,"name":"Test Medicine 5","dosage":"2","dosageForm":"capsule","frequency":"twice daily"},'+
                                                    '{"id":10,"name":"Test Medicine 11","dosage":"3","dosageForm":"tablet","frequency":"once daily"}]');

        insert note;
    }

    @isTest
    static void updateMedicalsTest() {
        
        Medical_Note__c medicalNote = [SELECT Id, Medicine__c
                                        FROM Medical_Note__c
                                        LIMIT 1];

        String newJson = '[{"id":1,"name":"Test Medicine 12","dosage":"11","dosageForm":"tablet","frequency":"once daily"},'+
                        '{"id":2,"name":"Test Medicine 23","dosage":"3","dosageForm":"capsule","frequency":"twice daily"}]';

        MedicalsController.updateMedicals(medicalNote.id, newJson);

        Medical_Note__c medicalNoteRes = [SELECT Id, Medicine__c
                                        FROM Medical_Note__c
                                        WHERE Id =: medicalNote.id
                                        LIMIT 1];

        System.assertEquals(newJson, medicalNoteRes.Medicine__c);

    }

    @isTest
    static void getMedicalsTest() {

        Medical_Note__c medicalNote = [SELECT Id, Medicine__c
                                        FROM Medical_Note__c
                                        LIMIT 1];
        
        String jsonAssert = MedicalsController.getMedicals(medicalNote.Id);

        String jsonAssertExp = '[{"id":1,"name":"Test Medicine 1","dosage":"1","dosageForm":"tablet","frequency":"once daily"},'+
                                '{"id":2,"name":"Test Medicine 2","dosage":"2","dosageForm":"capsule","frequency":"twice daily"},'+
                                '{"id":3,"name":"Test Medicine 3","dosage":"1","dosageForm":"liquid","frequency":"once daily"},'+
                                '{"id":4,"name":"Test Medicine 4","dosage":"1","dosageForm":"tablet","frequency":"once daily"},'+
                                '{"id":5,"name":"Test Medicine 5","dosage":"2","dosageForm":"capsule","frequency":"twice daily"},'+
                                '{"id":10,"name":"Test Medicine 11","dosage":"3","dosageForm":"tablet","frequency":"once daily"}]';

        System.assertEquals(jsonAssertExp, jsonAssert);

    }
}