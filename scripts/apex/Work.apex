
//-----------------------------------------
    Contact con = new contact();
try {
    con.FirstName = '25.05';
    insert con;
    system.debug('Try bloğu çalıştı ');
} catch (Exception ex) {
    system.debug('Hata bu ' + ex);
} finally {
    con.LastName = 'Deneme';
    insert con;
    system.debug('FINALLY bloğu çalıştı ');
}
//-----------------------------------------


//-----------------------------------------
try {
    Event_Organizer__c eor = new Event_Organizer__c();
    eor.Name = 'Bernardo';
    eor.Phone__c = '123456';
    insert eor;
} catch (Exception ex) {
    system.debug('Error Message ::::' + ex.getMessage());
    createErrorLog.logCrtMthd(ex.getMessage(), 'Fatch Event Orgenizer');
}
//-----------------------------------------

//Error Log

//-----------------------------------------
try {
    Contact con = new contact();
    con.FirstName = 'test';
    con.LastName = null;
    insert con;
} catch (Exception ex) {
    // createErrorLog.logCrtMthd(ex.getMessage(), 'Create Contact Record');
    createErrorLog.logCrtMthd(ex.getMessage(), 'Create Contact Record', Datetime.now());
}
//-----------------------------------------





 List<GroupMember> lstGrpMmbr = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Daily_Job'];
 system.debug(lstGrpMmbr);



            List<GroupMember> lstGrpMmbr = new  List<GroupMember>();
            Set<Id> stId = new Set<Id>();
            Set<String> stEmail = new Set<String>();

            lstGrpMmbr = [SELECT UserOrGroupId FROM GroupMember WHERE Group.DeveloperName = 'Daily_Job'];

            for (GroupMember UsrId : lstGrpMmbr) {
                stId.add(usrId.UserOrGroupId);
            }

            for (User usrEml : [SELECT Email FROM User WHERE Id IN: stId AND IsActive = true]) {
                stEmail.add(usrEml.Email);
            }

            system.debug('::::::::IDDDDDD:::::::'+stId);
            system.debug('::::::::stEmail:::::::'+stEmail);

Database.executeBatch(new Batch_Del_Old_Events(),1);


Batch_Del_Old_Events k = new Batch_Del_Old_Events();
Database.executeBatch(k,1);


system.debug('URL: '+ URL.getOrgDomainUrl().toExternalForm());




//________________________________________

<template>
    <lightning-card title="Create Shipment Record" icon-name="standard:employee">
        <div class="slds-var-m-around_medium">
            <lightning-record-edit-form
                object-api-name={objectName}
                onsuccess={successHandler}>
                <!-- input fields -->
                <lightning-messages></lightning-messages>
                <div class="slds-grid slds-gutters">
                    <div class="slds-col">
                        <lightning-input-field field-name={fields.name}></lightning-input-field>
                        <lightning-input-field field-name={fields.dispatcher}></lightning-input-field>
                        <lightning-input-field field-name={fields.departure}></lightning-input-field>
                        <lightning-input-field field-name={fields.arrival}></lightning-input-field>
                    </div>
                    <div class="slds-col">
                        <lightning-input-field field-name={fields.detail}></lightning-input-field>
                    </div>
                </div>
                <div class="slds-align_absolute-center slds-var-m-around_large">
                    <lightning-button 
                    label="Cancel"
                    variant="neutral"
                    type="reset"
                    class="slds-var-m-right_x-small">
                    </lightning-button>
                    <lightning-button 
                    label="Save"
                    variant="brand"
                    type="submit"
                    onclick={goToRecord}>
                    </lightning-button>
                </div>
            </lightning-record-edit-form>
        </div>
    </lightning-card>
</template>




//________________________________________
import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
​
import SHIPMENT_OBJECT from '@salesforce/schema/Shipment__c';
import NAME_FIELD from '@salesforce/schema/Shipment__c.Name__c';
import DISPATCHER_FIELD from '@salesforce/schema/Shipment__c.Dispatcher_Manager__c';
import DEPARTURE_FIELD from '@salesforce/schema/Shipment__c.Departure_Date_Time__c';
import ARRIVAL_FIELD from '@salesforce/schema/Shipment__c.Arrival_Date_Time__c';
import DETAIL_FIELD from '@salesforce/schema/Shipment__c.Shipment_Detail__c';
import { NavigationMixin } from 'lightning/navigation';
import LAST_RECORD from '@salesforce/apex/LastCreatedRecordShipment.lastRecord';
​
export default class LightningRecordEditFormOpp extends NavigationMixin (LightningElement) {
​
    
    
    objectName = SHIPMENT_OBJECT;
    
    
    
    fields = {
        name: NAME_FIELD,
        dispatcher: DISPATCHER_FIELD,
        departure: DEPARTURE_FIELD,
        arrival: ARRIVAL_FIELD,
        detail: DETAIL_FIELD
    };
​
    successHandler(){
        const successToast = new ShowToastEvent({
            title:'Success',
            message: 'Opportunity has saved successfully!',
            variant: 'success'
        });
​
        this.dispatchEvent(successToast);
        
    }
​
    // onChangeHandler(event) {
    //     clearTimeout(this.timeoutId); // no-op if invalid id
    //     this.timeoutId = setTimeout(this.goToRecord.bind(this), 1000); // Adjust as necessary
    // }
​
    
​
        goToRecord(event){
            const recordInput = { apiName: LAST_RECORD }; //.objectApiName
            createRecord(recordInput)
                .then(eventRec => {
                    this[NavigationMixin.Navigate]({    
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: eventRec.Id,     //.recordInput.apiName
                            objectApiName: 'Shipment__c',
                            actionName: 'view'
                        }
                    });
                })
        }
   
}



EventDisplayClass.deneme();
system.debug(':::::::::::::'+EventDisplayClass.deneme());