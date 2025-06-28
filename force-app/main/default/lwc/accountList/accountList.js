import { LightningElement, wire } from 'lwc';
import { getListUi } from 'lightning/uiListApi';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

export default class AccountList extends LightningElement {
    accounts;
    error;

    @wire(getListUi, {
        objectApiName: ACCOUNT_OBJECT,
        listViewApiName: 'AllAccounts', // Você pode trocar pela sua ListView
        pageSize: 10
    })
    listViewHandler({ data, error }) {
        if (data) {
            this.accounts = data.records.records.map(record => ({
                Id: record.id,
                Name: record.fields.Name.value
            }));
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }
}
