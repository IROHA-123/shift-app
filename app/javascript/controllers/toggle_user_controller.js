import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    projectId: Number,
    requiredNumber: Number
  }

  static targets = ["remainingCount"]

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

  _refreshLists(assignedIds, requestedIds) {
    const drawer = this.element
    const successList = drawer.querySelector(".panel--success .assignment-list")
    const requestList = drawer.querySelector(".panel--info    .assignment-list")

    // ID → 名前、skill levelのマップを作成
    const nameMap = {}
    const levelMap = {}
    drawer.querySelectorAll("[data-toggle-user-user-id-value]").forEach(chip => {
      const id = chip.dataset.toggleUserUserIdValue
      nameMap[id] = chip.innerText.trim()
      levelMap[id] = chip.dataset.skillLevel || 0
    })

    // リストをクリア
    successList.innerHTML = ""
    requestList.innerHTML = ""

    // チップを再構築（levelも渡す）
    assignedIds.forEach(id => {
      successList.appendChild(this._buildChip(id, nameMap[id], "chip--primary", levelMap[id]))
    })

    requestedIds.forEach(id => {
      requestList.appendChild(this._buildChip(id, nameMap[id], "", levelMap[id]))
    })

    // 残人数を再計算して表示を更新
    if (this.hasRemainingCountTarget && this.hasRequiredNumberValue) {
      const remaining = this.requiredNumberValue - assignedIds.length
      this.remainingCountTarget.textContent = remaining
    }
  }

  // skillLevel引数を追加
  _buildChip(id, name, extraClass, skillLevel = 0) {
    const btn = document.createElement("button")
    btn.type  = "button"
    btn.className = ["chip", extraClass, `level-${skillLevel}`].filter(Boolean).join(" ")
    btn.dataset.action = "click->toggle-user#toggle"
    btn.dataset.toggleUserUserIdValue = id
    btn.dataset.skillLevel = skillLevel
    btn.textContent = name || "?"
    return btn
  }
}
