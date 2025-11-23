import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task-search"
export default class extends Controller {
  static targets = ["input", "results", "clearButton"]
  static values = {
    url: String,
    debounceDelay: { type: Number, default: 300 }
  }

  connect() {
    this.timeout = null
  }

  disconnect() {
    if (this.timeout) {
      clearTimeout(this.timeout)
    }
  }

  search() {
    clearTimeout(this.timeout)

    const query = this.inputTarget.value.trim()

    // Show/hide clear button based on input
    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.toggle("hidden", query.length === 0)
    }

    // Debounce the search
    this.timeout = setTimeout(() => {
      this.performSearch(query)
    }, this.debounceDelayValue)
  }

  clear() {
    this.inputTarget.value = ""
    this.inputTarget.focus()

    if (this.hasClearButtonTarget) {
      this.clearButtonTarget.classList.add("hidden")
    }

    this.performSearch("")
  }

  performSearch(query) {
    const url = new URL(this.urlValue, window.location.origin)
    const params = new URLSearchParams(window.location.search)

    if (query.length > 0) {
      params.set("q", query)
    } else {
      params.delete("q")
    }

    // Preserve existing filters (like group)
    url.search = params.toString()

    // Update the URL without a full page reload
    const newUrl = `${url.pathname}${url.search}`
    history.replaceState({}, "", newUrl)

    // Find the turbo frame and update it
    const tasksFrame = document.getElementById('tasks_list')
    if (tasksFrame) {
      tasksFrame.src = newUrl
      tasksFrame.reload()
    }
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      this.clear()
    }
  }
}
