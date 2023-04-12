public with sharing class eventDetailsConroller {
    @AuraEnabled
    public static List<Event_Speaker__c> getEventSpeakers(String eventId){
        return [SELECT Id, Name, Speaker__c, Speaker__r.Name, Speaker__r.Phone__c, Speaker__r.Email__c, Speaker__r.Company__c, Speaker__r.Picture__c, Speaker__r.About_Me__c 
        FROM Event_Speaker__c
        WHERE MyEvent__c =:eventId];
    }

    @AuraEnabled
    public static MyEvent__c getLctDetails(String eventId){
        return [SELECT Id, Name__c, MyLocation__c, MyLocation__r.City__c, MyLocation__r.Country__c, MyLocation__r.Land_Mark__c, MyLocation__r.Postal_Code__c, MyLocation__r.Name, MyLocation__r.State__c, MyLocation__r.Street__c
        FROM MyEvent__c
        WHERE Id =:eventId];
    }
    @AuraEnabled
    public static List<Event_Attendee__c> getAttDetails(String eventId){
        return [SELECT Id, Name, Attendee__c, Attendee__r.Name, Attendee__r.Email__c, Attendee__r.Company_Name__c, Attendee__r.MyLocation__c, Attendee__r.MyLocation__r.Name
        FROM Event_Attendee__c
        WHERE MyEvent__c =:eventId];
    }

}
