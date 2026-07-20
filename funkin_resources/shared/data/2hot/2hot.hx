var startB = false;
function onEndSong(){
	if (!startB && PlayState.isStoryMode){
		startB = true;
		game.startVideo("2hotCutscene");
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
}