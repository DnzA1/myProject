@isTest
public with sharing class TesteditMembershipController {
    @TestSetup
    static void makeData(){
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
            me.Live__c = true;
            

            MyEvent__c me1 = new MyEvent__c();
            me1.Name__c = 'Test ME 2';
            me1.Event_Organizer__c = eoc.Id;
            me1.Max_Seats__c = 100;
            me1.Start_Date_Time__c = Datetime.now().addDays(-7);
            me1.End_Date_Time__c = Datetime.now().addMonths(3);
            me1.Live__c = true;

            MyEvent__c me2 = new MyEvent__c();
            me2.Name__c = 'Test ME 3';
            me2.Event_Organizer__c = eoc.Id;
            me2.Max_Seats__c = 100;
            me2.Start_Date_Time__c = Datetime.now().addDays(-17);
            me2.End_Date_Time__c = Datetime.now().addMonths(2);
            me2.Live__c = true;
           

            Attendee__c att = new Attendee__c();
            att.Name = 'Test';
            att.Email__c = 'test@gmail.com';
            att.Phone__c = '1231432342';
          
            insert new List<SObject>{me, me1, me2, att};

            insert new Event_Attendee__c(MyEvent__c = me1.Id, Attendee__c = att.Id);
    }

    @isTest
    static void testClear(){
        Attendee__c att = [SELECT Id FROM Attendee__c LIMIT 1];

        List<editMembershipController.MemberWrapper> results = editMembershipController.findEvents(att.Id, 'delete');
        System.AssertEquals(1, results.size());
        List<String> eventIds = new List<String>{results[0].eventId};
        
        Boolean isSuccess = editMembershipController.menageMember(att.Id, 'delete', eventIds);
        System.Assert(isSuccess);
        System.AssertEquals(0, [SELECT COUNT() FROM Event_Attendee__c WHERE Attendee__c =:att.Id]);
    }

    @isTest
    static void testAdd(){
        Attendee__c att = [SELECT Id FROM Attendee__c LIMIT 1];

        List<editMembershipController.MemberWrapper> results = editMembershipController.findEvents(att.Id, 'create');
        System.AssertEquals(2, results.size());
        List<String> eventIds = new List<String>{results[0].eventId};
        
        Boolean isSuccess = editMembershipController.menageMember(att.Id, 'create', eventIds);
        System.Assert(isSuccess);
        System.AssertEquals(2, [SELECT COUNT() FROM Event_Attendee__c WHERE Attendee__c =:att.Id]);
    }
}
