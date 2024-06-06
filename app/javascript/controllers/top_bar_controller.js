import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        console.log("Connected");
        //                     onclick: " document.querySelector('html').classList.toggle('dark'); ",
    }
    toggleDarkMode() {
        document.querySelector('html').classList.toggle('dark');
    }
    toggleDropdown() {
        document.querySelector('#user-options-dropdown-options').classList.toggle('hidden');
    }
}
