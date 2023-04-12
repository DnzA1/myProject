import { api, LightningElement } from 'lwc';
import findEvents from '@salesforce/apex/editMembershipController.findEvents';
import menageMember from '@salesforce/apex/editMembershipController.menageMember';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

import { NavigationMixin } from 'lightning/navigation'; 

const COLUMNS = [
    {
        label : "Event Name",
        fieldName : "detailspage",
        type : "url",
        wrapText : "true",
        typeAttributes : {
            label :{
                fieldName : 'Name'
            }
        }
    },
    
    {
        label : "Name",
        fieldName : "EVNTORG",
        cellAttributes : {
            iconName : "standard:user",
            iconPosition : "left"
        }
    },

    {
        label : "Event Date",
        fieldName : "StartDateTime",
        type : "date",
        typeAttributes : {
            weekday: "long",
            year: "numeric",
            month: "long"
        }
    },

    {
        label : "Location",
        fieldName : "Location",
        wrapText : "true",
        cellAttributes : {
            iconName : "utility:location",
            iconPosition : "left"
        }
    }
];

export default class EditMembership extends NavigationMixin(LightningElement) {

    @api recordId;
    @api selection;

    events;
    errors;
    columnList = COLUMNS;

    retrievedRecordId = false;

    renderedCallback(){
        console.log('rendered call back!!!');
        console.log('recordId ::::', this.recordId);
        if (!this.retrievedRecordId && this.recordId) {
            console.log('recordId22222 ::::', this.recordId);
            this.retrievedRecordId = true;

            this.upcomingFromApex();
        }
    }

    upcomingFromApex(){
        console.log('upcomingFromApex');
        
        findEvents({
            attendId : this.recordId,
            selection : this.selection
        })
        .then ((result) => {
            console.log('upcomingFromApex THEN');

            this.events = [];

            result.forEach((record) => {
                let obj = new Object();

                obj.id = record.eventId;
                obj.Name = record.myEvent.Name__c;
                obj.detailspage = "https://" + window.location.host+ "/" + record.myEvent.Id;
                obj.EVNTORG = record.myEvent.Event_Organizer__r.Name;
                obj.StartDateTime = record.myEvent.Start_Date_Time__c;
                obj.Location = (record.myEvent.MyLocation__c ? record.myEvent.MyLocation__r.Name :"This is virtual");
                
                this.events.push(obj);
            });
            this.errors = undefined;
        })
        .catch((err) =>{
            this.errors = err.message;
            this.events = undefined;
        });
    }

    clickHandler(event){

        let selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();

        let ids = [];

        selectedRecords.forEach((line) => {
            ids.push(line.id);
        });

        menageMember({
            attendId : this.recordId,
            eventIds : ids,
            selection : this.selection
        })
        .then((result) => {
            if (result) {

                this[NavigationMixin.Navigate]({ 
                    type: 'standard__recordPage', 
                    attributes: {
                        recordId: this.recordId,
                        actionName: 'view',
                    },
                    }); 

                this.dispatchEvent(new CloseActionScreenEvent());
                this.showNotification('Successful Operation', 'That Worked Great', 'success');
            } else {
                this.showNotification('Error', 'Opppsss', 'error');
            }
        })
        .catch((error) => {
            this.errors = error.message;
            this.showNotification('Error', error.message, 'error');
        })

    }

    showNotification(title, message, variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
            });
        this.dispatchEvent(evt);
    }

}