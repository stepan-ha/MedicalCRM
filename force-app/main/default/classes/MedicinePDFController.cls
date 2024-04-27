public with sharing class MedicinePDFController {
    public String medicalNoteId { get{
        return ApexPages.currentPage().getParameters().get('medicalNoteId');
    } set; }

    public Medical_Note__c medicalNoteItem;

    public List<MedicineWrapper> medicineWrapperList{get{

        if(medicalNoteItem==null)
            medicalNoteItem = [SELECT Id, Medicine__c, Medical_History__r.Patient__r.Name, Medical_History__r.Doctor__r.Name FROM Medical_Note__c WHERE Id =: medicalNoteId LIMIT 1];

        return medicalNoteItem.Medicine__c!=null?(List<MedicineWrapper>) JSON.deserialize(medicalNoteItem.Medicine__c, List<MedicineWrapper>.class):new List<MedicineWrapper>();
    } set;}


    public String logoImage{get{
        return 'VF_Logo';
    }set;}


    public String footerImage{get{
        return 'VF_Footer';
    }set;}

    public String watermarkImage{get{
        return 'VF_watermark';
    }set;}


    public String patientName{get{
        
        if(medicalNoteItem==null)
            medicalNoteItem = [SELECT Id, Medicine__c, Medical_History__r.Patient__r.Name, Medical_History__r.Doctor__r.Name FROM Medical_Note__c WHERE Id =: medicalNoteId LIMIT 1];

        return medicalNoteItem.Medical_History__r.Patient__r.Name;

    }set;}

    public String doctorName{get{
        
        if(medicalNoteItem==null)
            medicalNoteItem = [SELECT Id, Medicine__c, Medical_History__r.Patient__r.Name, Medical_History__r.Doctor__r.Name FROM Medical_Note__c WHERE Id =: medicalNoteId LIMIT 1];

        return medicalNoteItem.Medical_History__r.Doctor__r.Name;

    }set;}

    

    


    public class MedicineWrapper{
        public String id {get;set;}
        public String name {get;set;}
        public String dosage {get;set;}
        public String dosageForm {get;set;}
        public String frequency {get;set;}

    }

}