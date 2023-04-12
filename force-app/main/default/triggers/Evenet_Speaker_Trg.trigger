trigger Evenet_Speaker_Trg on Event_Speaker__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            Event_Speaker_Trg_Handler.check_Duplication(Trigger.new);
            // Event_Speaker_Trg_Handler.check_Duplication2(Trigger.new);
            // Event_Speaker_Trg_Handler.check_Duplication3(Trigger.new);
        }
    }
}