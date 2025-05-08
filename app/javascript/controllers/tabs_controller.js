// app/javascript/controllers/tabs_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "nav"]
  static values = {
    url: String
  }

  load(event) {
    event.preventDefault()
    // クリックされたタブ要素
    const link = event.currentTarget

    // URLは data-tabs-url-value 属性から
    const url = link.dataset.tabsUrlValue

    // タブの見た目更新
    this.navTarget.querySelectorAll(".nav-item").forEach(el =>
      el.classList.toggle("active", el === link)
    )

    // コンテンツ部分をロード
    fetch(url, {
      headers: { "Accept": "text/html" }
    })
      .then(res => res.text())
      .then(html => {
        this.contentTarget.innerHTML = html
      })
      .catch(() => {
        console.error("タブ切り替えに失敗しました。")
      })
  }
}
