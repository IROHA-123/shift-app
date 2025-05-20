// app/javascript/controllers/confirm_assign_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay"]

  open(event) {
    event.preventDefault()
    console.log("open() called, overlayTarget=", this.overlayTarget)
    this.overlayTarget.classList.remove("hidden")
  }

  cancel(event) {
    console.log("cancel() called, overlayTarget=", this.overlayTarget)
    this.overlayTarget.classList.add("hidden")
  }

  confirm(event) {
    console.log("confirm() called, overlayTarget=", this.overlayTarget)
    this.overlayTarget.classList.add("hidden")
    const form = this.element.querySelector("form")
    if (form) form.requestSubmit()
  }
}
