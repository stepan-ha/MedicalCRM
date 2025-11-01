import { api } from 'lwc';
import LightningModal from 'lightning/modal';


export default class ConfirmationModal extends LightningModal {

    @api type;
    @api items;

    get getContent(){
        if(this.items.length>1){
            return 'these items: ';
        }
        else{
            return 'this item: ';
        }
    }



    handleOkay() {
        this.close(true);
    }

    handleClose() {
        this.close(false);
    }
}