public with sharing class editMembershipController {
    @AuraEnabled
    public static List<MemberWrapper> findEvents(string attendId, String selection){

        List<MyEvent__c> events =  [SELECT Id, MyLocation__c, MyLocation__r.Name, Event_Organizer__c, 
                                    Event_Organizer__r.Name, Name__c, Start_Date_Time__c, 
                                    (SELECT Id, Name FROM Event_Attendees__r WHERE Attendee__c =: attendId)
                                    FROM MyEvent__c
                                    WHERE Live__c = true
                                    ];

        List<MemberWrapper> memberInfo = new List<MemberWrapper>();
        for (MyEvent__c eve : events) {
            MemberWrapper wrapper = new MemberWrapper();
            wrapper.isMember = eve.Event_Attendees__r.size() > 0;
            wrapper.myEvent = eve;
            wrapper.eventId = eve.Id;
            wrapper.eventAttendee = wrapper.isMember ? eve.Event_Attendees__r[0] : null;

            if (selection.equalsIgnoreCase('delete') && wrapper.isMember) {
                memberInfo.add(wrapper);
            } else if (selection.equalsIgnoreCase('create') && !wrapper.isMember){
                memberInfo.add(wrapper);
            }
        }
        return memberInfo;
    }

    @AuraEnabled
    public static Boolean menageMember(string attendId, String selection, List<String> eventIds){

        try {
            if (selection.equalsIgnoreCase('delete')) {
                delete [SELECT Id FROM Event_Attendee__c WHERE MyEvent__c IN : eventIds AND Attendee__c =: attendId ];
            } 
            else if (selection.equalsIgnoreCase('create')){
                List<Event_Attendee__c> lstEa = new List<Event_Attendee__c>();
                for (String str : eventIds) {
                    lstEa.add(new Event_Attendee__c(MyEvent__c = str, Attendee__c = attendId));
                }
                insert lstEa;
            }
            return true;
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }

    public class MemberWrapper {
        @AuraEnabled
        public Boolean isMember;
        @AuraEnabled
        public String eventId;
        @AuraEnabled
        public Event_Attendee__c eventAttendee;
        @AuraEnabled
        public MyEvent__c myEvent;
    }
}
