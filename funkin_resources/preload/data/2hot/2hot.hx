var startB = false;
function onEndSong(){
	if (!startB && PlayState.isStoryMode){
		startB = true;
		startCutscene();
		return Function_Stop;
	}
}

function getSteps(seconds:Float){
	return seconds / (Conductor.stepCrochet / 1000);
}

// The video starts hidden while the stage plays its first seconds, as in Funkin.
function startCutscene() {
	camHUD.visible = false;
	var video = game.startVideo("2hotCutscene");
	if (video == null) return;
	video.visible = false;

	var neneDance = new FlxTimer().start(60 / 86.5, function(_) {
		if (gf != null && gf.isAnimationFinished()) gf.dance();
	}, 0);
	if (gf != null) {
		gf.danced = true;
		gf.dance();
	}

	new FlxTimer().start(1, function(_) {
		game.triggerEvent("Focus Camera", "", "1539,833.5," + getSteps(2) + ",quadInOut");
		game.triggerEvent("Zoom Camera", getSteps(2) + ",0.69", "quadInOut");
	});
	new FlxTimer().start(2, function(_) {
		boyfriend.playAnim("pissed", true);
		boyfriend.specialAnim = true;
	});
	new FlxTimer().start(2.5, function(_) {
		dad.playAnim("pissed", true);
		dad.specialAnim = true;
	});
	new FlxTimer().start(6, function(_) {
		neneDance.cancel();
		video.visible = true;
	});
}
