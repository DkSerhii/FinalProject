import {LightningElement, wire} from 'lwc';
import getKidsByTeacherId from '@salesforce/apex/ContactController.getKidsByTeacherId';
import createVisitByKidId from '@salesforce/apex/VisitController.createVisitByKidId';
import updateKidLeft from '@salesforce/apex/VisitController.updateKidLeft';
import {refreshApex} from "@salesforce/apex";

export default class ArrivingTable extends LightningElement {

    @wire(getKidsByTeacherId)
    kids;

    today = new Date();
    formattedMonth = this.today.getMonth() + 1;
    currentDate = this.today.getDate() + '/' + this.formattedMonth + '/' + this.today.getFullYear();

    markKidArrive(event) {
        let kidId = event.currentTarget.dataset.id;
        createVisitByKidId({kidId})
            .then(() => {
                this.refreshApex();
            })
            .catch(error => {
                console.log(error);
            });
    }

    markKidLeft(event) {
        let kidId = event.currentTarget.dataset.id;
        updateKidLeft({kidId})
            .then(() => {
                this.refreshApex();
            })
            .catch(error => {
                console.log(error);
            });
    }

    refreshApex() {
        refreshApex(this.kids);
    }
}