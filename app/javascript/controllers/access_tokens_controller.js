import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["token"]

    async copyToClipboard() {
        const element = this.tokenTarget;
        const newToken = element.value
        await navigator.clipboard.writeText(newToken);
    }
}