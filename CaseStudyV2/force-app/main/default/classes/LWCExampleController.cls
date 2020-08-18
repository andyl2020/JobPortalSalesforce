public inherited sharing class LWCExampleController {

    @AuraEnabled(Cacheable = true)
    public static List<Job__c> getJobs(){
        return [SELECT Id, Name, JobUrlLong__c, JobCompany__c, LastModifiedDate, JobSummary__c FROM Job__c ORDER BY Name limit 10];
    }

    // @AuraEnabled(Cacheable = true)
    // public static List<Contact> getContacts(){
    //     return [SELECT Id, FirstName,LastName, Phone, Email FROM Contact ORDER BY Name limit 10];
    // }
    
    // @AuraEnabled
    // public static void deleteContacts(list<Id> lstConIds){
    //     try {
    //         list<Contact> lstConsToDelete = new list<Contact>();
    //         System.debug('lstConIds ====> '+lstConIds);
    //         for(Id idCon : lstConIds) {
    //             lstConsToDelete.add(new Contact(Id = idCon));
    //         }
    //         if(!lstConsToDelete.isEmpty()) {
    //             delete lstConsToDelete;
    //         }
    //     }
    //     catch(Exception ex) {
    //         throw new AuraHandledException(ex.getMessage());
    //     }
    // }
    
    @AuraEnabled
    public static void deleteJobs(list<Id> lstJobIds){
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
}