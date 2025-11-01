import { LightningElement } from 'lwc';

export default class RcTreeGrid extends LightningElement {
	items = [
		{
			label: 'Account',
			name: 'account',
			expanded: true,
			items: [
				{
					label: 'Sub Account',
					name: 'subAccount',
					expanded: true,
					items: [
						{ label: 'Child 1', name: 'child1' },
						{ label: 'Child 2', name: 'child2' }
					]
				}
			]
		}
	];

	onSelect(event) {
		this.dispatchEvent(new CustomEvent('treeselect', { detail: event.detail }));
	}
}

