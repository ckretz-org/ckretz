import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    toggleDarkMode() {
        document.querySelector('html').classList.toggle('dark');
    }
}
