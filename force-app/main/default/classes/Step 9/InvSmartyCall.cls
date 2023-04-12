public with sharing class InvSmartyCall {
    @InvocableMethod(label='Get Account Names' description='Make an HTTP GET to Smarty.com' category='Location__c')
    public static void getLocationInfos(List<ID> ids) {
      makeCallOut(ids[0]);

    }

    @future(callout=true)
    public static void makeCallOut(Id futId){

      MyLocation__c myl = [SELECT Id, City__c, Street__c, State__c, Postal_Code__c FROM MyLocation__c WHERE Id =:futId];
      //----------
      try {

        SmartCallOut__c scl = SmartCallOut__c.getOrgDefaults();

        string endPoint = '/street-address'
                        +'?auth-id=' + scl.AutoId__c
                        +'&auth-token=' + scl.Auth_Token__c
                        +'&street='+ EncodingUtil.urlEncode(myl.Street__c, 'UTF-8')
                        +'&city='+ EncodingUtil.urlEncode(myl.City__c, 'UTF-8')
                        +'&state='+ EncodingUtil.urlEncode(myl.State__c, 'UTF-8')
                        +'&zipcode='+ myl.Postal_Code__c
                        +'&match=enhanced';

        system.debug('endPoint'+ endPoint);
        
        
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:smartyCallOut'+ endPoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.

        if (response.getStatusCode() == 200) {
          MyLocation__c myLoc = new MyLocation__c();
          myLoc.Id = myl.Id;
          myLoc.Verified__c = true;
          update myLoc;
        } else {
          MyLocation__c myLoc2 = new MyLocation__c();
          myLoc2.Id = myl.Id;
          myLoc2.Verified__c = false;
          update myLoc2;
        }
        // update new MyLocation__c(Id=futId, Verified__c = response.getStatusCode() == 200) // Kısa hali
   
      } catch (Exception e) {
        String catchErr = e.getMessage() + 'line = ' + e.getLineNumber();
        System.debug('Exception e =>>' + catchErr);
        createErrorLog.logCrtMthd(catchErr, 'CallOutFromSmarty',Datetime.now());
      }


      //----------

    }
}
