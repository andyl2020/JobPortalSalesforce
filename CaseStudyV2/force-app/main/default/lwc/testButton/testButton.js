import { LightningElement, track } from 'lwc';
import injectDummyJob from '@salesforce/apex/WebApiCallerDummy.injectDummyJob';
import injectJobs from '@salesforce/apex/WebApiCaller.injectJobsIntoDatabase';

export default class ButtonBasic extends LightningElement {
    @track clickedButtonLabel;
    @track injectDummyJobStatus
    @track injectDummyJobError

    @track injectJobStatus
    @track injectJobError

    handleClickDummy(event) {
        this.clickedButtonLabel = event.target.label;
        injectDummyJob()
            .then(result => {
                this.injectDummyJobStatus = result;
                console.log("injection status:");
                console.log(this.injectDummyJobStatus);
            })
            .catch(error => {
                this.injectDummyJobError = error;
                console.log("Error status:");
                console.log(this.injectDummyJobError);
            });

    }
    handleClick(event) {
        this.clickedButtonLabel = event.target.label;
        injectJobs({jobTitle: 'Manager', location: 'Alaska'})
            .then(result => {
                this.injectJobStatus = result;
                console.log("injection status:");
                console.log(this.injectJobStatus);
            })
            .catch(error => {
                this.injectJobError = error;
                console.log("Error status:");
                console.log(this.injectJobError);
            });

    }
}
