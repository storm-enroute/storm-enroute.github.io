



function createEvent() {
	var ev = document.createElement("img");
	var length = 100;
	var pathtop = 100;
	var left = 33;
	var height = 32;
	var imagename = "event0";
	var css = "position: absolute; " +
	"top: " + (pathtop + length) + "px; " +
	"left: " + left + "%;" +
	"height: " + height + "px;";
	ev.setAttribute("style", css);
	ev.setAttribute("src", "/resources/images/icons/" + imagename + ".png");
	document.body.appendChild(ev);

	function onComplete() {
		document.body.removeChild(ev);
	}

	createjs.Tween.get(ev)
	  .set({opacity: "0"})
      .to({top: pathtop + 0.5 * length, opacity: "1.0"}, 800, createjs.Ease.cubicIn)
      .to({top: pathtop + 0.0 * length, opacity: "0"}, 800, createjs.Ease.cubicOut)
      .call(onComplete);

	//setInterval(createEvent, 3000);
}


createjs.CSSPlugin.install(createjs.Tween);
createjs.Ticker.setFPS(30);

createEvent();

