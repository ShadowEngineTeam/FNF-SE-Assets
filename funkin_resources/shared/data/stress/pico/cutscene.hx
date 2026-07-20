var videoStart = false;
var canPlayVideo = !PlayState.seenCutscene;
function onStartCountdown() {
	
	if (!videoStart & canPlayVideo) {
		game.startVideo("stressPicoCutscene");
		videoStart = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
	game.startHScriptsNamed("custom_events/Subtitle");
}
var endCutsceneStart = false;
function onEndSong(){
	if (!endCutsceneStart){
		startEndCutscene();
		endCutsceneStart = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
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
	new FlxTimer().start(0.56, () -> game.triggerEvent("Subtitle", "Singing that was cool and all but...", "2"));
	new FlxTimer().start(3.44, () -> game.triggerEvent("Subtitle", "I just wanna let you know that was...", "1.9"));
	new FlxTimer().start(5.56, () -> game.triggerEvent("Subtitle", "Insanely painful.", "1.34"));
	new FlxTimer().start(10.44, () -> game.triggerEvent("Subtitle", "Assholes.", "1.14"));
	dad.playAnim("stressPicoEnding");
	dad.specialAnim = dad.skipDance = true;
	FlxG.sound.play(Paths.sound("tankmanBattlefield/erect/endCutscene"));
	new FlxTimer().start(176 / 24, () -> {
		boyfriend.playAnim('laugh');
		boyfriend.specialAnim = boyfriend.skipDance = true;
	});
	new FlxTimer().start(270 / 24, () -> {
		game.triggerEvent("Focus Camera", "dad", "320,-370," + getSecond(2)  + ",quadInOut");
		FlxG.camera.fade(FlxColor.BLACK,2);
	});
	new FlxTimer().start(320 / 24, () -> game.endSong());
}