public with sharing class Batch_Del_Old_Events implements Database.Batchable<sObject>, Schedulable{

        public void execute(SchedulableContext sc) {
        Database.executeBatch(new Batch_Del_Old_Events(),200);
    }


        public Database.QueryLocator start(Database.BatchableContext bc){ 
            return Database.getQueryLocator([SELECT Id FROM MyEvent__c WHERE End_Date_Time__c <: Datetime.now().AddMonths(-2) AND Live__c = false]); 
            // return Database.getQueryLocator([SELECT Id FROM MyEvent__c WHERE End_Date_Time__c <LAST_N_MONTHS:2 AND Live__c = false]); 
        }     
        public void execute(Database.BatchableContext bc, List<MyEvent__c> scope){
            try {
                delete scope;
            } catch (Exception ex) {
                createErrorLog.logCrtMthd(ex.getMessage(), 'Delete Old Event Record', Datetime.now());
            }
        }
        public void finish(Database.BatchableContext info){
            Set<Id> stId = new Set<Id>();
            List<String> lstEmail = new List<String>();

            List<GroupMember> lstGrpMmbr = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Daily_Job'];

            for (GroupMember UsrId : lstGrpMmbr) {
                stId.add(usrId.UserOrGroupId);
            }
            
            List<User> lstUser = [SELECT Email FROM User WHERE Id IN: stId AND IsActive = true];
            
            for (User usrEml : lstUser) {
                lstEmail.add(usrEml.Email);
            }

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Daily Information About Deleting Old Events');
            email.setHtmlBody('Hello, <br/><br/>Deleting Completed<br/>');
            email.SetToaddresses(lstEmail);

            try {
                Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
            } catch (Exception ex) {
                createErrorLog.logCrtMthd(ex.getMessage(), 'Message Sending', Datetime.now());
            }
        }
}
// ADIMLARRR
//Batch apex oluştur
//Email gönderme  (hardcoding)
//Public group oluşturma
//Public Groupdan userlara email gönderme
    //- GroupMeemberden SOQL yap
    //- Burdan gelen UserIdlerini set de topla
    //- Sonra bu ıd leri kullanarak User objesinden Emailleri SOQL yap.
    //- Bu SOQL den gelen değerleri lstEmail'e gönder.
// Schedule ayarla.
// try catch ekle
// TEST YAP



//Deployment Settings
//Schedule den sonra batch elle çalışıyor mu? YESS



//ORIGINAL

// public with sharing class Batch_Del_Old_Events implements Database.Batchable<sObject>, Schedulable {

//     public void execute(SchedulableContext sc) {
//         Database.executeBatch(new Batch_Del_Old_Events(),1);
//     }

//     public Database.QueryLocator start(Database.BatchableContext bc){ 
//         return Database.getQueryLocator([SELECT Id FROM MyEvent__c WHERE End_Date_Time__c <: Datetime.now().AddMonths(-2) AND Live__c = false]); 
//     }     
//     public void execute(Database.BatchableContext bc, List<MyEvent__c> scope){
//         delete scope;
//     }
//     public void finish(Database.BatchableContext info){
//         List<GroupMember> lstGrpMmbr = new  List<GroupMember>();
//         Set<Id> stId = new Set<Id>();
//         Set<String> stEmail = new Set<String>();

//         lstGrpMmbr = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Daily_Job'];

//         for (GroupMember UsrId : lstGrpMmbr) {
//             stId.add(usrId.UserOrGroupId);
//         }

//         for (User usrEml : [SELECT Email FROM User WHERE Id IN: stId AND IsActive = true]) {
//             stEmail.add(usrEml.Email);
//         }

//         Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
//         email.setSubject('Daily Information About Deleting Old Events');
//         email.setHtmlBody('Hello, <br/><br/>Deleting Completed<br/>');
//         email.SetToaddresses(new List<String>(stEmail));
//         Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
//     } 
 
// }

//KALIPPPPPPPPPPPPPPPPPP

// public Database.QueryLocator start(Database.BatchableContext bc) {
//     return Database.getQueryLocator(/*[Select Id, Description from Account]*/);
// }

// public void execute (Database.BatchableContext bc, /*List<Account> scope*/){
//     /*
//     List<Account> lstAcc = new List<Account>();
//     if (scope != null && scope.size()>0) {
//         for (Account acc : scope) {
//             acc.Description = '';
//             lstAcc.add(acc);
//         }
//     }
//     if (lstAcc != null) {
//         update lstAcc;
//     }
//     */
// }
// public void finish(Database.BatchableContext bc) {

// }