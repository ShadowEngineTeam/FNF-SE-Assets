var lastBeat = -1;
function onUpdate(elapsed){
	for (i in [leftIcon, rightIcon]) {
		var baseScale = 45/i.frameHeight;
		var scale = FlxMath.lerp(baseScale, i.scale.y, Math.exp(-elapsed * 9));
		i.scale.set(scale, scale);
		i.updateHitbox();
		i.y = strumLine.y - 150;
	}
	if (lastBeat != game.curStep) {
		lastBeat = game.curStep;
		if (lastBeat % 4 == 0) {
			for (i in [leftIcon, rightIcon]) {
				var baseScale = 45/i.frameHeight;
				i.scale.x = i.scale.y = baseScale * 1.2;
				i.updateHitbox();
			}
		}
	}
}