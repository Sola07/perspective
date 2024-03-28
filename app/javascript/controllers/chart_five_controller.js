import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");

    const chargededucLmnpmb = Number(this.element.getAttribute("data-chargededuc-lmnpmb"));
    const chargededucLmnprr = Number(this.element.getAttribute("data-chargededuc-lmnprr"));
    const chargededucSciir = Number(this.element.getAttribute("data-chargededuc-sciir"));
    const chargededucSciis = Number(this.element.getAttribute("data-chargededuc-sciis"));
    new Chartkick.ColumnChart("chart5", [["LMNP MB", chargededucLmnpmb], ["LMNP RR", chargededucLmnprr], ["SCI IS", chargededucSciis], ["SCI IR", chargededucSciir]])

  }
}
