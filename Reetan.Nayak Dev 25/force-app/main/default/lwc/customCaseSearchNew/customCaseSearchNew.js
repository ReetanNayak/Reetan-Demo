import { LightningElement } from 'lwc';
import searchCases from '@salesforce/apex/CaseSearchController.retriveCases';

const columns = [
    {
        label: 'Subject',
        fieldName: 'Subject'
    }, {
        label: 'Case Origin',
        fieldName: 'Origin',
    }, {
        label: 'Case Reason',
        fieldName: 'Reason',
        type: 'text',
    }, {
        label: 'Type',
        fieldName: 'Type',
        type: 'text'
    },
];

export default class DynamicSearchInLWC extends LightningElement {

    searchData;
    columns = columns;
    errorMsg = '';
    strSearchCaseName = '';
    

    handleCaseName(event) {
        this.errorMsg = '';
        this.strSearchCaseName = event.currentTarget.value;
    }

    handleSearch() {
        if(!this.strSearchCaseName) {
            this.errorMsg = 'Please enter account name to search.';
            this.searchData = undefined;
            return;
        }

        searchCases({strCaseName : this.strSearchCaseName})
        .then(result => {
            this.searchData = result;
        })
        .catch(error => {
            this.searchData = undefined;
            if(error) {
                if (Array.isArray(error.body)) {
                    this.errorMsg = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    this.errorMsg = error.body.message;
                }
            }
        }) 
    }
}