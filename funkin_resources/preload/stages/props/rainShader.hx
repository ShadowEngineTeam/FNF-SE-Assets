import shaders.RuntimePostEffectShader;
var rainShader;
var rainShaderFilter;
var startIntensity = 0;
var endIntensity = 0;
var rainTimeScale = 1;
var autoUpdate = true;
var isBlazin = false;
function onCreate(){
	rainShader = new RuntimePostEffectShader(Paths.getTextFromFile("shaders/rain.frag"));
	rainShader.setFloatArray("uRainColor", [0.4,0.501960784, 0.8]);
	rainShader.setFloat("uScale", FlxG.height / 200);
	rainShader.setFloat('uPuddleScaleY', 0);
	rainShader.setFloat("uTime", 0);
	rainShaderFilter = new ShaderFilter(rainShader);
	if (ClientPrefs.data.shaders) FlxG.camera.filters = [rainShaderFilter];
	switch(PlayState.SONG.song.toLowerCase()){
		case "darnell":
			startIntensity = 0;
			endIntensity = 0.1;
		case "lit-up":
			startIntensity = 0.1;
			endIntensity = 0.2;
		case "2hot":
			startIntensity = 0.2;
			endIntensity = 0.4;
		case "blazin":
			startIntensity = endIntensity = 0.5;
			isBlazin = true;
		default:
			startIntensity = 0.2;
			endIntensity = 0.2;
	}
	if (PlayState.curStage == "phillyStreetsErect") {
		startIntensity /= 10;
		endIntensity /= 10;
	}
}
var uTime = 0;
function onUpdate(elap){
	
	rainShader.setFloat("uIntensity", FlxMath.lerp(startIntensity, endIntensity, game.songPercent));
	uTime += elap * game.playbackRate * rainTimeScale;
	rainShader.setFloat("uTime", uTime);
	if (isBlazin && elap > 0)
		rainTimeScale = 0.02 + Math.pow(0.01, elap / 1.535) * (rainTimeScale - 0.02);
	if (autoUpdate)
		rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
}
function goodNoteHit(){
	if (isBlazin) rainTimeScale += 0.7;
}
// don't let the rain draw over the game over screen
function onGameOver(){
	FlxG.camera.filters = [];
}
function onSongRestart(){
	rainTimeScale = 1;
	if (ClientPrefs.data.shaders) FlxG.camera.filters = [rainShaderFilter];
}
// for spooky mansion erect
function getRainShader() return rainShader;
function setRainIntensity(start, end){
	startIntensity = start;
	endIntensity = end;
}
function setRainAutoUpdate(bool) autoUpdate = bool;