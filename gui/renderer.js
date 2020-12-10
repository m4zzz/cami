// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// No Node.js APIs are available in this process because
// `nodeIntegration` is turned off. Use `preload.js` to
// selectively enable features needed in the rendering
// process.

window.onload = function () {
    const editor = document.getElementById("editor");

    function receivedMessage(msg) {
	console.log(msg.data);
        editor.innerHTML = msg.data;
    }

    const ws = new WebSocket("ws://localhost:12345/chat");
    ws.addEventListener('message', receivedMessage);

    document.addEventListener("keydown", (e) => {
        // console.log(e.key)
        ws.send(e.key);
    })
};
