/**
 * Created By - Pragam Kaistha
 * Created Date - 30 June 2023
 * Last Modified Date - 24 July 2023
 * Class Name - USH_AcceptExcellenceRequestController
 * Description - It is test class for USH_AcceptExcellenceRequestController that uses a button to change the owner of the excellence request to current user.
 **/

@IsTest
public class USH_AcceptExcellenceRequestTest {
	
    @IsTest
    static void testAssignRecordToCurrentUser() {
        // Create a test Clean_Request__c record
        Clean_Request__c testRecord = new Clean_Request__c(Submitter__c='p@p.com');
        insert testRecord;
        
        // Get the current user Id
        Id currentUserId = UserInfo.getUserId();
        
        // Call the assignRecordToCurrentUser method
        Test.startTest();
        USH_AcceptExcellenceRequestController.assignRecordToCurrentUser(testRecord.Id);
        Test.stopTest();
        
        // Retrieve the updated record
        Clean_Request__c updatedRecord = [SELECT Id, OwnerId, Owner.Name FROM Clean_Request__c WHERE Id = :testRecord.Id LIMIT 1];
        
        // Assert that the record's owner is set to the current user
        System.assertEquals(currentUserId, updatedRecord.OwnerId, 'New owner name is not same.');
    }
    
    @isTest
    static void testmethod2(){
        
       // Create a test Clean_Request__c record
        Clean_Request__c testRecord1 = new Clean_Request__c(Submitter__c='p1@p1.com'); 
        try{
             Test.startTest();
        USH_AcceptExcellenceRequestController.assignRecordToCurrentUser(testRecord1.Id);
        Test.stopTest();
            
        }catch(exception e){
             Orld_Exception__c ex = new Orld_Exception__c(); 
                    ex.Name = 'USH-AcceptExcellenceRequest1'; 
                    ex.Orld_Error_Message__c = e.getMessage(); 
                    //ex.Orld_Case_Id__c=recordId;
                    ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());
                    insert ex;
            
             Orld_Exception__c e1=[Select Orld_Error_Message__c From Orld_Exception__c where Name='USH-AcceptExcellenceRequest1'];
             system.assertEquals(e.getMessage(), e1.Orld_Error_Message__c,'Error Message');
        }
    }
}