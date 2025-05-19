import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]
  show() {
    this.textTarget.classList.add("visible")
  }
  hide() {
    this.textTarget.classList.remove("visible")
  }
}