@RestResource(urlMapping='/EventMangmnt/*')
global with sharing class InboundEventMng {

@RestResource(urlMapping='/EventMangmnt/*')
// system.debug('URL: '+ URL.getOrgDomainUrl().toExternalForm()) === https://eventmanagement85-dev-ed.my.salesforce.com
// https://eventmanagement85-dev-ed.my.salesforce.com/services/apexrest/

    @HttpGet
    global static List<EventWrapper> doGet() {
        List<EventWrapper> lstEvntWrppr = new List<EventWrapper>();

        List<MyEvent__c> lstMyEvnt = [SELECT Id, Name, Name__c, Start_Date_Time__c, End_Date_Time__c, Live__c, Event_Organizer__r.Name 
                                      FROM MyEvent__c 
                                      WHERE Live__c = true 
                                      AND Start_Date_Time__c >= TODAY 
                                      WITH SECURITY_ENFORCED
                                     ];

        for (MyEvent__c mye : lstMyEvnt) {
            lstEvntWrppr.add(new EventWrapper(mye));
        }

        return lstEvntWrppr;
    }

    global class EventWrapper {
        global string eventId;
        global string stdName;
        global string Name;
        global String startDate;
        global String endDate;
        global string eventLive;
        global string eventOrganizer;

            global EventWrapper (MyEvent__c evn){
                this.eventId = evn.Id;
                this.stdName = evn.Name;
                this.Name = evn.Name__c;
                this.startDate = evn.Start_Date_Time__c.format('yyyy-MM-dd HH-mm');
                this.endDate = evn.End_Date_Time__c.format('yyyy/MM-DD HH-MM');
                this.eventLive = String.valueOf(evn.Live__c);
                this.eventOrganizer = evn.Event_Organizer__r.Name;
            }
    }

}
