public with sharing class createErrorLog {
    public static void logCrtMthd(String logDtls, string prcsName, Datetime dtTime) {
        Error_Log__c erl = new Error_Log__c();
        erl.Log_Details__c = logDtls;
        erl.Process_Name__c = prcsName;
        erl.Log_Date_Time__c = dtTime;
        insert erl;
    }
}


// public with sharing class createErrorLog {
//     public static void logCrtMthd(String logDtls, string prcsName) {
//         Error_Log__c erl = new Error_Log__c();
//         erl.Log_Details__c = logDtls;
//         erl.Process_Name__c = prcsName;
//         erl.Log_Date_Time__c = Datetime.now();
//         insert erl;
//     }
// }