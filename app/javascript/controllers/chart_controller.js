import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");

    const rentLmnpmb = Number(this.element.getAttribute("data-rent-lmnpmb"));
    const rentLmnprr = Number(this.element.getAttribute("data-rent-lmnprr"));
    const rentSciir = Number(this.element.getAttribute("data-rent-sciir"));
    const rentSciis = Number(this.element.getAttribute("data-rent-sciis"));

    new Chartkick.ColumnChart("chart", [["LMNP MB", rentLmnpmb], ["LMNP RR", rentLmnprr], ["SCI IS", rentSciis], ["SCI IR", rentSciir]])

  }
}
