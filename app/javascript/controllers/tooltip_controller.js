import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["text"]

  connect() {
    // オプションで初期設定なども書ける
  }

  show() {
    this.textTarget.classList.add("visible")
  }

  hide() {
    this.textTarget.classList.remove("visible")
  }
}