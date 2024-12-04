import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["card"];
  currentIndex = 0;

  connect() {
    this.showCard(this.currentIndex);
  }

  showCard(index) {
    this.cardTargets.forEach((card, i) => {
      card.hidden = i !== index;
    });
  }

  showNext() {
    this.currentIndex = (this.currentIndex + 1) % this.cardTargets.length;
    this.showCard(this.currentIndex);
  }

  showPrevious() {
    this.currentIndex =
      (this.currentIndex - 1 + this.cardTargets.length) % this.cardTargets.length;
    this.showCard(this.currentIndex);
  }
}
