@isTest
public with sharing class Batch_Del_Test {

    @TestSetup
    static void makeData(){
        List<MyEvent__c> lstRcrds = new List<MyEvent__c>();
        Event_Organizer__c eoc = new Event_Organizer__c();
            eoc.Name = 'Test EO';
            eoc.Phone__c = '123456';
            eoc.Email__c = 'testeo@gmail.com';
            insert eoc;


        for (Integer i = 0; i < 200; i++) {
            MyEvent__c me = new MyEvent__c();
            me.Name__c = 'Test ME';
            me.Event_Organizer__c = eoc.Id;
            me.Max_Seats__c = 100;
            me.Start_Date_Time__c = Datetime.now().addMonths(-6);
            me.End_Date_Time__c = Datetime.now().addMonths(-5);
            me.Live__c = false;
            lstRcrds.add(me);
        }
        insert lstRcrds;
    }

    @isTest
    public static void tstMethodBatch() {

        Test.startTest();
        Batch_Del_Old_Events bde = new Batch_Del_Old_Events();
        bde.execute(null);
        // Database.executeBatch(new Batch_Del_Old_Events(),200);
        Test.stopTest();

        List<MyEvent__c> lstMyE = [SELECT Id FROM MyEvent__c];
        system.AssertEquals(0,lstMyE.size());
    }
}
