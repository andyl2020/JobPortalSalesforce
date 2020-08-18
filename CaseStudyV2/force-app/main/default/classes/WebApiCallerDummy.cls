//This class is used for testing api calls and db injections, and can be deleted when things work. 
public with sharing class WebApiCallerDummy {
    public WebApiCallerDummy() {

    }

    @AuraEnabled
    public static String injectDummyJob(){
        // Add Job namd and url
        String successMessage = 'JOB WAS INSERTED!';
        Job__c jobRow = new Job__c(
            Name='HELLOOO SFDC Computing1 JOB TITLE DUMMY JOB ',
            JobUrlLong__c='https://www.google.com/');
        insert jobRow;
        System.debug(successMessage);
        System.debug(jobRow.ID);

        return successMessage;
    }

    @AuraEnabled
    public static String injectDummyJobApplication(){
        // Add account and related contact
        String successMessage = 'JOB APPLICATION WAS INSERTED!';
        JobApplication__c row = new JobApplication__c(
            Status__c='Applied' //Applied or Bookmarked
            );
        insert row;
        System.debug(successMessage);
        System.debug(row.ID);

        return successMessage;
    }


    public void callApiAnimals() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'https://th-apex-http-callout.herokuapp.com/animals'
        );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
                response.getBody()
            );
            System.debug(response.getBody());
            System.debug(results);
            // Cast the values in the 'animals' key as a list
            List<Object> animals = (List<Object>) results.get('animals');
            System.debug('Received the following animals:');
            for (Object animal : animals) {
                System.debug(animal);
            }
        }
    }

}
