
@isTest
private class InvocableSendMedicalPDFToPatientTest {

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
    static void myUnitTest() {
        
        Medical_Note__c medicalNoteItem = [SELECT Id
                                            FROM Medical_Note__c 
                                            LIMIT 1];

        Test.startTest();
        InvocableSendMedicalPDFToPatient.sendPDF(new List<String> {String.valueOf(medicalNoteItem.Id)});
        Integer invocations = Limits.getEmailInvocations();
        Test.stopTest();
        
        system.assertEquals(1, invocations,  ' An email should be sent');
    }
}