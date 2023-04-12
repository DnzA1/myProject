public with sharing class EventDisplayClass {
    @AuraEnabled
    public static List<MyEvent__c> searchMyEventName(String eventName){
        List<MyEvent__c> lstMyEvent = new List<MyEvent__c>(); 

        String NewEventName = '%'+ eventName +'%'; 

        lstMyEvent = [SELECT Id, Student_Name__c, Postal_Code__c, Class__c, Mobile__c, Email__c FROM Student__c WHERE Postal_Code__c Like : NewPstlCode ];

        return lstMyEvent;
    }

}
