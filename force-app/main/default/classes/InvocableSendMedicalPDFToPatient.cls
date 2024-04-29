public with sharing class InvocableSendMedicalPDFToPatient {
    
    @InvocableMethod(label='Send PDF to Patient')
    public static void sendPDF(List<String> medicalNoteId){

        Blob pdfFile = new PageReference('/apex/MedicinePDF?medicalNoteId='+medicalNoteId[0]).getContentAsPDF();

        Medical_Note__c medicalNoteItem = [SELECT Id, Medicine__c, Medical_History__r.Patient__r.Name, Medical_History__r.Patient__r.Email, 
                                                    Medical_History__r.Doctor__r.Name, Medical_History__r.Doctor__r.Email 
                                            FROM Medical_Note__c 
                                            WHERE Id =: medicalNoteId 
                                            LIMIT 1];

        String patientName = medicalNoteItem.Medical_History__r.Patient__r.Name;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] ccAddresses = new String[] {medicalNoteItem.Medical_History__r.Doctor__r.Email }; 

        String[] toAddresses = new String[] {medicalNoteItem.Medical_History__r.Patient__r.Email}; 

        mail.setSenderDisplayName('Medical Hub');

        mail.setSubject('Your medicine Prescription');

        mail.setPlainTextBody('I hope this message finds you well. Following our recent consultation, I have prescribed medication to address your health concerns. Please find the details of your prescription below.\nAdditionally, please remember to attend any follow-up appointments as scheduled so we can monitor your progress and make any necessary adjustments to your treatment plan.\nIf you experience any unexpected side effects or have any questions before your next appointment, feel free to contact my office.');

        mail.setCcAddresses(ccAddresses);

        mail.setToAddresses(toAddresses);
        

        Messaging.EmailFileAttachment emlAtt = new Messaging.EmailFileAttachment();
        emlAtt.setFilename('Prescriptions to ' + patientName + ' ' + Date.today()+'.pdf');
        emlAtt.setBody(pdfFile);

        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {emlAtt});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }


}