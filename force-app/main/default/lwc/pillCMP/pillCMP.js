import { LightningElement, api } from 'lwc';

export default class PillCMP extends LightningElement {

    @api name
    @api id

    handlerRemove(event){

        console.log('Remove!');

        console.log(this.id);

        this.dispatchEvent(new CustomEvent('remove', {detail: {id: this.id.split('-')[0]}}));

    }

    handlerIconEnter(event){

        console.log('Mouse Here!');
        event.target.classList.add('border-light');

    }

    handlerIconLeave(event){

        console.log('Mouse Left');
        event.target.classList.remove('border-light');

    }

}