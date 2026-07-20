import objects.BGSprite;
import shaders.AdjustColorShader;


var blendSprite:FlxSprite; // graphic  that used when use Philly Event
var window:BGSprite;
var gradient:BGSprite;
var particleGroup:FlxSpriteGroup;
var pos = 255;
// visible 30%
var spritePhillyGlow:Array<BGSprite> = [];
var train:BGSprite;
Paths.image("stages/philly/particle");
function onCreate(){
	var sky = new BGSprite("stages/philly/sky", -100, 0, 0.1, 0.1);
	insert(members.indexOf(gfGroup), sky);
	spritePhillyGlow.push(sky);
	
	var city = new BGSprite("stages/philly/city", -255, 45, 0.3, 0.3);
	city.scale.set(0.9, 0.9);
	city.updateHitbox();
	insert(members.indexOf(gfGroup), city);
	spritePhillyGlow.push(city);

	window = new BGSprite("stages/philly/win", -184, 155, 0.3, 0.3);
	window.scale.set(0.9, 0.9);
	window.updateHitbox();
	insert(members.indexOf(gfGroup), window);
	
	gradient = new BGSprite("stages/philly/gradient", -400, 225);
	gradient.setGraphicSize(2000, 400);
	gradient.updateHitbox();
	
	
	var behindTrain = new BGSprite("stages/philly/behindTrain", -299, 144);
	insert(members.indexOf(gfGroup), behindTrain);
	spritePhillyGlow.push(behindTrain);
	
	particleGroup = new FlxSpriteGroup();
	
		
	for(i in 0...100) {
		var particles = new BGSprite("stages/philly/particle");
		particleGroup.add(particles);
	}
	// fuck you
	gradient.alpha = 0.7;
	gradient.visible = particleGroup.visible = false;
	

	train = new BGSprite("stages/philly/train", 2000, 360);
	insert(members.indexOf(gfGroup), train);
	
	
	insert(members.indexOf(gfGroup), gradient);
	if(!ClientPrefs.data.lowQuality) 
		insert(members.indexOf(gfGroup), particleGroup);
	
	var street = new BGSprite("stages/philly/street", -299, 144);
	insert(members.indexOf(gfGroup), street);
	spritePhillyGlow.push(street);
	
	// use this since character shader make color doesn't work 
	blendSprite = new FlxSprite().makeGraphic(1,1);
	blendSprite.scale.set(2000,2000);
	blendSprite.updateHitbox();
	blendSprite.scrollFactor.set();
	blendSprite.alpha = 0;
	blendSprite.blend = 11;
	add(blendSprite);
	
	doWinlight();
}
var trainMoving = false;
var trainFinishing = false;
var trainFrameTiming = 0;
var toggle = 0;
var trainCars = 8;
var trainCooldown = 0;
var trainSoundTime = 0;
function onUpdatePost(elapsed){
	if (trainMoving) {
		trainFrameTiming += elapsed;
		if (trainFrameTiming >= 1 / 24) {
			updateTrainPos();
			trainFrameTiming = 0;
		}
	}
	trainSoundTime += elapsed * 1000;
	gradient.setGraphicSize(2000, Math.max(1, gradient.height - 1000 * elapsed));
	gradient.updateHitbox();
	gradient.y = 655 - gradient.height;
	window.alpha = FlxMath.lerp(0, window.alpha, Math.exp(-elapsed * Conductor.crochet / 1000 * 1.5));
	for(i in particleGroup){
		if (i.alpha <= 0) continue;
		i.y -= FlxG.height/2 * FlxG.elapsed;
		i.alpha = FlxMath.lerp(0,i.alpha, Math.exp(-elapsed));
		i.scale.set(i.alpha,i.alpha);
	}
}
function onBeatHit(){
	if (curBeat % game.camZoomingFrequency == 0 && toggle == 0) doWinlight();
	if (!trainMoving) trainCooldown += 1;
	if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8) {
		trainCooldown = FlxG.random.int(-4, 0);
		trainSoundTime = 0;
		trainMoving = true;
		FlxG.sound.play(Paths.sound("phillyTrain/train_passes"));
	}
}
function doWinlight() {
	window.alpha = 1;
	var windowColor = [0xFF31A2FD, 0xFF31FD8C, 0xFFFB33F5, 0xFFFBA633, 0xFFFD4531][FlxG.random.int(0,4)];
	gradient.height = 400;
	gradient.color = windowColor;
	blendSprite.color = windowColor;
	window.color = windowColor;
	doParticle();
	for (i in particleGroup) i.color = windowColor;
}
function doParticle(){
	var num = FlxG.random.int(8, 36);
	for (i in particleGroup) {
		if (!FlxG.random.bool(30)) continue;
		i.x = FlxG.random.int(-400, 2000);
		i.y = 500 + FlxG.random.float(0, 125);
		i.scrollFactor.set(FlxG.random.float(0.3, 0.75), FlxG.random.float(0.65, 0.75));
		i.alpha = 1;
	}
}
function onSongRestart(){
	if (toggle != 0) onEvent("Philly Glow", "0");
}
function onEvent(n, v1){
	if (n == "Hey!" && v1 == "gf" && startedMoving) {
		
		game.gf.playAnim("hairBlow");
		game.gf.specialAnim = true;
	}
	if (n == "Philly Glow") {
		doWinlight();
		if (toggle == 0)FlxG.camera.flash(window.color, 0.15);
		game.triggerEvent("Add Camera Zoom","","");
		if (v1 == "0") FlxG.camera.flash(null, 0.15);
		toggle = Std.parseInt(v1);
		gradient.visible = particleGroup.visible = v1 == "1";
		blendSprite.alpha = v1 == "1" ? 0.6 : 0;
		train.visible = v1 == "0";
		for (i in spritePhillyGlow) i.color = toggle == 1 ? 0xFF3F3F3F : 0xFFFFFFFF;
	}
}
function updateTrainPos() {
	if (trainSoundTime >= 4700) {
		startedMoving = true;
		game.gf.playAnim("hairBlow");
		game.gf.specialAnim = true;
	}
	if (startedMoving) {
		train.x -= 400;
		if (train.x < -2000 && !trainFinishing)
		{
			train.x = -1150;
			trainCars -= 1;
			if (trainCars <= 0) trainFinishing = true;
		}
		if (train.x < -4000 && trainFinishing) trainReset();
	}
}
function trainReset() {
	train.x = FlxG.width + 200;
	game.gf.playAnim('hairFall');
	game.gf.danced = false;
	game.gf.specialAnim = true;
	trainMoving = false;
	trainCars = 8;
	trainFinishing = false;
	startedMoving = false;
}