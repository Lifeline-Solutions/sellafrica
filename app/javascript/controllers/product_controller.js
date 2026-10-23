import { Controller } from '@hotwired/stimulus';

// Thumbnail switching + quantity stepper on the product page
export default class extends Controller {
  static targets = ['thumb', 'main', 'mainImage', 'quantity']

  show({ params: { index, imageUrl } }) {
    this.thumbTargets.forEach((thumb, i) => {
      const active = i === index;
      thumb.setAttribute('aria-pressed', active);
      thumb.classList.toggle('border-ink', active);
      thumb.classList.toggle('border-transparent', !active);
      thumb.classList.toggle('opacity-70', !active);
    });

    if (this.hasMainImageTarget && imageUrl) {
      this.mainImageTarget.src = imageUrl;
    }
  }

  increment() { this.#step(1); }

  decrement() { this.#step(-1); }

  #step(by) {
    const input = this.quantityTarget;
    const next = Math.min(Number(input.max), Math.max(Number(input.min), Number(input.value) + by));
    input.value = next;
  }
}