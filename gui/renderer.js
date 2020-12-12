// This file is required by the index.html file and will
// be executed in the renderer process for that window.
// No Node.js APIs are available in this process because
// `nodeIntegration` is turned off. Use `preload.js` to
// selectively enable features needed in the rendering
// process.

window.addEventListener('DOMContentLoaded', (event) => {
    console.log('DOM fully loaded and parsed');


window.onload = function () {
    const editor = document.getElementById("editor");
    const cursor = document.getElementById("cursor");

    function determineCallback(command, args) {
	if (command == "render") {
	    editor.innerHTML = args;
	    document.getElementById("cursor").scrollIntoView(false);
	}
	if (command == "reload") {
	    location.reload();
	}



    }

	function callCommand(msg) {
	    const order = JSON.parse(msg.data);
	    const command = order.command;
	    // console.log(order.command);
	    // console.log(order);
	    determineCallback(command, order.args);
	}

	const ws = new WebSocket("ws://localhost:12345/chat");
	ws.addEventListener('message', callCommand);
	document.addEventListener("keydown", (e) => {
	    e.preventDefault();
	    const event = {event: "keydown",
			   alt: e.altKey,
			   ctrl: e.ctrlKey,
			   meta: e.metaKey,
			   shift: e.shiftKey,
			   repeat: e.repeat,
			   key: e.key};
            ws.send(JSON.stringify(event));
	    console.log(JSON.stringify(event));
	})
};
});
