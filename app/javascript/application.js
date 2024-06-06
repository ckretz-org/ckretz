// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

Turbo.setConfirmMethod((message, element) => {
    let dialog = document.querySelector('#turbo-confirm');
    dialog.querySelector("p").textContent = message;
    dialog.showModal();
    return new Promise((resolve) => {
        dialog.addEventListener('close', (event) => {
            resolve(dialog.returnValue === 'confirm');
        }, { once: true });
    });
})

