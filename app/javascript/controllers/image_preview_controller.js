import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "placeholder", "filename", "dropzone"]

  select() {
    this.showPreview(this.inputTarget.files[0])
  }

  dragover(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.add("border-[#2563eb]", "bg-[#eef2ff]")
  }

  dragleave(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.remove("border-[#2563eb]", "bg-[#eef2ff]")
  }

  drop(e) {
    e.preventDefault()
    this.dropzoneTarget.classList.remove("border-[#2563eb]", "bg-[#eef2ff]")

    const file = e.dataTransfer.files[0]
    if (!file || !file.type.startsWith("image/")) return

    const dt = new DataTransfer()
    dt.items.add(file)
    this.inputTarget.files = dt.files

    this.showPreview(file)
  }

  showPreview(file) {
    if (!file) return

    const reader = new FileReader()
    reader.onload = (e) => {
      this.previewTarget.src = e.target.result
      this.previewTarget.classList.remove("hidden")
      if (this.hasPlaceholderTarget) {
        this.placeholderTarget.classList.add("hidden")
      }
    }
    reader.readAsDataURL(file)

    this.filenameTarget.textContent = file.name
    this.filenameTarget.classList.remove("hidden")
  }
}
