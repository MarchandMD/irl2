import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["preview", "container"]

  preview(event) {
    const files = event.target.files
    if (files.length === 0) {
      this.previewTarget.classList.add('hidden')
      return
    }

    this.previewTarget.classList.remove('hidden')
    this.containerTarget.innerHTML = ''

    Array.from(files).forEach(file => {
      const wrapper = document.createElement('div')
      wrapper.className = 'relative'

      if (file.type.startsWith('image/')) {
        const reader = new FileReader()
        reader.onload = (e) => {
          const img = document.createElement('img')
          img.src = e.target.result
          img.className = 'w-full h-40 object-cover rounded-lg border border-gray-200 dark:border-gray-700'
          wrapper.appendChild(img)

          const label = document.createElement('div')
          label.className = 'absolute bottom-2 left-2 px-2 py-1 bg-black bg-opacity-70 text-white text-xs rounded'
          label.textContent = '📸 Image'
          wrapper.appendChild(label)
        }
        reader.readAsDataURL(file)
      } else if (file.type.startsWith('video/')) {
        const video = document.createElement('video')
        video.src = URL.createObjectURL(file)
        video.className = 'w-full h-40 object-cover rounded-lg border border-gray-200 dark:border-gray-700'
        video.controls = false
        wrapper.appendChild(video)

        const label = document.createElement('div')
        label.className = 'absolute bottom-2 left-2 px-2 py-1 bg-black bg-opacity-70 text-white text-xs rounded'
        label.textContent = '🎥 Video'
        wrapper.appendChild(label)
      }

      this.containerTarget.appendChild(wrapper)
    })
  }
}
