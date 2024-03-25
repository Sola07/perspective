import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="fields"
export default class extends Controller {
  static targets = ["numberField"];

  connect() {}

  validate() {
    if (
      this.numberFieldTarget.value.length >= 5 &&
      this.numberFieldTarget.value.length <= 7
    ) {
      this.numberFieldTarget.classList.add("is-valid");
    } else {
      this.numberFieldTarget.classList.remove("is-valid");
    }
  }
}
