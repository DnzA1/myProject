@isTest
public with sharing class InvSmartyCallTEST {
    @isTest
    public static void testNegative() {
        MyLocation__c mylc = new MyLocation__c();
            mylc.City__c = 'Test City';
            mylc.Street__c = 'Test Street';
            mylc.State__c = 'Test State';
            mylc.Postal_Code__c = '123';
            mylc.Name = 'Test Name';
            mylc.Country__c = 'USA';

    Test.startTest();
    insert mylc;
    Test.stopTest();

    Integer errLog = [SELECT COUNT() FROM Error_Log__c WHERE Process_Name__c = 'CallOutFromSmarty'];
    system.AssertEquals(1, errLog);
    
    }
//Positive Class
    @isTest
    public static void testPositive() {
        MyLocation__c mylc = new MyLocation__c();
            mylc.City__c = 'Test City';
            mylc.Street__c = 'Test Street';
            mylc.State__c = 'Test State';
            mylc.Postal_Code__c = '123';
            mylc.Name = 'Test Name';
            mylc.Country__c = 'USA';

    Test.setMock(HttpCalloutMock.class, new MockSmarty());

    Test.startTest();
    insert mylc;
    Test.stopTest();

    mylc = [SELECT Id, Verified__c FROM MyLocation__c WHERE Id =:mylc.Id];
    system.AssertEquals(true, mylc.Verified__c);

    }
//Mock Class
    public class MockSmarty implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }
}
