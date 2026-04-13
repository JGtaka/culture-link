import { Controller } from "@hotwired/stimulus"

// カードのページネーション
export default class extends Controller {
  static targets = ["page", "prevBtn", "nextBtn", "indicator"]

  connect() {
    this.currentIndex = 0
    this.updateView()
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--
      this.updateView()
    }
  }

  next() {
    if (this.currentIndex < this.pageTargets.length - 1) {
      this.currentIndex++
      this.updateView()
    }
  }

  updateView() {
    const total = this.pageTargets.length

    // ページの表示切替
    this.pageTargets.forEach((page, index) => {
      page.classList.toggle("hidden", index !== this.currentIndex)
    })

    // インジケーター更新
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.textContent = `${this.currentIndex + 1} / ${total}`
    }

    // ボタンの有効/無効
    if (this.hasPrevBtnTarget) {
      this.prevBtnTarget.disabled = this.currentIndex === 0
    }
    if (this.hasNextBtnTarget) {
      this.nextBtnTarget.disabled = this.currentIndex === total - 1
    }
  }
}
