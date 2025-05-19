import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select"]

  connect() {
    this.applyBackground()
  }

  applyBackground() {
    const select = this.selectTarget
    const value = select.value

    // 既存の level- クラスを削除
    select.classList.remove("level-0", "level-1", "level-2", "level-3")

    // 新しいクラスを追加
    select.classList.add(`level-${value}`)
  }
}
