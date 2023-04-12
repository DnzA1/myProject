public with sharing class attEvntConroller {

    @AuraEnabled
    public static List<MemberWrapper> eventAttUpcoming(string attendId){

        List<MyEvent__c> events =  [SELECT Id, MyLocation__c, MyLocation__r.Name, Event_Organizer__c, Event_Organizer__r.Name, Name__c, Start_Date_Time__c, (SELECT Id, Name 
                FROM Event_Attendees__r 
                WHERE Attendee__c =: attendId)
                FROM MyEvent__c
                WHERE Start_Date_Time__c >= TODAY
                AND Live__c = true
        ];

        List<MemberWrapper> memberInfo = new List<MemberWrapper>();
        for (MyEvent__c eve : events) {
            MemberWrapper wrapper = new MemberWrapper();
            wrapper.isMember = eve.Event_Attendees__r.size() > 0;
            wrapper.myEvent = eve;
            wrapper.eventId = eve.Id;
            wrapper.eventAttendee = wrapper.isMember ? eve.Event_Attendees__r[0] : null;
            memberInfo.add(wrapper);
        }
        return memberInfo;
    }


    @AuraEnabled
    public static List<Event_Attendee__c> eventAtt(string attendId){

        return [SELECT Id, Name, MyEvent__c, MyEvent__r.MyLocation__c, MyEvent__r.MyLocation__r.Name, MyEvent__r.Event_Organizer__c, MyEvent__r.Event_Organizer__r.Name, MyEvent__r.Name__c, MyEvent__r.Start_Date_Time__c
                FROM Event_Attendee__c
                WHERE Attendee__c =: attendId
                AND MyEvent__r.Start_Date_Time__c < TODAY
        ];
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
