import { Controller } from "@hotwired/stimulus"

// 関連人物のタグ入力UI
// - 検索でフィルタ、候補クリックで追加
// - 選択済みはpillで表示、×で削除
// - hidden input (event[character_ids][]) で選択状態をサーバに送信
export default class extends Controller {
  static targets = ["input", "suggestions", "selected", "hiddenFields", "name"]
  static values = {
    characters: Array,
    paramName: { type: String, default: "event[character_ids][]" }
  }

  connect() {
    this.selectedIds = Array.from(
      this.element.querySelectorAll("[data-initial-selected]")
    ).map((el) => Number(el.dataset.initialSelected))
    this.render()

    this.handleOutsideClick = this.handleOutsideClick.bind(this)
    this.handleKeydown = this.handleKeydown.bind(this)
    document.addEventListener("click", this.handleOutsideClick)
    document.addEventListener("keydown", this.handleKeydown)
  }

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick)
    document.removeEventListener("keydown", this.handleKeydown)
  }

  handleOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.hideSuggestions()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape" && !this.suggestionsTarget.classList.contains("hidden")) {
      this.hideSuggestions()
    }
  }

  // 検索中にEnterキーでフォーム送信されないように抑止する
  preventSubmit(event) {
    if (event.key === "Enter") {
      event.preventDefault()
    }
  }

  search(event) {
    const query = event.target.value.trim()
    if (!query) {
      this.hideSuggestions()
      return
    }
    const lowered = query.toLowerCase()
    const filtered = this.charactersValue.filter(
      (c) =>
        c.name.toLowerCase().includes(lowered) &&
        !this.selectedIds.includes(c.id)
    )
    this.renderSuggestions(filtered.slice(0, 10))
  }

  add(event) {
    const id = Number(event.currentTarget.dataset.id)
    if (this.selectedIds.includes(id)) return
    this.selectedIds = [...this.selectedIds, id]
    this.inputTarget.value = ""
    this.hideSuggestions()
    this.render()
  }

  remove(event) {
    const id = Number(event.currentTarget.dataset.id)
    this.selectedIds = this.selectedIds.filter((x) => x !== id)
    this.render()
  }

  hideSuggestions() {
    this.suggestionsTarget.classList.add("hidden")
    this.suggestionsTarget.replaceChildren()
  }

  render() {
    this.renderSelected()
    this.renderHiddenFields()
  }

  renderSelected() {
    this.selectedTarget.replaceChildren(
      ...this.selectedIds
        .map((id) => this.findCharacter(id))
        .filter(Boolean)
        .map((c) => this.buildPill(c))
    )
  }

  renderHiddenFields() {
    // 空文字を1つ含めることで、全解除されてもcharacter_idsキーが送信される
    const base = document.createElement("input")
    base.type = "hidden"
    base.name = this.paramNameValue
    base.value = ""

    const inputs = this.selectedIds.map((id) => {
      const el = document.createElement("input")
      el.type = "hidden"
      el.name = this.paramNameValue
      el.value = String(id)
      return el
    })

    this.hiddenFieldsTarget.replaceChildren(base, ...inputs)
  }

  renderSuggestions(items) {
    if (items.length === 0) {
      this.hideSuggestions()
      return
    }
    const buttons = items.map((c) => {
      const btn = document.createElement("button")
      btn.type = "button"
      btn.dataset.id = c.id
      btn.dataset.action = "click->character-picker#add"
      btn.className =
        "block w-full text-left px-3 py-2 text-sm text-[#191c1e] hover:bg-[#f2f4f6]"
      btn.textContent = c.name
      return btn
    })
    this.suggestionsTarget.replaceChildren(...buttons)
    this.suggestionsTarget.classList.remove("hidden")
  }

  buildPill(character) {
    const pill = document.createElement("span")
    pill.className =
      "bg-[#2170e4] inline-flex gap-1.5 items-center pl-3 pr-2 py-1.5 rounded-full text-white text-xs font-medium"

    const label = document.createElement("span")
    label.textContent = character.name
    pill.appendChild(label)

    const close = document.createElement("button")
    close.type = "button"
    close.dataset.id = character.id
    close.dataset.action = "click->character-picker#remove"
    close.className =
      "size-4 inline-flex items-center justify-center rounded-full hover:bg-white/20"
    close.setAttribute("aria-label", `${character.name}を外す`)
    close.textContent = "×"
    pill.appendChild(close)

    return pill
  }

  findCharacter(id) {
    return this.charactersValue.find((c) => c.id === id)
  }
}
