import { LightningElement, track, api } from 'lwc';
import injectJobs from '@salesforce/apex/WebApiCaller.injectJobsIntoDatabase';

export default class ButtonBasic extends LightningElement {
    @track clickedButtonLabel;

    @track injectJobStatus;
    @track injectJobError;

    @api inputJobTitle = '';
    @api inputJobLocation = '';

    handleClick(event) {
        this.clickedButtonLabel = event.target.label;
        injectJobs({jobTitle: this.inputJobTitle, location: this.inputJobLocation})
            .then(result => {
                this.injectJobStatus = result;
                window.console.log("injection status:");
                window.console.log(this.injectJobStatus);
            })
            .catch(error => {
                this.injectJobError = error;
                window.console.log("Error status:");
                window.console.log(this.injectJobError);
            });

    }
}
