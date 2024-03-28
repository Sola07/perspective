import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="chart"
export default class extends Controller {
  connect() {
    console.log("Hello");
    const recetteLoc = Number(this.element.getAttribute("data-recette-loc"));
    new Chartkick.PieChart("chart", [["Recettes locatives", recetteLoc]]);
  }
}
