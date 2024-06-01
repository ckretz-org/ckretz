// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:load", function() {
    const userDropdown = document.querySelector('#user-options-dropdown-button');
    userDropdown.addEventListener('click', function() {
        document.querySelector('#user-options-dropdown-options').classList.toggle('hidden');
    });
    function toggleDarkMode() {
        console.log("toggleDarkMode");
        const darkMode = document.querySelector('html').classList.toggle('dark');
        localStorage.setItem('darkMode', darkMode);
    }

});

