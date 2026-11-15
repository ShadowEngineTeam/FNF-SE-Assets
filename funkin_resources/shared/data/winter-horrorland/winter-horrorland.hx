import backend.HapticUtil;

var played = false;
function onStartCountdown() {
	if (played || PlayState.seenCutscene) return;
	played = true;
	game.inCutscene = true;
	camHUD.visible = false;

	var blackScreen = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
	blackScreen.scrollFactor.set();
	add(blackScreen);

	new FlxTimer().start(0.1, function(_) {
		remove(blackScreen);
		blackScreen.destroy();

		game.camFollow.setPosition(400, -2050);
		FlxG.camera.snapToTarget();
		FlxG.camera.zoom = 2.5;

		HapticUtil.vibrate(0.1, 0.5, 1, 1);
		FlxG.sound.play(Paths.sound("christmas/Lights_Turn_On"), 1, false, null, true, function() {
			camHUD.visible = true;
			camHUD.alpha = 0;
			FlxTween.tween(camHUD, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
			game.startCountdown();
		});
	});
	return Function_Stop;
}
