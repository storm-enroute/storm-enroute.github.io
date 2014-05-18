


var images = [
	"event0",
	"event1",
	"event2",
	"event3",
	"event4",
	"event5",
	"event6",
	"event7",
	"event8",
	"event9",
	"event10",
	"event11",
	"event12",
	"event13",
	"event14",
	"event15",
	"event16"
];

function createEvent() {
	var ev = document.createElement("img");
	var distance = 0.5 + 0.5 * Math.random();
	var length = 160 * distance;
	var pathtop = 80;
	var left =  Math.floor(50 - distance * 25 + 2 * distance * 25 * Math.random());
	var height = Math.floor(36 * distance);
	var imagename = images[Math.floor(Math.random() * images.length)];
	var css = "position: absolute; " +
	"top: " + (pathtop + length) + "px; " +
	"left: " + left + "%;" +
	"height: " + height + "px;" +
	"opacity: 0.0;";
	ev.setAttribute("style", css);
	ev.setAttribute("src", "/resources/images/icons/" + imagename + ".png");
	document.body.appendChild(ev);

	function onComplete() {
		setInterval(Math.floor(3000 + 3000 * Math.random()), createEvent());
	}

	var time = 800 + 1200 * Math.random();

	createjs.Tween.get(ev)
      .to({top: pathtop + 0.5 * length, opacity: 0.8}, time, createjs.Ease.quadIn)
      .to({top: pathtop + 0.0 * length, opacity: 0.0}, time, createjs.Ease.quadOut)
      .call(onComplete);
}


createjs.CSSPlugin.install(createjs.Tween);
createjs.Ticker.setFPS(30);

createEvent();
createEvent();
createEvent();
