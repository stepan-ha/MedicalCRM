import { LightningElement, api } from 'lwc';
import RESOURCE_ICONS from '@salesforce/resourceUrl/ResourceIcons';

export default class RcIcon extends LightningElement {
	@api name;
	@api path = '';
	@api ext = 'png';
	@api size = 24;
	@api alt = '';
	@api variant;

	get iconUrl() {
		const base = RESOURCE_ICONS;
		const internalPath = this.path ? this.path : (this.name ? `${this.name}.${this.ext}` : '');
		return internalPath ? `${base}/${internalPath}` : '';
	}

	get computedClass() {
		const classes = ['rc-icon'];
		if (this.variant) classes.push(`rc-icon_${this.variant}`);
		return classes.join(' ');
	}
}

