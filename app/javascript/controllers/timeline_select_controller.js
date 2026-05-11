import { Controller } from "@hotwired/stimulus"

// タイムライン単元選択: select変更で対応するURLへ遷移
export default class extends Controller {
  navigate(event) {
    const url = event.target.value
    if (url) {
      window.location.href = url
    }
  }
}
