import {api, LightningElement, track } from 'lwc';
import searchRecords from '@salesforce/apex/searchConroller.searchRecords';

export default class CustomLookup extends LightningElement {
    @api objectName = 'MyEvent__c';
    @api fieldName = 'Name';
    @api iconName = 'standard:record';
    @api label = 'Event';

    
    @api parentIdField = 'MyEvent__c';

    @track records;
    @track selectedRecord;

    handleSearch(event){
        var searchVal = event.detail.value;

        searchRecords({
            objName : this.objectName,
            fieldName : this.fieldName,
            searchKey : searchVal

        })
        .then(data => {
            if (data) {
                let parsedResponse = JSON.parse(data); // List<List<SObject>>
                let searchRecordLlist = parsedResponse[0]; // List<SObject>
                for (let index = 0; index < searchRecordLlist.length; index++) {
                    let record = searchRecordLlist[index]; // one record
                    record.Name =  record[this.fieldName]; // burada foreach de yapabilirdik.
                this.records = searchRecordLlist;
            }
        }})
        .catch(error => {
            window.console.log('ERR', JSON.stringify(error));
        });
    }

    handleSelect(event){
        var selectedVal = event.detail.selRec;
        this.selectedRecord = selectedVal;

        let finalRecEvent = new CustomEvent('select', {
            detail : {
                selectedRecordId : this.selectedRecord.Id,
                parentField : this.parentIdField
            }
        });
        this.dispatchEvent(finalRecEvent);
    }

    handleRemove(event){
        this.selectedRecord = undefined;
        this.records = undefined;

        // let finalRecEvent = new CustomEvent('select', {
        //     detail : {
        //         selectedRecordId : undefined,
        //         parentfield : this.parentIdField
        //     }
        // });
        // this.dispatchEvent(finalRecEvent);
    }
}