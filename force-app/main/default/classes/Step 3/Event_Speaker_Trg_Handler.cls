public with sharing class Event_Speaker_Trg_Handler {
    public static void check_Duplication(List<Event_Speaker__c> Triggernew) {

        Map<String,Event_Speaker__c> sumOldMpId = new Map<String,Event_Speaker__c>();

        List<Event_Speaker__c> CurrentlyIds = [SELECT Id, MyEvent__c, Speaker__c FROM Event_Speaker__c];

        for (Event_Speaker__c evs2 : CurrentlyIds) {
            String sumIds = string.valueOf(evs2.MyEvent__c) + string.valueOf(evs2.Speaker__c);
            sumOldMpId.put(sumIds, evs2);
        }   
        
        for (Event_Speaker__c evs3 : Triggernew) {
            String sumIds = string.valueOf(evs3.MyEvent__c) + string.valueOf(evs3.Speaker__c);
            if (sumOldMpId.containsKey(sumIds)) {
                evs3.addError('Bunu yapamassın bu id ile xx '+ sumOldMpId.get(sumIds).Id);
            }
        }
    }
//----------------------------------------------------------------------------------------
 
    public static void check_Duplication2(List<Event_Speaker__c> Triggernew) {
        Map<String,Event_Speaker__c> sumOldMpId = new Map<String,Event_Speaker__c>();
        Set<Id> eventIds = new Set<Id>();
        Set<Id> speakerIds = new Set<Id>();
        
        for (Event_Speaker__c evs2 : Triggernew) {
            String sumIds = string.valueOf(evs2.MyEvent__c) + string.valueOf(evs2.Speaker__c);
            sumOldMpId.put(sumIds, evs2);
            eventIds.add(evs2.MyEvent__c);
            speakerIds.add(evs2.Speaker__c);
        }
        
        List<Event_Speaker__c> CurrentlyIds = [SELECT Id, MyEvent__c, Speaker__c 
                                                FROM Event_Speaker__c 
                                                WHERE 
                                                MyEvent__c IN: eventIds 
                                                AND 
                                                Speaker__c IN: speakerIds];
        
        for (Event_Speaker__c evs3 : CurrentlyIds) {
            String sumIds = string.valueOf(evs3.MyEvent__c) + string.valueOf(evs3.Speaker__c);
            Event_Speaker__c eventSpeakerRecord = sumOldMpId.get(sumIds);
            if (eventSpeakerRecord == null) continue;
            eventSpeakerRecord.MyEvent__c.addError('Bunu yapamassın bu id ile ' + String.valueOf(evs3.Id));
        }
    }
    // //----------------------------------------------------------------------------------------
    public static void check_Duplication3(List<Event_Speaker__c> Triggernew) {

        Map<String,Event_Speaker__c> sumOldMpId = new Map<String,Event_Speaker__c>();
        Set<Id> eventIds = new Set<Id>();
        Set<Id> speakerIds = new Set<Id>();

        for (Event_Speaker__c evs1 : Triggernew) {
            eventIds.add(evs1.MyEvent__c);
            speakerIds.add(evs1.Speaker__c);
        }

        List<Event_Speaker__c> CurrentlyIds = [SELECT Id, MyEvent__c, Speaker__c 
                                                FROM Event_Speaker__c 
                                                WHERE 
                                                MyEvent__c IN: eventIds 
                                                AND 
                                                Speaker__c IN: speakerIds];

        for (Event_Speaker__c evs2 : CurrentlyIds) {
            String sumIds = string.valueOf(evs2.MyEvent__c) + string.valueOf(evs2.Speaker__c);
            sumOldMpId.put(sumIds, evs2);
        }   
        
        for (Event_Speaker__c evs3 : Triggernew) {
            String sumIds = string.valueOf(evs3.MyEvent__c) + string.valueOf(evs3.Speaker__c);
            if (sumOldMpId.containsKey(sumIds)) {
                evs3.addError('Bunu yapamassın bu id ile xxyy '+ sumOldMpId.get(sumIds).Id);
            }
        }
    }
//-------------------------------------------------------------------------------------------------
    









    //-------------------------------
// public static void check_Duplication_2(List<Event_Speaker__c> Triggernew) {
//     Map<String,Event_Speaker__c> sumNewMpId = new Map<String,Event_Speaker__c>();
//     Map<String,Event_Speaker__c> sumOldMpId = new Map<String,Event_Speaker__c>();

//     for (Event_Speaker__c evs : Triggernew) {
//         sumNewMpId.put(string.valueOf(evs.MyEvent__c) + string.valueOf(evs.Speaker__c), evs);
// }

//     List<Event_Speaker__c> CurrentlyIds = [SELECT Id, MyEvent__c, Speaker__c FROM Event_Speaker__c];

//     for (Event_Speaker__c evs2 : CurrentlyIds) {
//         sumOldMpId.put(string.valueOf(evs2.MyEvent__c) + string.valueOf(evs2.Speaker__c), evs2);
// } 

//     for (String str : sumNewMpId.keySet()) {
//         if (sumOldMpId.containsKey(str)) {
//             Event_Speaker__c newEs = sumNewMpId.get(str);
//             newEs.MyEvent__c.addError('Warning!!! You cant create duplicate record');
//         }
//     }
// }

}
