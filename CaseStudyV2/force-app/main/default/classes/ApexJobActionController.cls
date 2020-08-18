public with sharing class ApexJobActionController {
    public ApexJobActionController() {

    }

    //GET ALL JOBS FROM MASTER DATABASE TABLE 
    @AuraEnabled(Cacheable = true)
    public static List<Job__c> getAllJobsQuery(){
        return [SELECT Id, Name, JobUrlLong__c, JobCompany__c, LastModifiedDate, JobSummary__c FROM Job__c ORDER BY Name limit 10];
    }
    
    //DELETE JOBS 
    @AuraEnabled
    public static void deleteJobsFromList(list<Id> lstJobIds){
        try {
            list<Job__c> lstJobsToDelete = new list<Job__c>();
            System.debug('lstJobIds ====> '+lstJobIds);
            for(Id idCon : lstJobIds) {
                lstJobsToDelete.add(new Job__c(Id = idCon));
            }
            if(!lstJobsToDelete.isEmpty()) {
                delete lstJobsToDelete;
            }
        }
        catch(Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }


    //Inject jobs into database 
    @AuraEnabled
    public static void injectJobsFromListIntoLookupDb(list<Id> lstJobIds, String status){
        if (status.equals('Applied') || status.equals('Bookmarked')){
            try {
                list<JobApplication__c> lstJobsToInject = new list<JobApplication__c>();
                System.debug('lstJobIds to inject ====> '+lstJobIds);
                for(Id jobId : lstJobIds) {
                    lstJobsToInject.add(new JobApplication__c(JobReference__c = jobId, Status__c = status));
                }
                if(!lstJobsToInject.isEmpty()) {
                    insert lstJobsToInject;
                }
            }
            catch(Exception ex) {
                throw new AuraHandledException(ex.getMessage());
            }
        }
        else{
            CalloutException e = new CalloutException();
            e.setMessage('The injected status for a job application is invalid!');
            System.debug(e);
            throw e;
        }
    }



}
