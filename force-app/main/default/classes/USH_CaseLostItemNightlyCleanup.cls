/**
 * Created By - Raghav Popli
 * Created Date - 06 December 2023
 * Last Modified Date- 07 December 2023
 * Description - This class is used to update the status of lost item records that have not been picked up, have a status of 'lost,' and have been lost for 8 days.
 **/






public with Sharing class USH_CaseLostItemNightlyCleanup implements Database.batchable<sobject>,Schedulable {
    
     
    public  Database.QueryLocator Start(Database.BatchableContext BC){
        Database.QueryLocator c;
        DescribeSObjectResult describeResult;
        
         try{
            
            if(Schema.sObjectType.Case.isAccessible()){
            describeResult = Case.getSObjectType().getDescribe();
        }
             
        Id lostItemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Lost_Item').getRecordTypeId();     
             date eightDaysAgo=system.today()-8;
             
                 String query = ' SELECT Id,CaseNumber, Lost_Item_Status__c,USH_Picked_Up__c   FROM ' + describeResult.getName() +
                    ' WHERE ' + ' RecordTypeId = :lostItemRecordTypeId AND Lost_Item_Status__c=\'Lost\' AND USH_Lost_Date__c<:eightDaysAgo And USH_Picked_Up__c=false WITH SECURITY_ENFORCED'; 
            
            
            if(Schema.sObjectType.Case.isQueryable()){
            
              c=database.getQueryLocator(Query);
        }      
        
        
    }catch (Exception e) {Orld_Exception__c ex = new Orld_Exception__c();ex.Name = 'USH-CaseLostItemNightlyCleanup';ex.Orld_Error_Message__c = e.getMessage();ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) {insert ex; } }
     
       return c; 
        
    }     
    
    public void execute(Database.BatchableContext BC,list<Case> cs){
        try{
            list<Database.SaveResult> updatedRecords;
            List<Case> newCaseList=new List<Case>();
            List<Orld_Exception__c> failedRecords=new List<Orld_Exception__c>();
        
        for(Case c: cs){
            
            c.Lost_Item_Status__c='Lost Expired';
            newCaseList.add(c);
            
        }
            
            
            if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isUpdateable()){
                
                 updatedRecords=database.update(newCaseList,false);
            }
            
            system.debug('updated'+updatedRecords.size());
            for(Database.SaveResult sr:updatedRecords){
                
                system.debug(sr);
                if(!sr.isSuccess()){
                    
                    Orld_Exception__c ex = new Orld_Exception__c();
                    
                    ex.Name = 'USH-CaseLostItemNightlyCleanup';
                    ex.Orld_Error_Message__c=sr.getErrors()[0].getMessage();
                    ex.Orld_Case_Id__c=sr.getId();
                    failedRecords.add(ex);
                }
                
                
                
                
            }
            
            if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) {
                    insert failedRecords; 
                }
            
        }catch (Exception e) {Orld_Exception__c ex = new Orld_Exception__c();ex.Name = 'USH-CaseLostItemNightlyCleanup';ex.Orld_Error_Message__c = e.getMessage();ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) {insert ex; } }
        
        
    }
                       
    public void finish(Database.BatchableContext BC){
        
        system.debug('Records Updated Successfully....');
        
    }
    
    
    public void execute(SchedulableContext Sc){
        
        USH_CaseLostItemNightlyCleanup cs =new USH_CaseLostItemNightlyCleanup();
        Database.executeBatch(cs,50);
        
    }

}