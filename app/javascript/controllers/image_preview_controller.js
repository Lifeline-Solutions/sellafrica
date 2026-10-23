import { Controller } from '@hotwired/stimulus';

// Shows thumbnails of the photos picked in a file input, before upload.
export default class extends Controller {
  static targets = ['input', 'list']

  show() {
    this.#clear();
    Array.from(this.inputTarget.files).forEach((file) => {
      const url = URL.createObjectURL(file);
      this.urls.push(url);

      const figure = document.createElement('figure');
      figure.className = 'relative aspect-square overflow-hidden rounded-2xl border-2 border-sand-200';
      const img = document.createElement('img');
      img.alt = '';
      img.className = 'size-full object-cover';
      img.src = url;
      figure.appendChild(img);
      this.listTarget.appendChild(figure);
    });
  }

  disconnect() { this.#clear(); }

  #clear() {
    (this.urls || []).forEach((url) => URL.revokeObjectURL(url));
    this.urls = [];
    this.listTarget.innerHTML = '';
  }
}