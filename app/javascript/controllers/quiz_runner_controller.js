import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "prevBtn", "nextBtn", "submitBtn", "counter", "progressBar"]
  static values = { total: Number }

  connect() {
    this.currentIndex = 0
    this.updateDisplay()
  }

  next() {
    if (this.currentIndex < this.totalValue - 1) {
      this.currentIndex++
      this.updateDisplay()
    }
  }

  prev() {
    if (this.currentIndex > 0) {
      this.currentIndex--
      this.updateDisplay()
    }
  }

  answer() {
    this.updateSubmitState()
  }

  updateDisplay() {
    this.questionTargets.forEach((el, i) => {
      el.classList.toggle("hidden", i !== this.currentIndex)
    })

    const current = this.currentIndex + 1
    const total = this.totalValue
    this.counterTarget.textContent = `第 ${current} / ${total} 問`
    this.progressBarTarget.style.width = `${(current / total) * 100}%`

    this.prevBtnTarget.disabled = this.currentIndex === 0

    const isLast = this.currentIndex === total - 1
    this.nextBtnTarget.classList.toggle("hidden", isLast)
    this.submitBtnTarget.classList.toggle("hidden", !isLast)

    this.updateSubmitState()
  }

  updateSubmitState() {
    const answered = this.element.querySelectorAll('input[type="radio"]:checked').length
    this.submitBtnTarget.disabled = answered !== this.totalValue
  }
}
