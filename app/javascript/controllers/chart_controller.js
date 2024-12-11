import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas"];
  static values = {
    labels: Array,
    data: Array
  }

  connect() {
    new Chart(this.canvasTarget, {
      type: 'bar',
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: "Reviews Gathered",
          data: this.dataValue,
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          y: {
            beginAtZero: true
          }
        }
      }
    });
  }
}
