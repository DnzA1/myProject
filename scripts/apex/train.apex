
Set<String> str = new Set<String>{'a', 'b', 'c'};
str.add('d');
system.debug('Set<String> str::::::::::' + str);

for (String each : str) {
    system.debug(each);
}

List<String> lstStr = new List<String>();
lstStr.add('Bir');
lstStr.add('İki');
lstStr.add('Üç');
system.debug(':::::::::::lstStr:::::::::'+ lstStr);

List<List<String>> lstStr2 = new List<List<String>>{lstStr};
// lstStr2.add('New Bir');
// lstStr2.add('New İki');
// lstStr2.add('New Üç');
system.debug(':::::::::::lstStr2222:::::::::'+ lstStr2);

// List<String> lstStr2 = new List<String>(lstStr);
// lstStr2.add('New Bir');
// lstStr2.add('New İki');
// lstStr2.add('New Üç');
// system.debug(':::::::::::lstStr2222:::::::::'+ lstStr2);




public class ShipmentDriverHandler {
    public  static void  ShipmentDriverHandler(list<Shipment_Driver__c> trnew, list<Shipment_Driver__c> trold, map<id,Shipment_Driver__c> trnewmap, map<id,Shipment_Driver__c> troldmap) {
        set<id> shipmentids= new set<id>();
        set<id> driverid = new set<id>();
        map<string,shipment_driver__c> shipldrvr = new map< string, shipment_driver__c>();//mapa key olarak idleri koyduk
        for(Shipment_Driver__c shdr : trnew){
            string id1 = string.valueOf(shdr.shipment__c) + String.valueOf(shdr.driver__c);
            shipldrvr.put(id1, shdr);
            shipmentids.add(shdr.Shipment__c);
            driverid.add(shdr.driver__c);
            //triggerdean geleni aldik
        }
        List<Shipment_Driver__c> shlistem = [select id, shipment__c, driver__c from shipment_driver__c  where shipment__c in : shipmentids and driver__c in : driverid];
        for(shipment_driver__c shd : shlistem){
            string id2 = string.valueOf(shd.shipment__c) + String.valueOf(shd.driver__c);
            shipment_driver__c var1 = shipldrvr.get(id2);//hata nerde verilmesi lazim yeni olusturlan recorda
            if(var1!=null){
            var1.adderror('error is here');//shipldrv.containskey(var1)
            }
        }
    }

}


 List<List<SObject>> records = [FIND 'de*' IN ALL FIELDS RETURNING MyEvent__c(Name__c)];
 System.debug(':::::::records:::::::'+ records);
 List<MyEvent__c> myc = records[0];
 System.debug(':::::::myc:::::::'+ myc);
 System.debug(':::::::records[0][0]:::::::'+ records[0][0]);






public  class ScheduledApexbatch implements Database.Batchable<SObject>{
​
        //Tum Accountlarin isimlerinin sonuna batch 12 ekleyelim..
  
     //start: tum data buraya cagrilir ve return edilir execute metoduna
     public Database.QueryLocator start(Database.BatchableContext bc){
     
      return Database.getQueryLocator([select id, name, name__c, Live__c, Arrival_Date_Time__c from Shipment__c where Live__c= false and Arrival_Date_Time__c <= LAST_N_MONTHS:2]);//soql yapib islencek recordlari yapiyordu
     }
  
     //execute: belirlene sayilarla recordlarla parca parca istenen islem yapilir.
     public void execute(Database.BatchableContext bc, List<Shipment__c> scope){//islem burda oluyor
         
        ScheduledBatchApexhandler.deleteOldShpRecords(scope);//burdan yolladgm scopu silecek.
     }
  
     //finish: tum islem bittiginde 1 kere calisir.. mesaj veya mail atabilirsiniz..
     public void finish(Database.BatchableContext bc){
          System.debug('islem bitti');
          
    ScheduledBatchApexhandler.sendEmail();
     }
​
​
​
     ////
     //silersin sonra isletdik
​
​
     public Database.QueryLocator start(Database.BatchableContext bc){
​
return Database.getQueryLocator([select ddndkjndkfnkdfdfvkdfvfk from hjeknb where arrdartime<=LAST_N_MONTHS:2 and live__c = false]);
     }
​
​
     public void execute(Database.BatchableContext bc, list<shipment__c> sh){
      delete sh;
     }
public void finish(Database.BatchableContext bc){
​
​
system.debug('bitdigitsi');
​
//send email...
set<id> ids =  new set<id>();
​
List<GroupMember> lisgrm = [SELECT Id, GroupId, UserOrGroupId, SystemModstamp FROM GroupMember where group.name = 'Daily Job' ];
​
for(GroupMember gr : lisgrm){
​
   ids.add(gr.UserOrGroupId);//idleri aldikkk
​
}
​
​
​
​
User us = [SELECT Id, Email FROM User where id in : ids ];
​
set<string> setEmail = new set<string>();
​
for(User u : us){
​
​
   setEmail.add(us.email);
}//userlerin emaillerini grup sonra userin kendisini getr emailini al
​
​
​
Messaging.SingleEmailMessage emails = new Messaging.SingleEmailMessage();
​
emails.setSubject('Delete Emails');
emails.getPlainTextBody('Old shipments history deleted');
​
emails.setToAddresses(new list<String> (setEmail));//bunu liste haline getrib alici olarak belledik
​
Messaging.sendEmail(new list<Messaging.SingleEmailMessage> {emails});//olusturulan emailler burdan gonderiliyor...
​
//list<string> hbejhj = new liasbscjsd{hjjj}; 91- cisatirdaki gibi ekliyor sadee emailleri
//87 email variable olarak aliyor.
//88-de suslu paranyez listeye yeni eleman eklemis oldugu icin aliyor..
​
​
​
}
     }
  
  
Collapse










