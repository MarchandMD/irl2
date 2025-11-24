import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  previewPhoto(event) {
    const file = event.target.files[0]
    const preview = document.getElementById('profile-photo-preview')

    if (file && file.type.startsWith('image/')) {
      const reader = new FileReader()

      reader.onload = (e) => {
        preview.src = e.target.result
        preview.className = "w-24 h-24 rounded-full object-cover border-4 border-emerald-500 shadow-lg"
      }

      reader.readAsDataURL(file)
    }
  }
}
