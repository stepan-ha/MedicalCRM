import { api, track } from 'lwc';
import LightningModal from 'lightning/modal';

import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AddMedicalModal extends LightningModal {

    @api medicals;

    data;

    columns = [
        { label: 'Назва', fieldName: 'name', editable: true },
        { label: 'Дозування', fieldName: 'dosage', type: 'number', editable: true},
        { label: 'Форма дозування', fieldName: 'dosageForm', editable: true },
        { label: 'Частота /День', fieldName: 'frequency', editable: true },
    ];


    connectedCallback(){

        console.log('Connected Modal');

        this.data = this.medicals;

        console.log(this.medicals);

    }

    handleAdd(){

        let arrCopy = JSON.parse(JSON.stringify(this.data));

        let newId = this.data.length<1?1:arrCopy[arrCopy.length - 1].id + 1;

        arrCopy.push({id: newId});

        this.data = [];

        this.data = arrCopy;

    }

    handleSave(event){

        let draftValues = event.detail.draftValues;

        console.log(draftValues);

        let arrCopy = JSON.parse(JSON.stringify(this.data));

        this.clearDraftValues();

        try{

            arrCopy.forEach(item=>{
                draftValues.forEach(draftValue=>{
                    if(item.id == draftValue.id){
                        if(draftValue.name!=null)
                            item.name = draftValue.name;
                        if(draftValue.dosage!=null)
                            item.dosage = draftValue.dosage;
                        if(draftValue.dosageForm!=null)
                            item.dosageForm = draftValue.dosageForm;
                        if(draftValue.frequency!=null)
                            item.frequency = draftValue.frequency;
                    }
                })
            })


            this.data = [];
            this.data = arrCopy;

            this.showSuccessMessage();
        }
        catch(error){
            console.log('Error')

            console.log(error.message)
        }

    }

    clearDraftValues() {
        const datatable = this.template.querySelector("lightning-datatable");
        if (datatable) {
          datatable.draftValues = null;
        }
    }

    showSuccessMessage() {
        this.dispatchEvent(
          new ShowToastEvent({
            title: "Успіх",
            message: "Комплекти успішно оновлено",
            variant: "success"
          })
        );
      }


    handleOkay(event){

        let dataToReturn = [];

        this.data.forEach(item=>{
            if(item.name!=null||item.name!=undefined){
                dataToReturn.push(item);
            }
        })

        this.close(dataToReturn);

    }

}