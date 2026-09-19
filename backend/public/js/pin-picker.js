(function () {
    var picker = document.getElementById('pin-picker');
    if (!picker) {
        return;
    }

    var image = document.getElementById('pin-picker-image');
    var marker = document.getElementById('pin-picker-marker');
    var pinX = document.getElementById('pin-x');
    var pinY = document.getElementById('pin-y');

    image.addEventListener('click', function (event) {
        var rect = image.getBoundingClientRect();
        var x = ((event.clientX - rect.left) / rect.width) * 100;
        var y = ((event.clientY - rect.top) / rect.height) * 100;

        pinX.value = x.toFixed(2);
        pinY.value = y.toFixed(2);

        marker.style.left = x + '%';
        marker.style.top = y + '%';
        marker.hidden = false;
    });
})();
