import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["output"]

  preview() {
    const output = this.outputTarget
    output.innerHTML = ""

    Array.from(this.element.files).forEach(file => {
      if (file.type.startsWith("image/")) {
        const img = document.createElement("img")
        img.classList.add("h-20", "w-20", "object-cover", "rounded-lg", "mr-2", "mb-2")
        img.src = URL.createObjectURL(file)
        output.appendChild(img)
      } else if (file.type.startsWith("video/")) {
        const video = document.createElement("video")
        video.classList.add("h-20", "w-20", "object-cover", "rounded-lg", "mr-2", "mb-2")
        video.controls = true
        video.src = URL.createObjectURL(file)
        output.appendChild(video)
      }
    })
  }
}
