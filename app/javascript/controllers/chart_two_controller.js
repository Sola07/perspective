import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");

    const coutLmnpmb = Number(this.element.getAttribute("data-cout-lmnpmb"));
    const coutLmnprr = Number(this.element.getAttribute("data-cout-lmnprr"));
    const coutSciir = Number(this.element.getAttribute("data-cout-sciir"));
    const coutSciis = Number(this.element.getAttribute("data-cout-sciis"));
    new Chartkick.ColumnChart("toto", [["LMNP MB", coutLmnpmb], ["LMNP RR", coutLmnprr], ["SCI IS", coutSciis], ["SCI IR", coutSciir]])

  }
}
