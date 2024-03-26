import { Controller } from "@hotwired/stimulus";
import { Chart } from "chart.js/auto";

// Connects to data-controller="chart"
export default class extends Controller {
  static targets = ["canvas"];

  connect() {
    console.log("Hello from chart_controller.js");
    this.drawChart();
  }

  drawChart() {
    const ctx = this.canvasTarget.getContext("2d");
    new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["Janvier", "Février", "Mars", "Avril"],
        datasets: [
          {
            label: "Visiteurs par mois",
            data: [50, 60, 70, 90],
            backgroundColor: ["rgba(255, 99, 132, 0.2)"],
            borderColor: ["rgba(255, 99, 132, 1)"],
            borderWidth: 1,
          },
        ],
      },
      options: {
        scales: {
          y: {
            beginAtZero: true,
          },
        },
      },
    });
  }
}
