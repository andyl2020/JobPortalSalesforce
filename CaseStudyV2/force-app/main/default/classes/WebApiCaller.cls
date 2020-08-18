public with sharing class WebApiCaller {
    public WebApiCaller() {
    }

    @AuraEnabled
    public static String injectJobIntoDatabase(String jobName, String jobCompany, String jobUrl, String jobSummary){
        // Add Job namd and url
        String successMessage = 'JOB WAS UPSERTED Into the database!';
        try {
            Job__c jobRow = new Job__c(
                Name=jobName,
                JobUrlLong__c=jobUrl,
                JobCompany__c=jobCompany,
                JobSummary__c=jobSummary);
            upsert jobRow Job__c.Fields.Name;
            successMessage = successMessage + '\n The job name is: ' + jobName + '\n and company is: ' + jobCompany + '\n And the DB id is: ' + jobRow.ID + '\n job summary: ' + jobSummary;
            System.debug(successMessage);
            System.debug('The row ID is: ' + jobRow.ID);

        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
         
        return successMessage;
    }

    @AuraEnabled
    public static List<String> injectJobsIntoDatabase(String jobTitle, String location){

        List<String> apiCallResults = new List<String>();
        //call api and get a list of jobs 
        // List<JobApiResultTemplate> jobs = WebApiCaller.getJobs('Manager', 'Alaska');
        List<JobApiResultTemplate> jobs = WebApiCaller.getJobs(jobTitle, location);
        
        //pick out the job params that we want 
        // JobApiResultTemplate job = jobs[0];
        String jobName;
        String jobCompany;
        String jobUrl;
        String jobSummary;

        String apiCallResult;

        for (JobApiResultTemplate job : jobs){
            if(job.job.title == null){
                jobName = 'Dummy text. No Job title field found.';
            } 
            else{
                jobName = job.job.title;
            }

            jobCompany = job.job.company;
            jobUrl = job.job.href;
            jobSummary = job.job.summary;

            //insert into the database
            try {
                apiCallResult = WebApiCaller.injectJobIntoDatabase(jobName, jobCompany, jobUrl, jobSummary);
                apiCallResults.add(apiCallResult);

            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }

        return apiCallResults;
         
    }


    public static List<JobApiResultTemplate> getJobs(String jobTitle, String location) {
        Http http = new Http();
        List<JobApiResultTemplate> results;
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            'https://lfws.herokuapp.com/v1/jobs?jobTitle='+ jobTitle + '&location=' + location
            // 'https://lfws.herokuapp.com/v1/jobs?jobTitle=Manager&location=Alaska'
        );
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);
            results = (List<JobApiResultTemplate>)JSON.deserialize(response.getBody(), List<JobApiResultTemplate>.class);
            if (response.getStatusCode() == 200) {
                // System.debug(results);
                System.debug('printing all jobs:');
                for (JobApiResultTemplate job: results){
                    System.debug('\n\nprinting job details:');
                    System.debug('Link is:' + job.job.href);
                    // System.debug(job.job.title); //TODO: sometimes does not show up 
                    System.debug('Company is:' + job.job.company);
                    System.debug('Job summary (using as title for now) is: ' + job.job.summary); //Use this as a temp job title for now
                    // System.debug(job.job.location); // inaccurate sometimes 
                    // System.debug(job.location[0].address); //sometimes this does not give an array (error on Adam's api side)

                }
            }
            else{
                System.debug('HTTP response is not 200!');
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }

        
        return results;
    }

    public static void callApiLwc() {
    // public void callApiLwc(String jobTitle, String location) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(
            // 'https://lfws.herokuapp.com/v1/jobs?jobTitle='+ jobTitle + '&location=' + location
            'https://lfws.herokuapp.com/v1/jobs?jobTitle=Manager&location=Alaska'
        );
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        List<JobApiResultTemplate> results = (List<JobApiResultTemplate>)JSON.deserialize(response.getBody(), List<JobApiResultTemplate>.class);
        


        // If the request is successful, parse the JSON response.
        // List<Object> jobs = new List<Object>();
        //Map<Object, Object> results = (Map<Object, Object>) JSON.deserializeUntyped(response.getBody());

        // properly parse the json object:

        // jsonObject = new JSONObject(results.trim());
        // Iterator<String> keys = jsonObject.keys();

        // while(keys.hasNext()) {
        //     String key = keys.next();
        //     if (jsonObject.get(key) instanceof JSONObject) {
        //           // do something with jsonObject here
        //     }
        // }

        if (response.getStatusCode() == 200) {
            // System.debug(results);
            System.debug('printing all jobs:');
            for (JobApiResultTemplate job: results){
                System.debug('\n\nprinting job details:');
                System.debug(job.job.href);
                // System.debug(job.job.title); //TODO: sometimes does not show up 
                System.debug(job.job.company);
                System.debug(job.job.summary); //Use this as a temp job title for now
                // System.debug(job.job.location); // inaccurate sometimes 
                System.debug(job.location[0].address);

            }



            // System.debug(response.getBody());
            // for (Object job: response.getBody()) {
            //     System.debug(job);
            // }
        }
        else{
            System.debug('Error sending HTTP request (jobs) !');
        }
    }

}

// used to execute:
// WebApiCaller foo = new WebApiCaller();
// foo.callApiLwc();



// used to query execute:
// FIND {SFDC} IN ALL FIELDS
//                    RETURNING Account(Name),Contact(FirstName,LastName,Department), Job__c(Name)


