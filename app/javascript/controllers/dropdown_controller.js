import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
    this.syncAria()
  }

  // メニュー外クリックで閉じる
  close(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
      this.syncAria()
    }
  }

  // ウィンドウリサイズで閉じる（モバイル↔PC切替時の状態不整合対策）
  handleResize() {
    if (this.menuTarget.classList.contains("hidden")) return
    this.menuTarget.classList.add("hidden")
    this.syncAria()
  }

  // 開閉状態をトグルボタンの aria-expanded に反映
  syncAria() {
    if (!this.toggleButton) return
    const isOpen = !this.menuTarget.classList.contains("hidden")
    this.toggleButton.setAttribute("aria-expanded", isOpen ? "true" : "false")
  }

  get toggleButton() {
    return this.element.querySelector('[data-action*="dropdown#toggle"]')
  }

  connect() {
    this.boundClose = this.close.bind(this)
    this.boundResize = this.handleResize.bind(this)
    document.addEventListener("click", this.boundClose)
    window.addEventListener("resize", this.boundResize)
    this.syncAria()
  }

  disconnect() {
    document.removeEventListener("click", this.boundClose)
    window.removeEventListener("resize", this.boundResize)
  }
}
