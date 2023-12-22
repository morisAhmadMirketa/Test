/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest 
private class USHRefundRequestControllerTest{
    
    static Attachment att1 = new Attachment();
    static List<Account> lstAcc = new List<Account>();
    static Account acc1 = new Account();
    
    public USHRefundRequestControllerTest() {
     
    }
    
    public static void setTestData(){
        acc1.Name = 'Test Account';
        acc1.VGS_number__c = '123456789';
        lstAcc.add(acc1);
        insert lstAcc;
        
        Document doc1 = new Document(name='RefundRequestLogoTop');
        doc1.AuthorId = UserInfo.getUserId();
        doc1.FolderId = UserInfo.getUserId();
        Blob bodyBlob1=Blob.valueOf('Unit Test Attachment Body');
        doc1.body=bodyBlob1;
        insert doc1;
        
        Document doc2 = new Document(name='RefundRequestLogo');
        doc2.AuthorId = UserInfo.getUserId();
        doc2.FolderId = UserInfo.getUserId();
        Blob bodyBlob2=Blob.valueOf('Unit Test Attachment Body');
        doc2.body=bodyBlob2;
        insert doc2;
    }
    
    static testMethod void  myUnitTest() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund1 = new Ticket_Refund_Request__c();  
            USHRefundRequestController refObj = new USHRefundRequestController(new ApexPages.StandardController(refund1));
            refObj.clientId = '998877';
            refObj.refund.Email__c = 'tes@testuni.com';
            refObj.refund.Company_Name__c = 'TestCompany';
            refObj.refund.Client_ID__r = acc1;
            refObj.refund.Reservation__c = '123';
            refObj.refund.Method_of_Payment_to_USH_for_Reservation__c = 'Credit Card';
            refObj.selectedval='No';
            refObj.checkAttach();
            refObj.customSave();
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund2 = new Ticket_Refund_Request__c();  
            
            att1.Body = blob.valueOf('test');
            att1.Name = 'Test Attachment';
            USHRefundRequestController refObj2 = new USHRefundRequestController(new ApexPages.StandardController(refund2));
            refObj2.clientId = '998877';
            refObj2.refund.Email__c = 'tes@testuni.com';
            refObj2.refund.Company_Name__c = 'TestCompany';
            refObj2.refund.Client_ID__c = acc1.id;
            refObj2.refund.Reservation__c = '123';           
            refObj2.selectedval='Yes';
            refObj2.checkAttach();
            refObj2.attachTickets();
            refObj2.attachList.add(att1);
            refObj2.customSave();
        test.stopTest();
    }
    
    static testMethod void myUnitTest3() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund3 = new Ticket_Refund_Request__c();  
            USHRefundRequestController refObj3 = new USHRefundRequestController(new ApexPages.StandardController(refund3));
            refObj3.selectedval='Yes';
            refObj3.checkAttach();
            refObj3.attachTickets();
            refObj3.customSave();
        test.stopTest();
    }
    
    static testMethod void myUnitTest4() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund4 = new Ticket_Refund_Request__c();  
            USHRefundRequestController refObj4 = new USHRefundRequestController(new ApexPages.StandardController(refund4));
            refObj4.refund.Client_ID__r = acc1;
            refObj4.clientId = '11223344556677';
            refObj4.selectedval='Yes';
            refObj4.checkAttach();
            refObj4.attachTickets();
            refObj4.customSave();
        test.stopTest();
    }
    
    
     static testMethod void myUnitTest5() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund5 = new Ticket_Refund_Request__c();  
            USHRefundRequestController refObj5 = new USHRefundRequestController(new ApexPages.StandardController(refund5));
            refObj5.refund.Client_ID__r = acc1;
            refObj5.refund.Email__c = 'tes@testuni.com';
            refObj5.refund.Company_Name__c = 'TestCompany';
            refObj5.clientId = '123456789';
            refObj5.refund.Reservation__c = '123';
            refObj5.selectedval='No';
            refObj5.refund.Method_of_Payment_to_USH_for_Reservation__c = 'Credit Card';
            refObj5.checkAttach();
            refObj5.attachTickets();
            refObj5.customSave();
        test.stopTest();
    }
    
    
    static testMethod void myUnitTest6() {
        test.startTest();
            setTestData();
            Ticket_Refund_Request__c  refund6 = new Ticket_Refund_Request__c();  
            USHRefundRequestController refObj6 = new USHRefundRequestController(new ApexPages.StandardController(refund6));
            refObj6.refund.Client_ID__r = acc1;
            refObj6.refund.Email__c = 'tes@testuni.com';
            refObj6.refund.Company_Name__c = 'TestCompany';
            refObj6.clientId = '123456789';
            refObj6.refund.Reservation__c = '123';
            refObj6.selectedval='No';
            refObj6.refund.Method_of_Payment_to_USH_for_Reservation__c = 'Credit Card';
            refObj6.refund.Is_this_fraud_related1__c=true;
            refObj6.checkAttach();
            refObj6.attachTickets();
            refObj6.customSave();
        test.stopTest();
    }
    
    
    
   
    
    
    
}