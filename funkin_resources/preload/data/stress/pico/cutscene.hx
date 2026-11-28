var videoStart = false;
var canPlayVideo = !PlayState.seenCutscene && !PlayState.chartingMode;
function onStartCountdown() {
	
	if (!videoStart && canPlayVideo) {
		game.startVideo("stressPicoCutscene");
		videoStart = true;
		return Function_Stop;
	}
}
var endCutsceneStart = false;
function onEndSong(){
	if (!endCutsceneStart){
		startEndCutscene();
		endCutsceneStart = true;
		return Function_Stop;
	}
}
function getSecond(second:Float){
	return second / ((60/Conductor.bpm)/4);
}
function startEndCutscene() {
	camHUD.visible = false;
	game.camZooming = true;
	game.triggerEvent("Focus Camera", "dad", "320,-70," + getSecond(2) + ",expoOut");
	game.triggerEvent("Zoom Camera", getSecond(2) + ",0.65","expoOut");
	dad.playAnim("stressPicoEnding");
	dad.specialAnim = dad.skipDance = true;
	var endSound = FlxG.sound.play(Paths.sound("tankmanBattlefield/erect/endCutscene"));
	if (game.subtitles != null) {
		game.subtitles.offsets = [0, 42];
		game.subtitles.alignment = "bottom";
		game.subtitles.assignSubtitles("stress/subtitles/end-cutscene-pico", endSound);
	}
	new FlxTimer().start(176 / 24, () -> {
		boyfriend.playAnim('laughEnd');
		boyfriend.specialAnim = boyfriend.skipDance = true;
	});
	new FlxTimer().start(270 / 24, () -> {
		game.triggerEvent("Focus Camera", "dad", "320,-370," + getSecond(2)  + ",quadInOut");
		FlxG.camera.fade(FlxColor.BLACK,2);
	});
	new FlxTimer().start(320 / 24, () -> game.endSong());
}