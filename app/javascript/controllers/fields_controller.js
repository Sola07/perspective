import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="fields"
export default class extends Controller {
  static targets = [
    "numberField1",
    "numberField2",
    "numberField3",
    "numberField4",
    "numberField5",
    "numberField6",
    "numberField7",
    "numberField8",
    "numberField9",
    "numberField10",
    "numberField11",
    "numberField12",
    "numberField13",
    "numberField14",
  ];

  connect() {
    console.log("Hello from fields_controller.js");
  }

  validatefield1() {
    if (
      this.numberField1Target.value.length >= 5 &&
      this.numberField1Target.value.length <= 7
    ) {
      this.numberField1Target.classList.add("is-valid");
    } else {
      this.numberField1Target.classList.remove("is-valid");
    }
  }

  validatefield2() {
    if (
      this.numberField2Target.value.length >= 1 &&
      this.numberField2Target.value.length <= 7
    ) {
      this.numberField2Target.classList.add("is-valid");
    } else {
      this.numberField2Target.classList.remove("is-valid");
    }
  }

  validatefield3() {
    if (
      this.numberField3Target.value.length >= 1 &&
      this.numberField3Target.value.length <= 7
    ) {
      this.numberField3Target.classList.add("is-valid");
    } else {
      this.numberField3Target.classList.remove("is-valid");
    }
  }

  validatefield4() {
    if (
      this.numberField4Target.value.length >= 1 &&
      this.numberField4Target.value.length <= 5
    ) {
      this.numberField4Target.classList.add("is-valid");
    } else {
      this.numberField4Target.classList.remove("is-valid");
    }
  }

  validatefield5() {
    if (
      this.numberField5Target.value.length >= 1 &&
      this.numberField5Target.value.length <= 4
    ) {
      this.numberField5Target.classList.add("is-valid");
    } else {
      this.numberField5Target.classList.remove("is-valid");
    }
  }

  validatefield6() {
    if (
      this.numberField6Target.value.length >= 1 &&
      this.numberField6Target.value.length <= 7
    ) {
      this.numberField6Target.classList.add("is-valid");
    } else {
      this.numberField6Target.classList.remove("is-valid");
    }
  }

  validatefield7() {
    if (
      this.numberField7Target.value.length >= 1 &&
      this.numberField7Target.value.length <= 2
    ) {
      this.numberField7Target.classList.add("is-valid");
    } else {
      this.numberField7Target.classList.remove("is-valid");
    }
  }

  validatefield8() {
    if (
      this.numberField8Target.value.length >= 1 &&
      this.numberField8Target.value.length <= 4
    ) {
      this.numberField8Target.classList.add("is-valid");
    } else {
      this.numberField8Target.classList.remove("is-valid");
    }
  }

  validatefield9() {
    if (
      this.numberField9Target.value.length >= 1 &&
      this.numberField9Target.value.length <= 4
    ) {
      this.numberField9Target.classList.add("is-valid");
    } else {
      this.numberField9Target.classList.remove("is-valid");
    }
  }

  validatefield10() {
    if (
      this.numberField10Target.value.length >= 3 &&
      this.numberField10Target.value.length <= 4
    ) {
      this.numberField10Target.classList.add("is-valid");
    } else {
      this.numberField10Target.classList.remove("is-valid");
    }
  }
  validatefield11() {
    if (
      this.numberField11Target.value.length >= 2 &&
      this.numberField11Target.value.length <= 4
    ) {
      this.numberField11Target.classList.add("is-valid");
    } else {
      this.numberField11Target.classList.remove("is-valid");
    }
  }

  validatefield12() {
    if (
      this.numberField12Target.value.length >= 2 &&
      this.numberField12Target.value.length <= 4
    ) {
      this.numberField12Target.classList.add("is-valid");
    } else {
      this.numberField12Target.classList.remove("is-valid");
    }
  }

  validatefield13() {
    if (
      this.numberField13Target.value.length >= 2 &&
      this.numberField13Target.value.length <= 4
    ) {
      this.numberField13Target.classList.add("is-valid");
    } else {
      this.numberField13Target.classList.remove("is-valid");
    }
  }

  validatefield14() {
    if (
      this.numberField14Target.value.length >= 5 &&
      this.numberField14Target.value.length <= 7
    ) {
      this.numberField14Target.classList.add("is-valid");
    } else {
      this.numberField14Target.classList.remove("is-valid");
    }
  }
}
