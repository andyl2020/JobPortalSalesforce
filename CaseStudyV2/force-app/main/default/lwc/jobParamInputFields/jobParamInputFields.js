import { LightningElement, track } from 'lwc';

export default class JobParamInputFields extends LightningElement {

    @track greeting = 'Trailblazer';

    @track jobTitleSearchTerm = '';
    @track jobLocationSearchTerm = '';
    
    handleTitleChange(event) {
        this.jobTitleSearchTerm = event.target.value;
    }

    handleLocationChange(event) {
        this.jobLocationSearchTerm = event.target.value;
    }
    
    currentDate = new Date().toDateString();

    get capitalizedGreeting() {
        return `Hello ${this.greeting.toUpperCase()}!`;
    }
}