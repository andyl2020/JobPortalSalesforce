import {LightningElement, track, wire} from 'lwc';

// importing apex class methods
// import getContacts from '@salesforce/apex/LWCExampleController.getContacts';
// import delSelectedCons from '@salesforce/apex/LWCExampleController.deleteContacts';
import getAllJobs from '@salesforce/apex/ApexJobActionController.getAllJobsQuery';
import deleteSelectedJobs from '@salesforce/apex/ApexJobActionController.deleteJobsFromList';

// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

// importing to refresh the apex after delete the records.
import {refreshApex} from '@salesforce/apex';

// datatable columns
const columnsJobs = [
    {
        label: 'Job Name',
        fieldName: 'Name'
    }, 
    {
        label: 'Job Url',
        fieldName: 'JobUrlLong__c',
        type: 'url'
    }, 
    {
        label: 'Job Company',
        fieldName: 'JobCompany__c',
        type: 'text'
    }, 
    {
        label: 'Job Summary',
        fieldName: 'JobSummary__c',
        type: 'text'
    }, {

        label: 'Last Modified',
        fieldName: 'LastModifiedDate'
    }
];

export default class DeleteRowsInDatatableLWC extends LightningElement {
    // reactive variable
    @track data;
    @track columnsJobs = columnsJobs;
    @track buttonLabel = 'Delete Selected Jobs';
    @track isTrue = false;
    @track recordsCount = 0;
    @track selectedRecords = [];

    // non-reactive variables
    refreshTableDataContainer;
    errorWhenGettingJobs;

    // retrieving the data using wire service
    // @wire(getContacts)
    // contacts(result) {
    //     this.refreshTable = result;
    //     if (result.data) {
    //         this.data = result.data;
    //         this.errorWhenGettingJobs = undefined;

    //     } else if (result.error) {
    //         this.errorWhenGettingJobs = result.error;
    //         this.data = undefined;
    //     }
    // }

    // retrieving the data using wire service
    //This is auto called because I do not see anywhere in this LWC comp where this is called (html and js) 
    @wire(getAllJobs)
    jobs(result) {
        this.refreshTableDataContainer = result;
        if (result.data) {
            this.data = result.data;
            this.errorWhenGettingJobs = undefined;

        } else if (result.error) {
            this.errorWhenGettingJobs = result.error;
            this.data = undefined;
        }
    }


    // Getting selected rows 
    getSelectedRecords(event) {
        // getting selected rows
        const selectedRows = event.detail.selectedRows;
        
        this.recordsCount = event.detail.selectedRows.length;

        // this set elements the duplicates if any
        let recordIds = new Set();

        // getting selected record id
        for (let i = 0; i < selectedRows.length; i++) {
            recordIds.add(selectedRows[i].Id);
        }

        // coverting to array
        this.selectedRecords = Array.from(recordIds);

        window.console.log('selectedRecords ====> ' +this.selectedRecords);
    }


    // delete records process function
    deleteAccounts() {
        if (this.selectedRecords) {
            // setting values to reactive variables
            this.buttonLabel = 'Processing....';
            this.isTrue = true;

            // calling apex class to delete selected records.
            this.deleteJobs();
        }
    }


    // deleteCons() {
    //     delSelectedCons({lstConIds: this.selectedRecords})
    //     .then(result => {
    //         window.console.log('result ====> ' + result);

    //         this.buttonLabel = 'Delete Selected Contacts';
    //         this.isTrue = false;

    //         // showing success message
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Success!!', 
    //                 message: this.recordsCount + ' Contacts are deleted.', 
    //                 variant: 'success'
    //             }),
    //         );
            
    //         // Clearing selected row indexs 
    //         this.template.querySelector('lightning-datatable').selectedRows = [];

    //         this.recordsCount = 0;

    //         // refreshing table data using refresh apex
    //         return refreshApex(this.refreshTable);

    //     })
    //     .catch(error => {
    //         window.console.log(error);
    //         this.dispatchEvent(
    //             new ShowToastEvent({
    //                 title: 'Error while getting Contacts', 
    //                 message: error.message, 
    //                 variant: 'error'
    //             }),
    //         );
    //     });
    // }  


    resetAndRefreshTable(){
        // Clearing selected row indexs 
        this.template.querySelector('lightning-datatable').selectedRows = [];

        this.recordsCount = 0;
        this.selectedRecords = [];

        // refreshing table data using refresh apex
        return refreshApex(this.refreshTableDataContainer);
    }

    deleteJobs() {
        deleteSelectedJobs({lstJobIds: this.selectedRecords})
        .then(result => {
            window.console.log('result ====> ' + result);

            this.buttonLabel = 'Delete Selected Jobs';
            this.isTrue = false;

            // showing success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!', 
                    message: this.recordsCount + ' Jobs are deleted.', 
                    variant: 'success'
                }),
            );
            
            this.resetAndRefreshTable();

        })
        .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error while getting Jobs', 
                    message: error.message, 
                    variant: 'error'
                }),
            );
        });
    }  

}