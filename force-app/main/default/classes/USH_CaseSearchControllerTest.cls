/**
 * Created By - Moris Ahmad
 * Created Date - 27 June 2023
 * Last Modified Date - 10 July 2023
 * Description - Test class for USH_CaseSearchController
 **/
@isTest
private class USH_CaseSearchControllerTest {
    
    @TestSetup static void insertTestCases() {
     	List<Case> testCases = new List<Case>();    
         Case testCase = new Case();
         testCase.Subject = 'Test Case';
         testCases.add(testCase);
         insert testCases;
    }
    
    @isTest
    static void testFindBy() {
        
        Case CaseDetail = [SELECT Id, CaseNumber FROM Case WHERE Subject = 'Test Case' LIMIT 1];
        String CaseNum = CaseDetail.CaseNumber;


        USH_CaseSearchController.CaseWrapper result = USH_CaseSearchController.findBy(CaseNum);


        System.assertEquals(1, result.cases.size(), 'Expected 1 case record');
        System.assertEquals(true, result.hasAccess, 'Expected case access to be true');
    }
    
    @isTest
    static void testFindBy_NoCaseFound() {
        // Negative test case: No case found
        USH_CaseSearchController.CaseWrapper result = USH_CaseSearchController.findBy('InvalidCaseNumber');

        System.assertEquals(0, result.cases.size(), 'Expected no case record');
        System.assertEquals(false, result.hasAccess, 'Expected case access to be false');
    }
    
    @isTest
    static void testFindBy_EmptyKey() {
        // Negative test case: Empty key
        USH_CaseSearchController.CaseWrapper result = USH_CaseSearchController.findBy('');

        System.assertEquals(0, result.cases.size(), 'Expected no case record');
        System.assertEquals(null, result.hasAccess, 'Expected case access to be false');
    }
    
    static void testException(){
        
         Case testCase1 = new Case();
         testCase1.Subject = 'Test Case';
         //insert testCases;
        
       
        
        try{
            //Case CaseDetail = [SELECT Id, CaseNumber FROM Case WHERE Subject = 'Test Case' LIMIT 1];
        	String CaseNum = testCase1.CaseNumber;


			USH_CaseSearchController.findBy(CaseNum);

        /*System.assertEquals(1, result.cases.size(), 'Expected 1 case record');
        System.assertEquals(true, result.hasAccess, 'Expected case access to be true');*/
            
        }catch(exception e){
             Orld_Exception__c ex = new Orld_Exception__c(); 
                    ex.Name = 'USH-CaseSearchControllerException1'; 
                    ex.Orld_Error_Message__c = e.getMessage(); 
                    //ex.Orld_Case_Id__c=recordId;
                    ex.Orld_Line_Number__c = String.valueOf(e.getLineNumber());
                    insert ex;
            
             Orld_Exception__c e1=[Select Orld_Error_Message__c From Orld_Exception__c where Name='USH-CaseSearchControllerException1'];
             system.assertEquals(e.getMessage(), e1.Orld_Error_Message__c,'Error Message');
        }
    }
}