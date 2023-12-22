@isTest
public class USH_CaseLostNightlyCleanupTest {
    
    
    @isTest
    static void testMethod1(){
        
    Contact c=new Contact();
    c.FirstName='Test';
    c.LastName='Contact';
    c.Email='test123@gmail.com';
    
    insert c;
        
     list<Case> cs=new list<Case>();
      Id lostItemRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Lost_Item').getRecordTypeId();   
      Case c1=new Case();
        
        c1.RecordTypeId=lostItemRecordTypeId;
        c1.Lost_Item_Status__c='Lost';
        c1.USH_Picked_Up__c=false;
        c1.USH_Lost_Date__c=system.today()-8;
        c1.ContactId=c.Id;
        cs.add(c1);
        
         Case c2=new Case();
         c2.RecordTypeId=lostItemRecordTypeId;
        c2.Lost_Item_Status__c='Lost';
        c2.USH_Picked_Up__c=false;
        c2.USH_Lost_Date__c=system.today()-8;
       
        cs.add(c2);
        
        Database.insert(cs,false);
       
        
        Test.startTest();
        USH_CaseLostItemNightlyCleanup cl=new USH_CaseLostItemNightlyCleanup();
        Database.QueryLocator ql = cl.start(null);
        cl.execute(null,cs);
        cl.Finish(null);
        String CronExpression='0 05 * * * ?';
    System.schedule('CaseLostItemNightlyCleanup', CronExpression , cl);
        Case resultCase=[Select Lost_Item_Status__c From Case Where Id=:c1.Id ];
        System.assertEquals('Lost Expired',resultCase.Lost_Item_Status__c);
        Test.stopTest();
        
       
        
        
        
    }
    

    
    
    
        
    

}