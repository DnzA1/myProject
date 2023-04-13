public with sharing class EventDisplayClass {
    @AuraEnabled
    public static void searchMyEventName(String eventName){
        // List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); 
        // List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); 
        // List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); oneeeee
        // List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); oneeeee 2222
        // List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); twooooo 11111

        // String NewEventName = '%'+ eventName +'%'; 

        // lstMyEvent = [SELECT Id, Student_Name__c, Postal_Code__c, Class__c, Mobile__c, Email__c FROM Student__c WHERE Postal_Code__c Like : NewPstlCode ];
        // // return lstMyEvent;
        system.debug('gfg');
        system.debug('gfg222');
        system.debug('gfg222');
        
    }

}
