import { LightningElement, api } from 'lwc';

export default class RcFileRow extends LightningElement {
	@api file;
	@api actions = [];
	@api selected = false;
	@api selectedPdfs = [];

	get containerClass() {
		return this.selected ? 'item selected' : 'item';
	}

    get iconPath(){
        return 'SharePointIcons/' + this.file.iconName;
    }

	onSelect(event) {
		this.dispatchEvent(new CustomEvent('click', { detail: { id: this.file.id }, bubbles: true, composed: true }));
	}

	onOpen(event) {
		this.dispatchEvent(new CustomEvent('open', { detail: { id: this.file.id }, bubbles: true }));
	}

	onAction(event) {
		const action = event.detail.value || event.target.value;
		this.dispatchEvent(
			new CustomEvent('rowaction', {
				detail: { action, id: this.file.id },
				bubbles: true
			})
		);
	}

	onDragStart(event){
		let items = [];
		const isPdf = this.file && this.file.file && this.file.file.mimeType && this.file.file.mimeType.includes('application/pdf');
		const selectedHasPdfs = Array.isArray(this.selectedPdfs) && this.selectedPdfs.length > 0;
		if (this.selected && selectedHasPdfs) {
			items = this.selectedPdfs;
		} else if (isPdf) {
			items = [{ id: this.file.id, name: this.file.name, downloadUrl: this.file.downloadUrl, webUrl: this.file.webUrl }];
		}
		try{
			event.dataTransfer.setData('application/json', JSON.stringify({ type: 'pdf-list', items }));
		}catch(e){ /* no-op */ }
	}
}

