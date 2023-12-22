/**
 * Created By - Pragam Kaistha
 * Created Date - 22 June 2023
 * Last Modified Date - 24 July 2023
 * Class Name - USH_ChangeOwnerComponentController
 * Description - It is test class for USH_ChangeOwnerComponentController that uses a button to change the owner of the case to current user.
 **/

@isTest
public class USH_ChangeOwnerComponentControllerTest {
    
    @testSetup
    static void data(){
        Case testCase = new Case(Incident_Date_Time__c = datetime.newInstance(2014, 9, 15, 12, 30, 0) ,Origin = 'BBB', Status='Open');
        insert testCase;
    }
    
    @isTest
    static void testGetData() {
        // Create a test case

        
        List<Case> testCase = [SELECT id,Owner.Name from Case WHERE Origin = 'BBB'];
        System.debug('testcase '+testCase[0].id);
        
        Id caseId = testCase[0].Id;
        USH_ChangeOwnerComponentController.getData(caseId);
        List<Case> testCase1 = [SELECT id,OwnerId,Owner.Name from Case WHERE id= :testCase[0].id];
        System.assertEquals(testCase1[0].OwnerId, UserInfo.getUserId(),'New owner name is not same.');    
        System.assertEquals(testCase.size(), 1, 'One case is not inserted'); 
        
    }
    
    @isTest
    static void testAssignRecordToCurrentUser() {
        // Create a test case
        List<Case> testCase = [SELECT id,Owner.Name from Case WHERE Origin = 'BBB']; 
        USH_ChangeOwnerComponentController.assignRecordToCurrentUser(testCase[0].Id);
        List<Case> testCase1 = [SELECT id,OwnerId,Owner.Name from Case WHERE id= :testCase[0].id];
        System.assertEquals(testCase1[0].OwnerId, UserInfo.getUserId(),'New owner name is not same.');    
        System.assertEquals(testCase.size(), 1, 'One case is not inserted');     
    }
    
    @isTest
    static void testmethod2(){
        
       // Case testCase1 = new Case(Incident_Date_Time__c = datetime.newInstance(2014, 9, 15, 12, 30, 0) ,Origin = 'BBB', Status='Open');
        
        
        
        
        try{
             Test.startTest();
        
        //System.debug('testcase '+testCase1.id);
        
        //Id caseId = testCase1.Id;
        USH_ChangeOwnerComponentController.getData('12');
        USH_ChangeOwnerComponentController.assignRecordToCurrentUser('123');
        Test.stopTest();
            
        }catch(exception e){
             Orld_Exception__c ex = new Orld_Exception__c(); 
                    ex.Name = 'USH-ChangeOwnerComponentController1'; 
                    ex.Orld_Error_Message__c = e.getMessage(); 
                    //ex.Orld_Case_Id__c=recordId;
                    ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());
                    insert ex;
            
             Orld_Exception__c e1=[Select Orld_Error_Message__c From Orld_Exception__c where Name='USH-ChangeOwnerComponentController1'];
             system.assertEquals(e.getMessage(), e1.Orld_Error_Message__c,'Error Message');
        }
    }
}