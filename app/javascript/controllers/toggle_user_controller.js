import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    projectId: Number
  }

  // チップをクリックしたときに呼ばれる
  toggle(event) {
    const button = event.currentTarget
    const userId = button.dataset.toggleUserUserIdValue
    const url    = `/manager/projects/${this.projectIdValue}/toggle_request`

    fetch(url, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept":       "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ user_id: userId })
    })
    .then(res => res.json())
    .then(data => {
      // レスポンスの assigned/requested は ID の配列
      this._refreshLists(data.assigned, data.requested)
    })
  }

  // assignedIds, requestedIds: update された ID 配列
  _refreshLists(assignedIds, requestedIds) {
    // このコントローラが紐づく要素 (.assignment-drawer)
    const drawer = this.element

    // パネル内のリスト要素を取得
    const successList  = drawer.querySelector(".panel--success .assignment-list")
    const requestList  = drawer.querySelector(".panel--info   .assignment-list")

    // 再構築前に、いま表示中のチップから「ID→名前」のマップを作成
    const nameMap = {}
    drawer.querySelectorAll("[data-toggle-user-user-id-value]").forEach(chip => {
      const id   = chip.dataset.toggleUserUserIdValue
      nameMap[id] = chip.innerText.trim()
    })

    // リストをクリア
    successList.innerHTML = ""
    requestList.innerHTML = ""

    // 新しい確定済みチップ
    assignedIds.forEach(id => {
      successList.appendChild(this._buildChip(id, nameMap[id], "chip--primary"))
    })

    // 新しい希望チップ
    requestedIds.forEach(id => {
      requestList.appendChild(this._buildChip(id, nameMap[id], ""))
    })
  }

  // チップ要素を作るヘルパー
  _buildChip(id, name, extraClass) {
    const btn = document.createElement("button")
    btn.type  = "button"
    btn.className = ["chip", extraClass].filter(Boolean).join(" ")
    btn.dataset.action                   = "click->toggle-user#toggle"
    btn.dataset.toggleUserUserIdValue    = id
    btn.textContent                      = name || "?"
    return btn
  }
}
