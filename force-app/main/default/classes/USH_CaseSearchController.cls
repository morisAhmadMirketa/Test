/**
 * Created By - Moris Ahmad
 * Created Date - 20 June 2023
 * Last Modified Date - 12 July 2023
 * Test Class Name - USH_CaseSearchControllerTest
 * Description - Controller class for USH_CustomSearch component that fetches the key i.e the caseNumber from from the component input and searches
 *               that caseNumber also it checks its access through hasAccess method if the user has access simply shows in datatable and if does not
 *               have acces then it shows custom message.
 **/
public without sharing class USH_CaseSearchController {
    @AuraEnabled
    public static CaseWrapper findBy(String key){
        
        key=key.trim();
        key=String.escapeSingleQuotes(key);
        CaseWrapper wrapper = new CaseWrapper();
        List<Case> searchResults =  new List<Case>();
        try {
            if(key == ''){
                wrapper.cases = new List<Case>{};
                return wrapper;
            }
            
            
            if(Schema.sObjectType.Case.isQueryable() && Schema.sObjectType.Case.fields.CaseNumber.isAccessible() && Schema.sObjectType.Case.fields.Status.isAccessible() && Schema.sObjectType.Case.fields.OwnerId.isAccessible() && Schema.sObjectType.User.fields.Name.isAccessible()){
            searchResults = [SELECT Id, CaseNumber, Status, OwnerId, Owner.Name From Case WHERE CaseNumber =:key LIMIT 1];
            }
             
            
            //Setting Wrapper class methods.
            if(searchResults.size() > 0){
                Case searchResult = searchResults[0];
                wrapper.cases = searchResults;
                wrapper.hasAccess = hasAccess(searchResult.Id);
            }
            
            //Setting Wrapper class empty if the query doesn't fetch any record.
            else{
                wrapper.cases = new list<case>();
                wrapper.hasAccess = false;
            }
        } catch (Exception e) { Orld_Exception__c ex = new Orld_Exception__c(); ex.Name = 'UO-CaseSearchControllerException'; wrapper.errorMessage = e.getMessage(); ex.Orld_Error_Message__c = e.getMessage(); ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber()); if(Schema.sObjectType.Orld_Exception__c.isAccessible() && Schema.sObjectType.Orld_Exception__c.isCreateable() && Schema.sObjectType.Orld_Exception__c.isUpdateable() && Schema.sObjectType.Orld_Exception__c.fields.Name.isCreateable() && Schema.sObjectType.Orld_Exception__c.fields.Orld_Error_Message__c.isCreateable() && Schema.sObjectType.Orld_Exception__c.fields.Orld_Line_Number__c.isCreateable() && Schema.sObjectType.Orld_Exception__c.fields.Orld_Case_Id__c.isCreateable()){ insert ex; } }
        
        return wrapper;
        
        
    }
    
    @AuraEnabled
    public static boolean hasAccess(Id caseId){ 
        Id currentUser = userInfo.getUserId();
        UserRecordAccess userAccess;
        if(Schema.sObjectType.UserRecordAccess.isQueryable() && Schema.sObjectType.UserRecordAccess.fields.RecordId.isAccessible() && Schema.sObjectType.UserRecordAccess.fields.HasReadAccess.isAccessible()){
        userAccess =  [SELECT RecordId, HasReadAccess From UserRecordAccess WHERE RecordId =: caseId AND UserId =: currentUser LIMIT 1];
        }
        Boolean access = userAccess.HasReadAccess;
        return access; //returns true or false if the user have access or not.
    }

	public class CaseWrapper {
        
    	@AuraEnabled
    	public List<Case> cases { get; set; }
    
   	 	@AuraEnabled
    	public Boolean hasAccess { get; set; }

        @AuraEnabled
        public String errorMessage { get; set; }
	}   
}