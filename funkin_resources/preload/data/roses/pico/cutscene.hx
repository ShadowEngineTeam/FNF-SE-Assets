import backend.HapticUtil;


function onCreate(){
	game.startHScriptsNamed("stages/props/DialoguePixel");
}
var start = false;
var seen = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!start && seen) {
		FlxG.sound.play(Paths.sound("dialogue/roses/angry-appear"));
		HapticUtil.vibrate(0.1, 0.5, 1, 1);
		game.callOnScripts("startConversation", ["pico/dialogue"]);
		start = true;
		return Function_Stop;
	}
}