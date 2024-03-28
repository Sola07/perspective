import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");

    const tax = Number(this.element.getAttribute("data-taxe"));
    const chargloc = Number(this.element.getAttribute("data-chargloc"));
    const autrecharge = Number(this.element.getAttribute("data-autrecharge"));
    const interet = Number(this.element.getAttribute("data-interet"));


    new Chartkick.PieChart("chart4", [["Taxe foncière", tax], ["Charges locatives", chargloc], ["Autres charges", autrecharge], ["Interet d'emprunt", interet]])
  }
}
