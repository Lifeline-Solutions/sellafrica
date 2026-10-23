import { Controller } from '@hotwired/stimulus';

// Show / hide the password field
export default class extends Controller {
  static targets = ['input', 'button']

  toggle() {
    const show = this.inputTarget.type === 'password';
    this.inputTarget.type = show ? 'text' : 'password';
    this.buttonTarget.setAttribute('aria-pressed', show);
    this.buttonTarget.setAttribute('aria-label', show ? 'Hide password' : 'Show password');
  }
}