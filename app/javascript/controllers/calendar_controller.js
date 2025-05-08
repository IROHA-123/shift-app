
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  openModal(event) {
    const modal = document.getElementById("projectModal")
    const projectId = event.currentTarget.dataset.projectId
    // 必要ならAjaxで詳細取得してモーダルにセット
    modal.classList.remove("hidden")
  }

  closeModal() {
    const modal = document.getElementById("projectModal")
    modal.classList.add("hidden")
  }
}

document.addEventListener("DOMContentLoaded", () => {
  document.querySelector(".close-btn").addEventListener("click", () => {
    document.getElementById("shift-modal").classList.add("hidden");
  });
});
