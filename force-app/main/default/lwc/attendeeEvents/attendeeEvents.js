import { api, LightningElement, track } from 'lwc';
import eventAtt from '@salesforce/apex/attEvntConroller.eventAtt';
import eventAttUpcoming from '@salesforce/apex/attEvntConroller.eventAttUpcoming';

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

export default class AttendeeEvents extends LightningElement {
    @api recordId;

    @track upcomingEvents;
    @track pastEvents;
    @track selectedEvents;

    columnList = COLUMNS;
    errors;
    retrievedRecordId = false;

    renderedCallback(){
        console.log('rendered call back!!!');
        console.log('recordId ::::', this.recordId);
        if (!this.retrievedRecordId && this.recordId) {
            console.log('recordId22222 ::::', this.recordId);
            this.retrievedRecordId = true;

            this.upcomingFromApex();
            this.pastFromApex();
        }
    }

    upcomingFromApex(){
        console.log('upcomingFromApex');
        
        eventAttUpcoming({
            attendId : this.recordId
        })
        .then ((result) => {
            console.log('upcomingFromApex THEN ');

            this.upcomingEvents = [];
            this.selectedEvents = [];

            result.forEach((record) => {
                let obj = new Object();

                obj.id = record.eventId;
                obj.Name = record.myEvent.Name__c;
                obj.detailspage = "https://" + window.location.host+ "/" + record.myEvent.Id;
                obj.EVNTORG = record.myEvent.Event_Organizer__r.Name;
                obj.StartDateTime = record.myEvent.Start_Date_Time__c;
                obj.Location = (record.myEvent.MyLocation__c ? record.myEvent.MyLocation__r.Name :"This is virtual");

                // if (record.myEvent.MyLocation__c) {
                //     obj.Location = record.myEvent.MyLocation__r.Name;
                // } else {
                //     obj.Location = "This is virtual";
                // }
                
                this.upcomingEvents.push(obj);
                if(record.isMember) this.selectedEvents.push(obj.id);
            });
            this.errors = undefined;
        })
        .catch((err) =>{
            this.errors = JSON.stringify(err);
            this.upcomingEvents = undefined;
        });
    }

    pastFromApex(){
        console.log('pastFromApex');
        
        eventAtt({
            attendId : this.recordId
        })
        .then ((result) => {
            console.log('pastFromApex THEN ');
            this.pastEvents = [];
            result.forEach((record) => {
                let pastEvent = {
                    Name : record.MyEvent__r.Name__c,
                    detailspage : "https://" + window.location.host+ "/" + record.MyEvent__c,
                    EVNTORG : record.MyEvent__r.Event_Organizer__r.Name,
                    StartDateTime : record.MyEvent__r.Start_Date_Time__c,
                    Location : (record.MyEvent__r.MyLocation__c ? MyEvent__r.MyLocation__r.Name :"This is virtual")
                }
                this.pastEvents.push(pastEvent);
            });
            this.errors = undefined;
        })
        .catch((err) =>{
            this.errors = JSON.stringify(err);
            this.pastEvents = undefined;
        });

    }



    // recordId
    // selectedrows
    // auraenabled on variablle





}