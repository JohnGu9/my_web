document.documentElement.classList.add("loading");

let cancelDownlinkListener = function () { };

setTimeout(function () {
    if ('connection' in navigator && 'downlink' in navigator.connection) {
        const loader = document.body.querySelector(".loader .connection-speed");
        if (loader) {
            loader.innerHTML = `(downlink ${navigator.connection.downlink.toFixed(1)} Mbit/s)`;
            loader.style.opacity = "1";
            loader.style.lineHeight = "1em";
            if ('onchange' in navigator.connection) {
                navigator.connection.onchange = function () {
                    loader.innerHTML = `(downlink ${navigator.connection.downlink.toFixed(1)} Mbit/s)`;
                }
                cancelDownlinkListener = function () {
                    navigator.connection.onchange = null;
                }
            } else {
                const timer = setInterval(function () {
                    loader.innerHTML = `(downlink ${navigator.connection.downlink.toFixed(1)} Mbit/s)`;
                }, 500);
                cancelDownlinkListener = function () {
                    clearInterval(timer);
                }
            }
        }
    }
}, 500);

const longTimeLoadTimer = setTimeout(function () {
    const errorHint = document.body.querySelector(".loader .error-hint");
    if (errorHint) {
        errorHint.innerHTML = `Seeming it is taking too many time to load this page. It may be caused by slow network connection (recommend over 10 Mbit/s). Recommend to check your network and reload the page. `;
        errorHint.style.opacity = "1";
        errorHint.style.lineHeight = "1em";
    }
}, 10000);

function onError() {
    const errorHint = document.body.querySelector(".loader .error-hint");
    if (errorHint) {
        errorHint.innerHTML = `Something go wrong when page is loading. Recommend to check your network and reload page if nothing change for long time. `;
        errorHint.style.opacity = "1";
        errorHint.style.lineHeight = "1em";
    }
    clearTimeout(longTimeLoadTimer);
}

window.addEventListener('error', onError);


window.addEventListener('load', function (ev) {
    // Download main.dart.js
    _flutter.loader.loadEntrypoint({
        serviceWorker: {
            serviceWorkerVersion: serviceWorkerVersion,
        },
        onEntrypointLoaded: function (engineInitializer) {
            engineInitializer.initializeEngine().then(function (appRunner) {
                appRunner.runApp();
                cancelDownlinkListener();
                document.body.querySelector(".loader").remove();
                document.documentElement.classList.remove("loading");
                window.removeEventListener('error', onError);
            });
        }
    });
});
