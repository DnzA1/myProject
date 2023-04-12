import {api, LightningElement } from 'lwc';

export default class ChildDisplayEvent extends LightningElement {
    @api columns;
    @api result;
    @api error;
}