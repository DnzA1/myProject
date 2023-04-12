import { LightningElement } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import MYEVENT_OBJ from '@salesforce/schema/MyEvent__c';
import MYEVENT_NAME from '@salesforce/schema/MyEvent__c.Name__c';
import MYEVENT_ORGNZR from '@salesforce/schema/MyEvent__c.Event_Organizer__c';
import MYEVENT_STRDT from '@salesforce/schema/MyEvent__c.Start_Date_Time__c';
import MYEVENT_ENDDT from '@salesforce/schema/MyEvent__c.End_Date_Time__c';
import MYEVENT_MAXSEAT from '@salesforce/schema/MyEvent__c.Max_Seats__c';
import MYEVENT_EVNDTL from '@salesforce/schema/MyEvent__c.Event_Detail__c';


export default class CrateEvent extends NavigationMixin(LightningElement) {
objApiName = MYEVENT_OBJ;
evantName;
eventOrganizer;
startDate;
endDate;
maxSeats;
eventDetail;

    nameHandler(event){
        this.evantName = event.target.value;
    }
    
    organizerHandler(event){
        this.eventOrganizer = event.target.value;
    }
    
    startDateHandler(event){
        this.startDate = event.target.value;
    }
    
    endDateHandler(event){
        this.endDate = event.target.value;
    }

    seatsHandler(event){
        this.maxSeats = event.target.value;
    }

    detailHandler(event){
        this.eventDetail = event.target.value;
    }



    clickHandler(event){

        var myFields = {};

        myFields[MYEVENT_NAME.fieldApiName] = this.evantName;
        myFields[MYEVENT_ORGNZR.fieldApiName] = this.eventOrganizer;
        myFields[MYEVENT_STRDT.fieldApiName] = this.startDate;
        myFields[MYEVENT_ENDDT.fieldApiName] = this.endDate;
        myFields[MYEVENT_MAXSEAT.fieldApiName] = this.maxSeats;
        myFields[MYEVENT_EVNDTL.fieldApiName] = this.eventDetail;


        var recordInput = {
            apiName : MYEVENT_OBJ.objectApiName,
            fields : myFields
        }
        createRecord(recordInput).then(eventRecord => {

            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: eventRecord.id,
                    objectApiName: MYEVENT_OBJ.objectApiName,
                    actionName: 'view',
                }
                // Başka bir örnek
                // this[NavigationMixin.Navigate]({
                //     type: 'standard__objectPage',
                //     attributes: {
                //         objectApiName: CONTACT_OBJECT.objectApiName,
                //         actionName: 'home'
                //     }
                // });
            });

            const shwTost = new ShowToastEvent({
                title : 'Contact Record Status',
                message : 'You has been created new Record succesfully',
                variant : 'success'
            });
            this.dispatchEvent(shwTost);

        }).catch(error=>{
                //Toast Message
                const evt = new ShowToastEvent({
                    title: "Contact Record Status",
                    message: "Error",
                    variant: "error"
                })
                this.dispatchEvent(evt);
                console.log('----ERROR----' + error.body.message );
            });
    }

}