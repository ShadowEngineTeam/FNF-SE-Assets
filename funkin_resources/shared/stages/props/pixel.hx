import backend.EaseUtil;
if (!PlayState.isPixelStage) return;
var oldQuality = FlxG.game.stage.quality;
var mosaicShader = [];
var mosaicFilter = [];
function onCreate(){
	FlxG.game.stage.quality = 2;
	//applyMosaic(FlxG.camera);
}
function applyMosaic(camera){
	camera.antialiasing = false;
	camera.pixelPerfectRender = true;
	
	var shader:FlxRuntimeShader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/mosaic.frag"));
	shader.setFloatArray("uBlocksize", [1, 1]);
	
	var shader2:FlxRuntimeShader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/mosaic.frag"));
	shader2.setFloatArray("uBlocksize", [1, 1]);
	
	mosaicShader.push([shader, shader2, camera]);
	mosaicFilter.push([new ShaderFilter(shader), new ShaderFilter(shader2)]);
}
function onDestroy(){
	FlxG.game.stage.quality = oldQuality;
}
function onUpdatePost(e) {
	updateShader();
	updateSplashesScale();
	FlxG.camera.pixelPerfectRender = true;
}
function onBeatHit(){
	updateShader();
}
function goodNoteHit() {
	updateSplashesScale();
}
function opponentNoteHit() {
	updateSplashesScale();
}
function updateSplashesScale() {
	for (i in grpNoteSplashes) {
		i.scale.set(4, 4);
	}
}
function onEvent(n){
	if (name == "Zoom Camera") updateShader();
}
function updateShader(){
	for (i in 0...mosaicShader.length) {
		if (mosaicShader[i] == null) return;
		var shader = mosaicShader[i];
		var filter = mosaicFilter[i];
		var zoom:Float = shader[2].zoom;
		var size:Float = 6 * zoom;
		shader[0].setFloatArray("uBlocksize", [size, 1]);
		shader[1].setFloatArray("uBlocksize", [1, size]);
		if (!shader[2].filters.contains(filter[0])) shader[2].filters.push(filter[0]);
		if (!shader[2].filters.contains(filter[1])) shader[2].filters.push(filter[1]);
	}
}