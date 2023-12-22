/**
 * Created By - Pragam Kaistha
 * Created Date - 28 June 2023
 * Last Modified Date - 27 July 2023
 * Test Class Name - USH_AcceptExcellenceRequestTest
 * Description - It uses a button to change the owner of the excellence request to current user.
 * Update - Changes Done in checkmarx, Exceptions
 **/

public with sharing class USH_AcceptExcellenceRequestController {

     @AuraEnabled
    public static void assignRecordToCurrentUser(Id recId) {
        //To get the current user of of the system
        Id currentUserId = UserInfo.getUserId();
        try{
        if(Schema.sObjectType.Clean_Request__c.fields.OwnerId.isUpdateable() && Schema.sObjectType.Clean_Request__c.fields.Status__c.isUpdateable()){
        //if(Schema.sObjectType.Clean_Request__c.fields.OwnerId.isUpdateable() && Schema.sObjectType.Clean_Request__c.fields.Status__c.isUpdateable() && Schema.sObjectType.Case.fields.OwnerId.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
        Clean_Request__c record = [SELECT Id, OwnerId, Status__c, Owner.name FROM Clean_Request__c WHERE Id = :recId WITH SECURITY_ENFORCED LIMIT 1];
        //update previous record owner with current one
        record.OwnerId = currentUserId;
        record.Status__c = 'Open / In Progress';
        update record;
        }
        }
        Catch(Exception e){ 
            Orld_Exception__c ex = new Orld_Exception__c(); 
            ex.Name = 'USH-AcceptExcellenceRequestController'; 
            ex.Orld_Error_Message__c = e.getMessage(); 
            ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());  
            if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) { 
                insert ex; 
            }
        }
    }
}