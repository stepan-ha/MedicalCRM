import { LightningElement, api, track } from 'lwc';

export default class RcFilterPanel extends LightningElement {
	@track search = '';
	@track showFolders = true;
	@track showFiles = true;
	@track type = '';

	get typeOptions() {
		return [
			{ label: 'All', value: '' },
			{ label: 'PDF', value: 'pdf' },
			{ label: 'Word', value: 'docx' },
			{ label: 'Excel', value: 'xlsx' },
			{ label: 'Image', value: 'image' },
			{ label: 'Text', value: 'txt' }
		];
	}

	@api get value() {
		return {
			search: this.search,
			showFolders: this.showFolders,
			showFiles: this.showFiles,
			type: this.type
		};
	}

	publishChange() {
		this.dispatchEvent(new CustomEvent('filterchange', { detail: this.value }));
	}

	onSearchChange(e) {
		this.search = e.target.value;
		this.publishChange();
	}

	onToggle(e) {
		const label = e.target.label;
		if (label === 'Folders') this.showFolders = e.target.checked;
		if (label === 'Files') this.showFiles = e.target.checked;
		this.publishChange();
	}

	onTypeChange(e) {
		this.type = e.detail.value;
		this.publishChange();
	}
}

