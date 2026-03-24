import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["children", "icon"]

  toggle() {
    if (!this.hasChildrenTarget) return

    this.childrenTarget.classList.toggle("hidden")
    this.iconTarget.textContent =
      this.childrenTarget.classList.contains("hidden") ? "▶" : "▼"
  }
}