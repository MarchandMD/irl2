import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="task-filter"
export default class extends Controller {
  static targets = ["sortSelect", "statusSelect"]
  static values = {
    url: String
  }

  connect() {
    this.loadSavedState()
  }

  updateFilters() {
    const url = new URL(this.urlValue, window.location.origin)
    const params = new URLSearchParams(window.location.search)

    // Get sort and status values
    const sortValue = this.sortSelectTarget.value
    const statusValue = this.statusSelectTarget.value

    // Update URL parameters
    if (sortValue && sortValue !== 'newest') {
      params.set('sort', sortValue)
    } else {
      params.delete('sort')
    }

    if (statusValue && statusValue !== 'all') {
      params.set('status', statusValue)
    } else {
      params.delete('status')
    }

    // Preserve existing filters (like group and search query)
    url.search = params.toString()

    // Update the URL
    const newUrl = `${url.pathname}${url.search}`
    history.pushState({}, "", newUrl)

    // Save filter state to localStorage
    this.saveState()

    // Update the turbo frame
    const tasksFrame = document.getElementById('tasks_list')
    if (tasksFrame) {
      tasksFrame.src = newUrl
      tasksFrame.reload()
    }
  }

  saveState() {
    const state = {
      sort: this.sortSelectTarget.value,
      status: this.statusSelectTarget.value
    }
    localStorage.setItem('taskFilters', JSON.stringify(state))
  }

  loadSavedState() {
    const savedState = localStorage.getItem('taskFilters')
    if (savedState) {
      try {
        const state = JSON.parse(savedState)

        // Only apply saved state if not overridden by URL params
        const params = new URLSearchParams(window.location.search)

        if (!params.has('sort') && state.sort) {
          this.sortSelectTarget.value = state.sort
        }

        if (!params.has('status') && state.status) {
          this.statusSelectTarget.value = state.status
        }
      } catch (e) {
        console.error('Error loading saved filter state:', e)
      }
    }

    // Apply current URL params to selects
    const params = new URLSearchParams(window.location.search)
    if (params.has('sort')) {
      this.sortSelectTarget.value = params.get('sort')
    }
    if (params.has('status')) {
      this.statusSelectTarget.value = params.get('status')
    }
  }
}
