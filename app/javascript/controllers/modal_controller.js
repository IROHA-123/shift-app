import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "body"]

  connect() {
    console.log("✅ ModalController connected!")
    console.log("hasModalTarget:", this.hasModalTarget)
    console.log("hasBodyTarget:",  this.hasBodyTarget)
    console.log(this.element)  // controller が紐づいた要素全体
  }
  
  open(event) {
    const ids = event.currentTarget.dataset.projectIds;
    fetch(`/scheduler/shift_requests/modal?project_ids=${ids}`)
      .then(res => res.text())
      .then(html => {
        this.bodyTarget.innerHTML = html;
        this.modalTarget.classList.remove("hidden");
        this.modalTarget.classList.add("open");
      });
  }
  close() {
    this.modalTarget.classList.remove("open")
    this.modalTarget.classList.add("hidden")
    this.bodyTarget.innerHTML = ""
  }  
  stop(event) {
    event.stopPropagation()
  }
}
