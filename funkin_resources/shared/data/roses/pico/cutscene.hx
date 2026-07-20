
function onCreate(){
	game.startHScriptsNamed("stages/props/DialoguePixel");
}
var start = false;
var seen = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!start && seen) {
		game.callOnScripts("startConversation", ["pico/dialogue"]);
		start = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}