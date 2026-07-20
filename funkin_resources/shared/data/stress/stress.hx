var videoStart = false;
var story = !PlayState.seenCutscene && PlayState.isStoryMode;
function onStartCountdown() {
	if (!videoStart & story) {
		game.startVideo("stressCutscene");
		videoStart = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}