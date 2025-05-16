// app/javascript/controllers/logout_menu_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["panel"];

  connect() {
    // 初期状態は非表示
    this.panelTarget.classList.add("menu_hidden");
  }

  open(event) {
    event.preventDefault();
    // 非表示クラスを外して表示 → CSS の .menu_open でスライドイン
    this.panelTarget.classList.remove("menu_hidden");
    requestAnimationFrame(() => {
      this.panelTarget.classList.add("menu_open");
    });
  }

  close(event) {
    event.preventDefault();
    // スライドアウト用クラスを外す
    this.panelTarget.classList.remove("menu_open");
    // トランジション終了後にまた非表示に
    this.panelTarget.addEventListener(
      "transitionend",
      () => this.panelTarget.classList.add("menu_hidden"),
      { once: true }
    );
  }

}
