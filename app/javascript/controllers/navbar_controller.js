import { Controller } from "@hotwired/stimulus"

// Handles the mobile drawer and the account dropdown.
// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = ["menu", "menuButton", "accountMenu", "accountButton"]

  connect() {
    // Close menus when Turbo navigates or restores a cached page
    this.reset = () => this.closeAll()
    document.addEventListener("turbo:before-cache", this.reset)
  }

  disconnect() {
    document.removeEventListener("turbo:before-cache", this.reset)
    document.body.classList.remove("overflow-hidden")
  }

  toggleMenu() {
    const open = this.menuTarget.classList.toggle("hidden") === false
    this.menuButtonTarget.setAttribute("aria-expanded", open)
    document.body.classList.toggle("overflow-hidden", open)
  }

  toggleAccount(event) {
    event.stopPropagation()
    const open = this.accountMenuTarget.classList.toggle("hidden") === false
    this.accountButtonTarget.setAttribute("aria-expanded", open)
  }

  clickOutside(event) {
    if (this.hasAccountMenuTarget &&
        !this.accountMenuTarget.contains(event.target) &&
        !this.accountButtonTarget.contains(event.target)) {
      this.closeAccount()
    }
  }

  closeAccount() {
    if (!this.hasAccountMenuTarget) return
    this.accountMenuTarget.classList.add("hidden")
    this.accountButtonTarget.setAttribute("aria-expanded", false)
  }

  closeAll() {
    this.closeAccount()
    if (this.hasMenuTarget) {
      this.menuTarget.classList.add("hidden")
      this.menuButtonTarget.setAttribute("aria-expanded", false)
    }
    document.body.classList.remove("overflow-hidden")
  }
}