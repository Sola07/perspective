import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");

    const cashLmnpmb = Number(this.element.getAttribute("data-cash-lmnpmb"));
    const cashLmnprr = Number(this.element.getAttribute("data-cash-lmnprr"));
    const cashSciir = Number(this.element.getAttribute("data-cash-sciir"));
    const cashSciis = Number(this.element.getAttribute("data-cash-sciis"));
    new Chartkick.ColumnChart("chart3", [["LMNP MB", cashLmnpmb], ["LMNP RR", cashLmnprr], ["SCI IS", cashSciis], ["SCI IR", cashSciir]])

  }
}
