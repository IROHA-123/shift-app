import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.classList.add("show")
    setTimeout(() => {
      this.element.classList.remove("show")
    }, 2000)
  }
}
