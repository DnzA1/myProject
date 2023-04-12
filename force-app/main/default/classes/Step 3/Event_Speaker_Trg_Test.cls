@isTest
public with sharing class Event_Speaker_Trg_Test {

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
            me.Live__c = True;
            insert me;

        Speaker__c spk = new Speaker__c();
            spk.Name = 'Test Speak';
            spk.Email__c = 'testSpeak@gmail.com';
            spk.Phone__c = '3456789';
            insert spk;

        Speaker__c spk5 = new Speaker__c();
            spk5.Name = 'Test Speak5';
            spk5.Email__c = 'testSpeak@gmail.com';
            spk5.Phone__c = '34567895';
            insert spk5;

        Event_Speaker__c es = new Event_Speaker__c();
            es.MyEvent__c = me.Id;
            es.Speaker__c = spk.Id;
            insert es;
    }

    @isTest
    public static void check_Duplication_Test_1(){

        Event_Speaker__c  esq = [SELECT Id, MyEvent__c, Speaker__c FROM Event_Speaker__c];

        Test.startTest();
        try {
            Event_Speaker__c es = new Event_Speaker__c();
            es.MyEvent__c = esq.MyEvent__c;
            es.Speaker__c = esq.Speaker__c;
            insert es;
        } catch (Exception ex) {
            system.debug(ex);
        }
        Test.stopTest();
        List<Event_Speaker__c> lstEs= [SELECT Id FROM Event_Speaker__c];
        system.AssertEquals(1,lstEs.size());
    }

    @isTest
    public static void check_Duplication_Test_2(){
        // Event_Speaker__c esql = [SELECT Id FROM Event_Speaker__c];
        // delete esql;
        
        MyEvent__c evqry = [SELECT Id FROM MyEvent__c];
        Speaker__c spqry = [SELECT Id FROM Speaker__c WHERE Name = 'Test Speak5'];

        Test.startTest();
        Event_Speaker__c es = new Event_Speaker__c();
        es.MyEvent__c = evqry.Id;
        es.Speaker__c = spqry.Id;
        insert es;
        Test.stopTest();

        List<Event_Speaker__c> lstEs= [SELECT Id FROM Event_Speaker__c];
        system.AssertEquals(2,lstEs.size());
    }

    // @isTest
    // public static void check_Duplication_Test_3(){
    //     // Event_Speaker__c esql = [SELECT Id FROM Event_Speaker__c];
    //     // delete esql;

    //     Event_Organizer__c eoc = new Event_Organizer__c();
    //         eoc.Name = 'Test EO1';
    //         eoc.Phone__c = '1234567';
    //         eoc.Email__c = 'testeo1@gmail.com';
    //         insert eoc;

    //     MyEvent__c me = new MyEvent__c();
    //         me.Name__c = 'Test ME1';
    //         me.Event_Organizer__c = eoc.Id;
    //         me.Max_Seats__c = 100;
    //         me.Start_Date_Time__c = Datetime.now().addDays(10);
    //         me.End_Date_Time__c = Datetime.now().addDays(30);
    //         me.Live__c = True;
    //         insert me;

    //     Speaker__c spk = new Speaker__c();
    //         spk.Name = 'Test Speak1';
    //         spk.Email__c = 'testSpeak@gmail.com';
    //         spk.Phone__c = '34567893';
    //         insert spk;

    //     MyEvent__c evqry = [SELECT Id FROM MyEvent__c WHERE Name__c = 'Test ME1'];
    //     Speaker__c spqry = [SELECT Id FROM Speaker__c WHERE Name = 'Test Speak1'];

    //     Test.startTest();
    //     Event_Speaker__c es = new Event_Speaker__c();
    //     es.MyEvent__c = evqry.Id;
    //     es.Speaker__c = spqry.Id;
    //     insert es;
    //     Test.stopTest();

    //     List<Event_Speaker__c> lstEs= [SELECT Id FROM Event_Speaker__c];
    //     system.AssertEquals(2,lstEs.size());
    // }

}
