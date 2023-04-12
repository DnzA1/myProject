@isTest
public with sharing class InboundEventMngTEST {
    @isTest
    public static void tester() {

        Event_Organizer__c eoc = new Event_Organizer__c();
            eoc.Name = 'Test EO';
            eoc.Phone__c = '123456';
            eoc.Email__c = 'testeo@gmail.com';
        insert eoc;

        MyEvent__c me = new MyEvent__c();
            me.Name__c = 'Test ME';
            me.Event_Organizer__c = eoc.Id;
            me.Max_Seats__c = 100;
            me.Start_Date_Time__c = Datetime.now().addDays(10);
            me.End_Date_Time__c = Datetime.now().addDays(30);
            me.Live__c = True;
        insert me;

        Test.startTest();
            RestContext.request = new RestRequest();
            RestContext.response = new RestResponse();
            RestContext.request.requestURI = '/services/apexrest/EventMangmnt/';
            RestContext.request.httpMethod = 'GET';
        Test.stopTest();

        List<InboundEventMng.EventWrapper> myEvnt = InboundEventMng.doGet();
        system.AssertEquals(1, myEvnt.size());
        
        InboundEventMng.EventWrapper result = myEvnt[0];
        system.AssertEquals('Test ME', result.Name);
    }

}
