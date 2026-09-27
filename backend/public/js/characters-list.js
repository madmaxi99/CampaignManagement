(function () {
    document.querySelectorAll('.character-card-delete').forEach((button) => {
        button.addEventListener('click', (event) => {
            event.preventDefault();
            const slug = button.dataset.slug;
            if (!confirm('Diesen Charakter wirklich unwiderruflich löschen?')) {
                return;
            }
            fetch(`/character/${slug}`, { method: 'DELETE' }).then(() => window.location.reload());
        });
    });
})();
