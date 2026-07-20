import psychlua.LuaUtils;
var start = false;
function onEndSong(){
	// had to sperate:sob:
	if (!PlayState.isStoryMode) return;
	if (start) return;
	game.startVideo("blazinCutscene");
	start = true;
	return LuaUtils.Function_Stop;
}