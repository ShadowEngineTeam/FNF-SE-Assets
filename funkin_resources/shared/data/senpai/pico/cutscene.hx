
function onCreate(){
	game.startHScriptsNamed("stages/props/DialoguePixel");
}
var start = false;
var seen = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!start && seen) {
		game.callOnScripts("startConversationFadeIn", ["pico/dialogue"]);
		start = true;
		return Function_Stop;
	}
}
function onNextDialogue(id){
	if (id == 1) FlxG.sound.music.pause();
	// Senpai's music starts over when he talks again, as in Funkin.
	if (id == 7) {
		FlxG.sound.music.play(true);
		FlxG.sound.music.fadeIn(2, 0, 1);
	}
}