import { Controller } from "@hotwired/stimulus"

// 曜日ボタンのON/OFF切り替え
export default class extends Controller {
  static targets = ["checkbox", "display"]

  connect() {
    this.updateStyles()
  }

  toggle() {
    this.updateStyles()
  }

  updateStyles() {
    this.checkboxTargets.forEach((checkbox, index) => {
      const display = this.displayTargets[index]
      if (checkbox.checked) {
        display.classList.add("bg-[#000b60]", "text-white")
        display.classList.remove("bg-white", "text-[#767683]", "border", "border-[#e2e8f0]")
      } else {
        display.classList.remove("bg-[#000b60]", "text-white")
        display.classList.add("bg-white", "text-[#767683]", "border", "border-[#e2e8f0]")
      }
    })
  }
}
