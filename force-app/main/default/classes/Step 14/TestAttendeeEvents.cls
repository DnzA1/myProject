@isTest
public with sharing class TestAttendeeEvents {
    @isTest
    static void makeData(){
        Event_Organizer__c eoc = new Event_Organizer__c();
            eoc.Name = 'Test EO';
            eoc.Phone__c = '123456';
            eoc.Email__c = 'testeo@gmail.com';
            insert eoc;

        List<MyEvent__c> lstMyEvnt = new List<MyEvent__c>();
        
        for (Integer i = 1; i <= 200; i++) {
            MyEvent__c me = new MyEvent__c();
            me.Name__c = 'Test ME' + i;
            me.Event_Organizer__c = eoc.Id;
            me.Max_Seats__c = 100;
            me.Start_Date_Time__c = i<=100 ? Datetime.now().addMonths(-3) : Datetime.now().addDays(3);
            me.End_Date_Time__c = Datetime.now().addDays(30);
            me.Event_Type__c = 'Virtual';
            me.Live__c = true;
            me.Status__c = 'In Progress';
            lstMyEvnt.add(me);
        }
        insert lstMyEvnt;
        
        Attendee__c att = new Attendee__c();
        att.Name = 'Test';
        att.Email__c = 'test@gmail.com';
        att.Phone__c = '1231432342';
        insert att;
        
        List<Event_Attendee__c> lstEvntAtt = new List<Event_Attendee__c>();
        lstEvntAtt.add(new Event_Attendee__c(MyEvent__c = lstMyEvnt[5].Id, Attendee__c = att.Id));
        lstEvntAtt.add(new Event_Attendee__c(MyEvent__c = lstMyEvnt[15].Id, Attendee__c = att.Id));
        lstEvntAtt.add(new Event_Attendee__c(MyEvent__c = lstMyEvnt[115].Id, Attendee__c = att.Id));
        lstEvntAtt.add(new Event_Attendee__c(MyEvent__c = lstMyEvnt[155].Id, Attendee__c = att.Id));
        insert lstEvntAtt;

        Test.startTest();
        List<Event_Attendee__c> NewLstEvntAtt = attEvntConroller.eventAtt(att.Id);
        List<attEvntConroller.MemberWrapper> listMember = attEvntConroller.eventAttUpcoming(att.Id);
        Test.stopTest();
        System.AssertEquals(2, NewLstEvntAtt.size());
        System.AssertEquals(100, listMember.size());
        
        Integer memberCount =0;
        
        for (attEvntConroller.MemberWrapper mv : listMember) {
            if (mv.isMember) memberCount++;
        }
        System.AssertEquals(2, memberCount);

    }

}
