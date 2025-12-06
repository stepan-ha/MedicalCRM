public with sharing class MedicalCertificateController {
    public String medicalNoteId { 
        get {
            return ApexPages.currentPage().getParameters().get('medicalNoteId');
        } 
        set; 
    }

    public Medical_Note__c medicalNoteItem;

    public Medical_Note__c getMedicalNote() {
        if(medicalNoteItem == null && String.isNotBlank(medicalNoteId)) {
            medicalNoteItem = [
                SELECT Id, Notes__c, Disease__r.Name, 
                       Medical_History__r.Patient__r.Name, 
                       Medical_History__r.Doctor__r.Name 
                FROM Medical_Note__c 
                WHERE Id = :medicalNoteId 
                LIMIT 1
            ];
        }
        return medicalNoteItem;
    }

    public String logoImage {
        get {
            return 'VF_Logo';
        }
        set;
    }

    public String footerImage {
        get {
            return 'VF_Footer';
        }
        set;
    }
    
    public String patientName {
        get {
            Medical_Note__c note = getMedicalNote();
            return note != null && note.Medical_History__r != null && note.Medical_History__r.Patient__r != null 
                ? note.Medical_History__r.Patient__r.Name : '';
        }
        set;
    }

    public String doctorName {
        get {
            Medical_Note__c note = getMedicalNote();
            return note != null && note.Medical_History__r != null && note.Medical_History__r.Doctor__r != null 
                ? note.Medical_History__r.Doctor__r.Name : '';
        }
        set;
    }

    public String diagnosis {
        get {
            Medical_Note__c note = getMedicalNote();
            return note != null && note.Disease__r != null ? note.Disease__r.Name : '';
        }
        set;
    }

    public String notes {
        get {
            Medical_Note__c note = getMedicalNote();
            return note != null && note.Notes__c != null ? note.Notes__c : '';
        }
        set;
    }
}

