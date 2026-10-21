import { Controller } from "@hotwired/stimulus"

// Live password strength bar + "passwords match" check
export default class extends Controller {
  static targets = ["password", "confirmation", "bar", "hint", "match", "tick"]

  update() {
    this.#strength()
    this.#match()
  }

  #strength() {
    const value = this.passwordTarget.value
    const min = Number(this.hintTarget.dataset.min || 6)
    let score = 0
    if (value.length >= min) score++
    if (value.length >= min + 4) score++
    if (/[A-Z]/.test(value) && /[a-z]/.test(value)) score++
    if (/\d/.test(value) && /[^A-Za-z0-9]/.test(value)) score++
    if (value.length < min) score = value.length ? 1 : 0

    const colours = ["bg-brand", "bg-[#E0782B]", "bg-gold", "bg-[#1E7A46]"]
    const labels  = ["Too short", "Weak", "Good", "Strong"]
    this.barTargets.forEach((bar, i) => {
      bar.classList.remove("bg-sand-200", ...colours)
      bar.classList.add(i < score ? colours[score - 1] : "bg-sand-200")
    })

    if (!value) {
      this.hintTarget.textContent = `At least ${min} characters. Mixing letters, numbers and symbols makes it stronger.`
    } else if (value.length < min) {
      this.hintTarget.textContent = `${min - value.length} more character${min - value.length === 1 ? "" : "s"} needed`
    } else {
      this.hintTarget.textContent = labels[score - 1] + " password"
    }
  }

  #match() {
    const a = this.passwordTarget.value
    const b = this.confirmationTarget.value
    const matches = b.length > 0 && a === b
    this.tickTarget.classList.toggle("hidden", !matches)

    if (!b) {
      this.matchTarget.textContent = ""
    } else if (matches) {
      this.matchTarget.textContent = "Passwords match"
      this.matchTarget.className = "min-h-5 text-sm font-medium text-[#1E7A46]"
    } else {
      this.matchTarget.textContent = "Passwords don't match yet"
      this.matchTarget.className = "min-h-5 text-sm font-medium text-brand"
    }
  }
}