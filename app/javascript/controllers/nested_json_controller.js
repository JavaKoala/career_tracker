import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()

    let content = this.templateTarget.innerHTML

    const uniqueId = crypto.randomUUID()
    content = content.replace(/new-item/g, uniqueId)

    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()

    const wrapper = event.target.closest(".nested-fields")
    if (wrapper) {
      wrapper.remove()
    }
  }
}
