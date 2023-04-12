import { api, LightningElement, track } from 'lwc';

export default class Searcher extends LightningElement {

    @track keyword;
    
    @api cmpLabel = 'Search Event';
    @api isRequired = 'false';
    // @api showLabel = 'true';

    handleChange(event){
        let keyword = event.target.value;
        if (keyword && keyword.length >= 2) {
            let searchEvent = new CustomEvent ('search', {
                detail : {value : keyword}
            });
            this.dispatchEvent(searchEvent);
        }
        //-----------------------------------
        // this.keyword = event.target.value;
        // if (this.keyword && this.keyword.length >= 2) {
        //     let searchEvent = new CustomEvent ('search', {
        //         detail : {value : this.keyword}
        //     });
        //     this.dispatchEvent(searchEvent);
        // }
    }
    renderedCallback(){
        if (this.isRequired === 'true') {
            let picklistInfo = this.template.querySelector('lightning-input');
            picklistInfo.required = 'true';
            this.isRequired = 'false';
        }
    }
    // Bu componentin amcı parent olan custom lookupa serach yapılan harfleri göndermek.
}