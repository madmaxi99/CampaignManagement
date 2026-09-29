(function () {
    document.querySelectorAll('.character-card-delete').forEach((button) => {
        button.addEventListener('click', (event) => {
            event.preventDefault();
            const id = button.dataset.id;
            if (!confirm('Diesen Charakter wirklich unwiderruflich löschen?')) {
                return;
            }
            fetch(`/character/${id}`, { method: 'DELETE' }).then(() => window.location.reload());
        });
    });
})();
