import {Controller} from "@hotwired/stimulus"
import {get} from '@rails/request.js'

export default class extends Controller {
    connect() {
        console.log("SecretFormController Connected!");
    }

    async getSecretValuePartial() {
        console.log("SecretFormController getSecretValuePartial");
        const response = await get("/secrets/secret_value_field");
        if (response.ok) {
            const html = await response.text;
            const section = document.querySelector("#secret_values");
            const element = document.createElement("template");
            element.innerHTML = html;
            section.appendChild(element.content.firstElementChild);
        }
    }
}
