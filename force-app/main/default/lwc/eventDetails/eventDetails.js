import { api, LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import id from '@salesforce/user/Id';
import profile from '@salesforce/schema/User.Profile.Name';
import { NavigationMixin } from 'lightning/navigation'; 
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import getEventSpeakers from '@salesforce/apex/eventDetailsConroller.getEventSpeakers';
import getLctDetails from '@salesforce/apex/eventDetailsConroller.getLctDetails';
import getAttDetails from '@salesforce/apex/eventDetailsConroller.getAttDetails';

const COLUMNS = [
    {
        label : "Name",
        fieldName : "Name",
        cellAttributes : {
            iconName : "standard:user",
            iconPosition : "left"
        }
    },

    {
        label : "Email",
        fieldName : "Email",
        type : "email"
    },

    {
        label : "Company Name",
        fieldName : "CompanyName",
    },

    {
        label : "Location",
        fieldName : "Location",
        cellAttributes : {
            iconName : "utility:Location",
            iconPosition : "left"
        }
    }
];


export default class EventDetails extends NavigationMixin(LightningElement) {
@api recordId;  

@track errors = false;
@track isAdmin = false;

@track speakerList;
@track eventRec;
@track attendeeList;

columnlist = COLUMNS;
userId = id;

@wire(getRecord, {recordId: '$userId', fields: [profile]})
wireMethod({data,error}){
    if(data){
        let userProfileName = data.fields.Profile.displayValue;
        this.isAdmin = userProfileName === 'System Administrator';
    }
    if (error) {
        console.log('Error Occured', JSON.stringify(error));
    }
}

createSpeaker(){
    const defaultValues = encodeDefaultFieldValues({ 
        MyEvent__c: this.recordId 
        }); 
     this[NavigationMixin.Navigate]({ 
        type: 'standard__objectPage', 
        attributes: { 
        objectApiName: 'Event_Speaker__c', 
        actionName: 'new' 
        }, 
        state: { 
        defaultFieldValues: defaultValues 
        } 
        }); 
}

//Step-2-Speakers
handleSpeakerActive(){
    getEventSpeakers({eventId: this.recordId})
    .then ((result) => {
        result.forEach((speaker) => {
            speaker.Name = speaker.Speaker__r.Name;
            speaker.Email = "********@gmail.com";
            speaker.Phone = speaker.Speaker__r.Phone__c;
            speaker.Picture__c = speaker.Speaker__r.Picture__c;
            speaker.About_Me__c = speaker.Speaker__r.About_Me__c;
            speaker.CompanyName = speaker.Speaker__r.Company__c; 
        });
        this.speakerList = result;
        this.errors = undefined;
    })
    .catch((err) =>{
        this.errors = err;
        this.speakerList = undefined;
    });

}

handleLocationActive(){
    getLctDetails({ eventId: this.recordId }).then ((result) => {
        console.log('RESULT ', result);
        if(result.MyLocation__c){
            this.eventRec = result;
        }
    })
    .catch((err) =>{
        this.errors = err;
    });
}

handleAttendeeActive(){
    getAttDetails({eventId: this.recordId})
    .then ((result) => {
        result.forEach((attendee) => {
            attendee.Name = attendee.Attendee__r.Name;
            attendee.Email = "********@gmail.com";
            attendee.CompanyName = attendee.Attendee__r.Company_Name__c; 

            if(attendee.Attendee__r.MyLocation__c){
                attendee.Location = attendee.Attendee__r.MyLocation__r.Name;
            } else {
               attendee.Location =  'Not preferred';
            }
        });
        this.attendeeList = result;
        this.errors = undefined;
    })
    .catch((err) =>{
        this.errors = err;
        this.speakerList = undefined;
    });
}

createAttendee(){
    const defaultValues = encodeDefaultFieldValues({ 
        MyEvent__c: this.recordId 
        }); 
     this[NavigationMixin.Navigate]({ 
        type: 'standard__objectPage', 
        attributes: { 
        objectApiName: 'Event_Attendee__c', 
        actionName: 'new' 
        }, 
        state: { 
        defaultFieldValues: defaultValues 
        } 
        }); 
}


}