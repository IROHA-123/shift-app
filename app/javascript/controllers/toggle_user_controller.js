// app/javascript/controllers/toggle_user_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    projectId: Number,
    requiredNumber: Number
  }
  static targets = ["remainingCount", "inputContainer"]

  connect() {
    // 初期選択ユーザーID一覧を hidden input から取得
    this.selectedIds = Array.from(
      this.inputContainerTarget.querySelectorAll("input")
    ).map(i => i.value)

    // リスト要素キャッシュ
    this.successList = this.element.querySelector(".panel--success .assignment-list")
    this.requestList = this.element.querySelector(".panel--info    .assignment-list")
  }

  toggle(event) {
    const btn    = event.currentTarget
    const userId = btn.dataset.toggleUserUserIdValue

    if (this.selectedIds.includes(userId)) {
      // 外す
      this.selectedIds = this.selectedIds.filter(id => id !== userId)
      btn.classList.remove("selected")
      this.requestList.appendChild(btn)
    } else {
      // 追加
      this.selectedIds.push(userId)
      btn.classList.add("selected")
      this.successList.appendChild(btn)
    }

    // hidden input を再構築
    this._refreshHiddenInputs()

    // 残り人数更新
    if (this.hasRemainingCountTarget && this.hasRequiredNumberValue) {
      const remaining = this.requiredNumberValue - this.selectedIds.length
      this.remainingCountTarget.textContent = remaining
    }
  }

  _refreshHiddenInputs() {
    // まずクリア
    this.inputContainerTarget.innerHTML = ""

    // 選択中IDごとに hidden input を作成
    this.selectedIds.forEach(id => {
      const input = document.createElement("input")
      input.type  = "hidden"
      input.name  = `assignments[${this.projectIdValue}][]`
      input.value = id
      this.inputContainerTarget.appendChild(input)
    })
  }
}
