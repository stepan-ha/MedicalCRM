import { LightningElement, api, track } from 'lwc';
import addMedicalModal from 'c/addMedicalModal';

import updateMedicals from '@salesforce/apex/MedicalsController.updateMedicals'
import getMedicals from '@salesforce/apex/MedicalsController.getMedicals'

export default class MedicalNoteMedicineCMP extends LightningElement {

    @api recordId;

    @track medicals;

    connectedCallback(){

        console.log('RecordId: ' + this.recordId);

        getMedicals({recordId: this.recordId}).then(result=>{

            this.medicals = result!=null||result!=null?JSON.parse(result):[];

        })        

    }

    handlerRemove(event){

        console.log('Remove CMP');

        let idToRemove = event.detail.id;

        let dataCopy = JSON.parse(JSON.stringify(this.medicals));

        let i = 0;

        console.log('idToRemove: ' + idToRemove);

        while (i < dataCopy.length) {
            console.log('dataCopy[i].id: ' + dataCopy[i].id);
            if (dataCopy[i].id == idToRemove) {
                console.log('Found');
                dataCopy.splice(i, 1);
            } else {
                i++;
            }
        }

        updateMedicals({recordId: this.recordId, dataJSON: JSON.stringify(dataCopy)})
        .then(res=>{
            getMedicals({recordId: this.recordId}).then(result=>{

                this.medicals = [];

                this.medicals = result!=null||result!=null?JSON.parse(result):[];
    
            }) 
        })

        

    }

     handlerManage(event){

        console.log('Modal');

        let stringInput = this.medicals;

        console.log(stringInput);

        addMedicalModal.open({
            medicals : stringInput,
            size: 'medium' //small, medium, large, and full
        }).then((result) => {
            console.log(result);

            if(result != undefined || result != null){
                this.medicals = [];

                this.medicals = result;

                updateMedicals({recordId: this.recordId, dataJSON: JSON.stringify(result)});

            }

        });

    }

    handlerGeneratePDF(event){

        console.log('Generate PDF');

        

    }


}