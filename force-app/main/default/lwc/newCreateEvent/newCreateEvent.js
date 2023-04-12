import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

import EVENT_OBJECT from '@salesforce/schema/MyEvent__c';
import Name__c from '@salesforce/schema/MyEvent__c.Name__c';
import Event_Organizer__c from '@salesforce/schema/MyEvent__c.Event_Organizer__c';
import Start_Date_Time__c from '@salesforce/schema/MyEvent__c.Start_Date_Time__c';
import End_Date_Time__c from '@salesforce/schema/MyEvent__c.End_Date_Time__c';
import Max_Seats__c from '@salesforce/schema/MyEvent__c.Max_Seats__c';
import MyLocation__c from '@salesforce/schema/MyEvent__c.MyLocation__c';
import Event_Detail__c from '@salesforce/schema/MyEvent__c.Event_Detail__c';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class NewCreateEvent extends NavigationMixin(LightningElement) {

    @track eventRecord = {
        Name__c : '',
        Event_Organizer__c : '',
        Start_Date_Time__c: null,
        End_Date_Time__c: null,
        Max_Seats__c: null,
        MyLocation__c: '',
        Event_Detail__c: ''
    }

    @track errors;

    handleChange(event){
        let value = event.target.value;
        let name = event.target.name;
        this.eventRecord[name] = value;
    }

    handleLookup(event){
        let selectedRecId = event.detail.selectedRecordId;
        let parentField = event.detail.parentField;
        this.eventRecord[parentField] = selectedRecId;
    }

    handleClick(){
        const fields = {};
        fields[Name__c.fieldApiName] = this.eventRecord.Name__c;
        fields[Event_Organizer__c.fieldApiName] = this.eventRecord.Event_Organizer__c;
        fields[Start_Date_Time__c.fieldApiName] = this.eventRecord.Start_Date_Time__c;
        fields[End_Date_Time__c.fieldApiName] = this.eventRecord.End_Date_Time__c;
        fields[Max_Seats__c.fieldApiName] = this.eventRecord.Max_Seats__c;
        fields[MyLocation__c.fieldApiName] = this.eventRecord.MyLocation__c;
        fields[Event_Detail__c.fieldApiName] = this.eventRecord.Event_Detail__c;

        const eventRecord = {
            apiName : EVENT_OBJECT.objectApiName,
            fields
        }

        createRecord(eventRecord)
        .then((eventRec) => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Record Saved',
                message: 'Event Draft is Ready',
                variant: 'success'
            }));
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    actionName: "view",
                    recordId: eventRec.id
                }
            });
        }).catch((err) =>{
            this.errors =JSON.stringify(err);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error Occured',
                message: this.errors,
                variant: 'error'
            }));
        });

    }
    handleCancel(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'MyEvent__c',
                actionName: 'home'
            }
        });
    }
}


