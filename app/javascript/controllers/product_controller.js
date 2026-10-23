import { Controller } from '@hotwired/stimulus';

// Thumbnail switching + quantity stepper on the product page
export default class extends Controller {
  static targets = ['thumb', 'main', 'quantity']

  show({ params: { index } }) {
    this.thumbTargets.forEach((thumb, i) => {
      const active = i === index;
      thumb.setAttribute('aria-pressed', active);
      thumb.classList.toggle('border-ink', active);
      thumb.classList.toggle('border-transparent', !active);
      thumb.classList.toggle('opacity-70', !active);
    });
    // Swap the big image: copy the thumb's background (or later, its <img> src)
    const chosen = this.thumbTargets[index];
    this.mainTarget.className = this.mainTarget.className.replace(/\b(shuka|bg-\[[^\]]+\])\b/g, '');
    chosen.classList.forEach((c) => { if (c === 'shuka' || c.startsWith('bg-[')) this.mainTarget.classList.add(c); });
  }

  increment() { this.#step(1); }

  decrement() { this.#step(-1); }

  #step(by) {
    const input = this.quantityTarget;
    const next = Math.min(Number(input.max), Math.max(Number(input.min), Number(input.value) + by));
    input.value = next;
  }
}