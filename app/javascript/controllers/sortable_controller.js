import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = {
    url: String,
    handle: { type: String, default: ".drag-handle" }
  }

  connect() {
    this.sortable = Sortable.create(this.element, {
      handle: this.handleValue,
      animation: 150,
      ghostClass: "sortable-ghost",
      chosenClass: "sortable-chosen",
      onEnd: this.onEnd.bind(this)
    })
  }

  disconnect() {
    if (this.sortable) {
      this.sortable.destroy()
      this.sortable = null
    }
  }

  onEnd() {
    const ids = Array.from(this.element.children)
      .map((el) => el.dataset.id)
      .filter(Boolean)

    const token = document.querySelector('meta[name="csrf-token"]')?.content

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "X-CSRF-Token": token
      },
      body: JSON.stringify({ ids })
    }).catch((err) => {
      console.error("並び替えの保存に失敗しました", err)
    })
  }
}
