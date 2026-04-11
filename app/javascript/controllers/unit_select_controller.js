import { Controller } from "@hotwired/stimulus"

// 学習ユニットのドロップダウン選択・タグ追加・削除
export default class extends Controller {
  static targets = ["dropdown", "selectedTags", "option"]

  connect() {
    this.updateDropdownOptions()
  }

  // ドロップダウンからユニットを追加
  add() {
    const select = this.dropdownTarget
    const selectedOption = select.options[select.selectedIndex]
    const unitId = selectedOption.value
    const unitName = selectedOption.dataset.unitName

    if (!unitId || this.getSelectedIds().includes(unitId)) {
      select.value = ""
      return
    }

    // タグを追加
    const tag = document.createElement("span")
    tag.className = "inline-flex items-center gap-1 bg-[#cbe7f5] text-[#4e6874] text-[14px] px-3 py-1.5 rounded-lg"
    tag.dataset.unitId = unitId
    tag.innerHTML = `
      ${unitName}
      <button type="button" class="text-[#4e6874] hover:text-[#2d3e46]"
        data-action="click->unit-select#remove" data-unit-id="${unitId}">
        <svg class="w-2 h-2" fill="currentColor" viewBox="0 0 8 8">
          <path d="M1 1l6 6M7 1L1 7" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/>
        </svg>
      </button>
      <input type="hidden" name="schedule[study_unit_ids][]" value="${unitId}">
    `
    this.selectedTagsTarget.appendChild(tag)

    // ドロップダウンをリセットして選択済みを非表示
    select.value = ""
    this.updateDropdownOptions()
  }

  // ユニットを削除
  remove(event) {
    const unitId = event.currentTarget.dataset.unitId
    const tag = this.selectedTagsTarget.querySelector(`[data-unit-id="${unitId}"]`)
    if (tag) tag.remove()
    this.updateDropdownOptions()
  }

  // 選択済みのユニットをドロップダウンから非表示にする
  updateDropdownOptions() {
    const selectedIds = this.getSelectedIds()
    this.optionTargets.forEach(option => {
      option.hidden = selectedIds.includes(option.value)
    })
  }

  // 選択済みのIDリストを取得
  getSelectedIds() {
    const hiddenInputs = this.selectedTagsTarget.querySelectorAll("input[type='hidden']")
    return Array.from(hiddenInputs).map(input => input.value)
  }
}
