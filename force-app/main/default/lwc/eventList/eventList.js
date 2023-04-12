import { LightningElement, track } from 'lwc';
import cllKeyword from '@salesforce/apex/eventListConroller.cllKeyword';
import cllKeyword2 from '@salesforce/apex/eventListConroller.cllKeyword2';

const COLUMNS = [
    {
        label : "View",
        fieldName : "detailspage",
        type : "url",
        wrapText : "true",
        typeAttributes : {
            label :{
                fieldName : 'Name__c'
            }
        },
        target : "_blank"
    },
    
    {
        label : "Name",
        fieldName : "Name__c",
        wrapText : "true",
        cellAttributes : {
            iconName : "standard:event",
            iconPosition : "left"
        }
    },

    {
        label : "Event Organizer",
        fieldName : "organizer",
        wrapText : "true",
        cellAttributes : {
            iconName : "standard:user",
            iconPosition : "left"
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

export default class EventList extends LightningElement {
    @track recordsToDisplay;
    @track dataResult;
    columnList = COLUMNS;

    errors;

    connectedCallback(){
        this.upcomingStart();
    }

    upcomingStart(){
        cllKeyword2()
        .then ((result) => {
            result.forEach((record) => {
                record.detailspage = "https://" + window.location.host+ "/" + record.Id;
                record.organizer = record.Event_Organizer__r.Name;
                record.Location = record.MyLocation__c ? record.MyLocation__r.Name :"This is virtual";

            });
            this.dataResult = result;
            this.recordsToDisplay = result;
            this.errors = undefined;
        })
        .catch((err) =>{
            this.errors = JSON.stringify(err);
            this.dataResult = undefined;
        });
    }

    handleSearch(event){
        let keyword = event.detail.value;
        cllKeyword({
            name : keyword
        }).then ((result) => {
            result.forEach((record) => {
                record.detailspage = "https://" + window.location.host+ "/" + record.Id;
                record.organizer = record.Event_Organizer__r.Name;
                record.Location = record.MyLocation__c ? record.MyLocation__r.Name :"This is virtual";

            });
            this.dataResult = result;
            this.recordsToDisplay = result;
            this.errors = undefined;
        })
        .catch((err) =>{
            this.errors = JSON.stringify(err);
            this.dataResult = undefined;
        });
    }
    handleStartDate(event){
        let valueDateTime = event.target.value;
        let filteredEvents = this.dataResult.filter((record, index, arrayobject) => {
            return record.Start_Date_Time__c >= valueDateTime;
        });
        this.recordsToDisplay = filteredEvents;
    }

    handleLocationSearch(event){
        let keyword = event.detail.value;
        let filteredEvents = this.dataResult.filter((record, index, arrayobject) => {
            return record.Location.toLowerCase().includes(keyword.toLowerCase());
        });
            this.recordsToDisplay = filteredEvents;
    }
}    