//To customize this function to your needs)
//CTRL+F : Apex, 
// Api fields  - fill out 
// change button label 
// Name this component properly. 

import { LightningElement, api, track } from 'lwc';
// importing to show toast notifictions
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

import doActionFunctionFromApexClass from '@salesforce/apex/LWCExampleController.deleteJobs';

const defaultButtonLabel = 'testing button label';
const processingButtonLabel = 'Processing....';

export default class DeleteJobsButton extends LightningElement {


    
    //Imported from elsewhere
    @api selectedRecords; //from the Datatable. Every time you click a row this value will get updated.
    // @api buttonLabel; 
    @api recordsCount;
    @api successToastMessage; //in the format of "success! 8 <message>"
    @api errorToastMessageTitle; //title of your error message (the body is the error)
    
    // non-reactive variables
    @track isProcessing = false; //track if an action is happening
    @track buttonLabel= defaultButtonLabel;

    // changes button label to processing... and calls the action 
    doActionWrapper() {
        if (this.selectedRecords) {
            // setting values to reactive variables
            this.buttonLabel = processingButtonLabel;
            this.isProcessing = true;

            // calling apex class to delete selected records.
            this.doAction();
        }
    }

    doAction() {
        doActionFunctionFromApexClass({apexListVarname: this.selectedRecords})
        .then(result => {
            window.console.log('result ====> ' + result);
            
            this.buttonLabel = defaultButtonLabel;
            this.isProcessing = false;

            // showing success message
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success!!', 
                    message: this.recordsCount + ' ' + this.successToastMessage, 
                    variant: 'success'
                }),
            );
            
            this.fireRefreshTableEvent();

        })
        .catch(error => {
            window.console.log(error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.errorToastMessageTitle, 
                    message: error.message, 
                    variant: 'error'
                }),
            );
        });
    }
    
    fireRefreshTableEvent() {
        const selectEvent = new CustomEvent('refreshtable', {
            detail: defaultButtonLabel + ' ==> this button fired a refreshtable event'
        });
        this.dispatchEvent(selectEvent);
    }

}