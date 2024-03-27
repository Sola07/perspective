import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");
    new Chartkick.PieChart("chart", [
      ["Recettes locatives", Number(this.data.get("lmnp-recette-loc-value"))],
      [
        "Charges déductibles",
        Number(this.data.get("lmnp-charge-deduct-value")),
      ],
      ["Amortissement", Number(this.data.get("lmnp-amortissement-value"))],
      ["Autres charges", Number(this.data.get("lmnp-autres-charges-value"))],
    ]);
  }
}
