/**
 * Created By - Pragam Kaistha
 * Created Date - 21 June 2023
 * Last Modified Date - 27 July 2023
 * Test Class Name - USH_ChangeOwnerComponentControllerTest
 * Description - It gets the current owner name of case and uses a button to change the owner of case to current user.
 * Update: Added with security enforced - checkmarx, Exceptions
 **/

public with sharing class USH_ChangeOwnerComponentController {
	
    @AuraEnabled
    public static String getData(Id recId){
        //Get the owner name of current case
        try{
        If(Schema.sObjectType.Case.isQueryable() && Schema.sObjectType.Case.fields.OwnerId.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
            List<Case> caseList = [Select Owner.name from Case where id = :recId Limit 1];
            if(caseList.size()>0){
            return caseList[0].Owner.Name;
            }
        }
           
        }
        Catch(Exception e){  Orld_Exception__c ex = new Orld_Exception__c(); ex.Name = 'USH-ChangeOwnerComponentController'; ex.Orld_Error_Message__c = e.getMessage(); ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());             if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) {  insert ex;  }  } return null; 

    }
    
    @AuraEnabled
    public static String assignRecordToCurrentUser(Id recId) {
        //To get the current user of of the system
        Id currentUserId = UserInfo.getUserId();
        try{
        if(Schema.sObjectType.Case.isQueryable() && Schema.sObjectType.Case.fields.Id.isAccessible() && Schema.sObjectType.Case.fields.OwnerId.isAccessible() && Schema.sObjectType.Case.fields.OwnerId.isUpdateable() && Schema.sObjectType.User.fields.Name.isAccessible()){
        	List<Case> record = [SELECT Id, OwnerId, Owner.name FROM Case WHERE Id = :recId WITH SECURITY_ENFORCED LIMIT 1];
        
        	//update previous record owner with current one
        	if(record.size()>0){
                
        	record[0].OwnerId = currentUserId;
        	if(Schema.sObjectType.Case.isAccessible() && Schema.sObjectType.Case.isUpdateable()){
        		update record;
        	}
               
        	return record[0].Owner.Name;
            }
        }
        }
        Catch(Exception e){ Orld_Exception__c ex = new Orld_Exception__c();  ex.Name = 'USH-ChangeOwnerComponentController'; ex.Orld_Error_Message__c = e.getMessage(); ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());                            if (Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable()) { insert ex; } } return null;

    }
}