import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

const application = Application.start()

// すべてのコントローラー（controllers/ ディレクトリ以下）を自動読み込み
eagerLoadControllersFrom("controllers", application)


