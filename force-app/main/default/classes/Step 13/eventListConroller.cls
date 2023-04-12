public with sharing class eventListConroller {
    @AuraEnabled
    public static List<MyEvent__c> cllKeyword(String name){

        String newName = '%' +name+ '%';


        return [SELECT Id, Name, Name__c, Event_Detail__c, MyLocation__c, MyLocation__r.Name, Event_Organizer__c, Start_Date_Time__c, Event_Organizer__r.Name
        FROM MyEvent__c
        WHERE Start_Date_Time__c >= TODAY
        AND Live__c = true
        AND Name__c LIKE :newName
        ];
    }

    @AuraEnabled
    public static List<MyEvent__c> cllKeyword2(){

        return [SELECT Id, Name, Name__c, Event_Detail__c, MyLocation__c, MyLocation__r.Name, Event_Organizer__c, Start_Date_Time__c, Event_Organizer__r.Name
        FROM MyEvent__c
        WHERE Start_Date_Time__c >= TODAY
        AND Live__c = true
        ];
    }
}
