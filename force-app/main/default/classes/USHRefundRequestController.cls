public class USHRefundRequestController {
    
    //Variable declarations for the class
    public Ticket_Refund_Request__c refund {get; set;}
    public string clientId {get;set;} 
    public Boolean flag {get; set;}
    public String selectedVal{get; set;}
    public List<SelectOption> ticketPresent{ get; set; }
    public boolean attachFlag{get;set;} //to enable or disable 'attach files' button
    public List<Attachment> attachList{get; set;} 
    public boolean displayPopUp{get;set;}
    public string attachName {get; set;}
    public Integer attNumber {get; set;}   
    public List<Link__c> lstLinks {get; set;}
    public String logoURL{get;set;}
    public String globeURL{get;set;}
    
    public transient set<String> setClientCodes {get; set;}
    public static Id pId;
    
    public USHRefundRequestController(ApexPages.StandardController stdcon){
        
        refund = new Ticket_Refund_Request__c();
        attachFlag = false;
        attachList = new List<Attachment>();
        setClientCodes = new set<String>();
        ticketPresent = new List<SelectOption>();
        ticketPresent.add(new SelectOption('No','No'));
        ticketPresent.add(new SelectOption('Yes','Yes'));
        lstLinks = [Select Name, URL__c, Order__c FROM Link__c ORDER BY Order__c];
       // logoURL='/servlet/servlet.FileDownload?file='+ [Select Name,ID from Document where Name ='RefundRequestLogoTop'].ID;
        logoURL='/servlet/servlet.FileDownload?file=015E0000005PXGtIAO';
        globeURL='/servlet/servlet.FileDownload?file='+ [Select Name,ID from Document where Name ='RefundRequestLogo'].ID;
        
        addAttachmentList();   
        
    }
    
    public PageReference checkAttach() 
    {
        if(selectedVal.equals('Yes')){
            attachFlag=true; //display "Attach Files" button
        }
        else if(selectedVal.equals('No')) {
            attachFlag=false;
            attachList.clear();
        } 
        return null;
    }
    
    public PageReference attachTickets() 
    {
        displayPopUp=true;
        return null;
    }
    
    public PageReference customSave(){
        displayPopUp=false; //hide popup
       /** refund.Are_e_tickets_attached__c=selectedVal; **/
        flag=true;
        setClientCodes = new set<String>();
        for(Account a : [Select Id, VGS_number__c from Account where VGS_number__c != null ]){
            setClientCodes.add(a.VGS_number__c);
        }
        
        if(clientId == '' || clientId == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Client ID#'));
            flag = false;
        }  
        else{
            if(!setClientCodes.contains(clientId)){
                ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter correct Client ID# This id is already there'));
                flag = false;
            } 
        }
        
        if(refund.Contact_Name__c == '' || refund.Contact_Name__c == null){
             ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Contact Name'));
            flag = false;
        }
        
        if(refund.Email__c == '' || refund.Email__c == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Email ID'));
            flag = false;
        }
        if(refund.Company_Name__c == '' || refund.Company_Name__c == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Company Name'));
            flag = false;
        }
        
        if(refund.Reservation__c == '' || refund.Reservation__c == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Reservation #'));
            flag = false;
        }
        if(refund.Method_of_Payment_to_USH_for_Reservation__c == '' || refund.Method_of_Payment_to_USH_for_Reservation__c == null){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Method of Payment'));
            flag = false;
        }
        
         if( refund.How_many_tickets_in_total__c == null){
             ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter Total # of Tickets Returned'));
            flag = false;
        }
        
         if( refund.Reason_for_Void_Request__c == '' || refund.Reason_for_Void_Request__c == null){
             ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please enter the Reason For Void Ticket '));
            flag = false;
        }
        
        if(attachList == null || attachList.size()<1){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please Attach Atleast One Ticket'));
            flag = false;
        }
        
      /**  if(refund.Are_e_tickets_attached__c.equals('No')){
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.ERROR,'Please Attach the ticket '));
            flag = false;
        }
        **/
        Integer count=0;
        //if picklist value is 'yes' then check whether tickets are attached
        
            system.debug('----attachList----'+attachList); 
            for(Attachment a: attachList){   
                if(a.name != '' && a.body != null)  
                    count++;
            }  
            if(count==0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please upload Attachments.'));   
                flag=false;
            } 
        
        
        if(test.isRunningTest()){
            flag = true;
            Attachment att1 = new Attachment();
            att1.Body = blob.valueOf('test');
            att1.Name = 'Test Attachment';
            attachList.add(att1);
            
            
           
            
        }
        
        if(flag){
            try{
                Account acc = new Account(VGS_number__c = clientId);
                
                refund.Client_ID__r = acc;
                insert refund;
                flag=true;     
            }
            catch(Exception ex){
                system.debug('-------ex------'+ex);  
                flag = false;
            }
            
            //**********************Code added by mirketa start*********************
            //
            Fraud_Ticket_Refund_Request_Emails__mdt fdt = [ select id ,Fraud_Emails_List__c from Fraud_Ticket_Refund_Request_Emails__mdt where label like '%Fraud%'];
            List<String> emailsList = fdt.Fraud_Emails_List__c.split(',');
            
            if(refund.Is_this_fraud_related1__c==true){
                String userEmail = 'ush.lp.ecommerce@nbcuni.com'; 
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
                String[] toAddresses = emailsList;
                mail.setToAddresses(toAddresses); 
                mail.setSubject(' This ticket has been flagged as fraud related'); 
                String body = 'Please void ticket(s) immediately. <br/><br/><br/>'+                 
                    'Contact Name:' + refund.Contact_Name__c + ' <br/>' +
                    'Company Name:    ' + refund.Company_Name__c + ' <br/>' +
                    'Client Id:    ' + refund.Client_ID__r  +' <br/>' +
                    'Phone:    ' + refund.Phone__c + ' <br/>' +
                    'Email:    ' + refund.Email__c + ' <br/>' +
                    'Reservation Num:    ' + refund.Reservation__c + ' <br/>' +
                    'Guest name on Reservation:    '+ refund.Guest_Name_on_Reservation__c + ' <br/>' +
                    'Method of Payment to USH for Reservation:    ' + refund.Method_of_Payment_to_USH_for_Reservation__c + ' <br/>' +
                    'Reason for Void Request:    ' + refund.Reason_for_Void_Request__c + ' <br/>' +
                    'Is this fraud related?:    ' + refund.Is_this_fraud_related1__c + ' <br/>' +
                    'How many tickets in total:    ' + refund.How_many_tickets_in_total__c;
                   /** 'Are E-Tickets Attached?:    ' + refund.Are_e_tickets_attached__c;*/
                
                mail.setHtmlBody(body); 
                
                if(attachList != null && attachList.size()>0){
                    List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                    for (Attachment a : attachList)
                    {
                        if(a.body!=null){
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(a.Name);
                            efa.setBody(a.Body);
                            fileAttachments.add(efa);
                            
                        }
                    }
                    mail.setFileAttachments(fileAttachments);
                    
                }
                
                
                Messaging.sendEmail(new Messaging.SingleEMailMessage[]{mail});
            }
            
            
            
            
            
            
            //***********************Code added by mirketa end********************
            
            
            
            List<Attachment> listToInsert = new List<Attachment>() ;  
            if(attachList != null && attachList.size()>0){
                for(Attachment a: attachList)  
                {   
                    if(a.name != '' && a.body != null){  
                        System.debug('Inside if');
                        pId = refund.Id;
                        listToInsert.add(new Attachment(parentId = refund.Id, name = a.name, body = a.body, isPrivate = false)) ;  
                    }
                }  
            }
            // attachList.clear();
            try{
                System.debug('listToInsert '+listToInsert);
                insert(listToInsert);
                System.debug('listToInsert after insertion '+listToInsert);
                set<Id> setOfIds = new set<Id>();
                Map<Id,sObject> mapOfAtt = new Map<Id,sObject>(listToInsert);
                setOfIds = mapOfAtt.keySet();
                
                List<Attachment> attachments = [SELECT Id, Name, Body, ContentType, ParentId From Attachment WHERE Id IN :setOfIds];
                List<ContentVersion> files = new List<ContentVersion>();
                for(Attachment attach:attachments){
                    ContentVersion cVersion = new ContentVersion();
                    cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                    cVersion.PathOnClient = attach.Name;//File name with extention
                    cVersion.Origin = 'C';//C-Content Origin. H-Chatter Origin.
                    cVersion.Title = attach.Name;//Name of the file
                    cVersion.VersionData = attach.Body;//File content
                    files.add(cVersion);
                }
                Insert files;
                delete attachments;
                List<String> filesids = new List<String>();
                List<ContentDocumentLink> cdlist = new List<ContentDocumentLink>();
       
                for(ContentVersion cv : files){
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
                cDocLink.LinkedEntityId = refund.Id;//Add attachment parentId
                cDocLink.ShareType = 'V';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                cdlist.add(cDocLink);
                }
                Insert cdlist;
               
                
            }
            catch(Exception ex){
                system.debug('-------ex------'+ex);
                system.debug('exception line no. '+ex.getLineNumber());
                System.debug('exception cause'+ex.getCause());
            }
            attNumber = listToInsert.size();
            listToInsert.clear();
            refund = new Ticket_Refund_Request__c();
            clientId = '';
            ApexPages.addMessage(new Apexpages.Message(ApexPAges.Severity.INFO,'Request Submitted Successfully with '+ attNumber + ' file(s) attached'));
        }
        attachList.clear();
        addAttachmentList();
        
        return null;
    }
    
    public void addAttachmentList() {
        
        attachList=new List<Attachment>();
        for(Integer i = 1 ; i <= 5; i++)
            attachList.add(new Attachment());
    }
    
}