import objects.BGSprite;
import shaders.RuntimePostEffectShader;
import flixel.addons.display.FlxBackdrop;
import flixel.math.FlxBasePoint;
import backend.CoolUtil;
import animate.FlxAnimate;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import shaders.AdjustColorShader;
var colorShader;
var scrollingSky;
var car1, car2, traffic;
var mist0,mist1,mist2,mist3,mist4,mist5;
var paper;
var propDark;
var canEnabled = false;
var spraycanAtlas;
var explodeEz;
var explode;
var casingGroup;
function onCreate(){
	colorShader = new AdjustColorShader();
	colorShader.hue = -5;
	colorShader.saturation = -40;
	colorShader.contrast = -25;
	colorShader.brightness = -20;
	
	scrollingSky = new FlxBackdrop(Paths.image("stages/phillyStreets/phillyStreets/erect/phillySkybox"));
	insert(members.indexOf(gfGroup),scrollingSky);
	
	scrollingSky.setPosition(-650, -375);
	scrollingSky.scrollFactor.set(0.1, 0.1);
	scrollingSky.scale.set(0.65, 0.65);
	
	var phillySkyline = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillySkyline", -545, -273, 0.2, 0.2);
	insert(members.indexOf(gfGroup),phillySkyline);
	
	var phillyForegroundCity = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyForegroundCity", 1865, 220, 0.3, 0.3);
	insert(members.indexOf(gfGroup),phillyForegroundCity);
	
	var phillyForegroundCity2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyForegroundCity", 1865, 220, 0.3, 0.3);
	phillyForegroundCity2.angle = 5;
	insert(members.indexOf(gfGroup),phillyForegroundCity2);
	
	mist5 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist5.setPosition(-650, -100);
	mist5.scrollFactor.set(0.5, 0.5);
	insert(members.indexOf(gfGroup),mist5);
	mist5.blend = 0;
	mist5.color = 0xFF5c5c5c;
	mist5.alpha = 1;
	mist5.velocity.x = 20;
	mist5.scale.set(1.1, 1.1);
	
	var phillyConstruction2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyConstruction", 1795, 364, 0.7, 1);
	insert(members.indexOf(gfGroup),phillyConstruction2);
	
	var phillyHighwayLights = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyHighwayLights", 122, 201, 0.8, 0.8);
	insert(members.indexOf(gfGroup),phillyHighwayLights);
	
	var phillyHighwayLights_lightmap = new BGSprite("stages/phillyStreets/phillyStreets/phillyHighwayLights_lightmap", 122, 201, 0.8, 0.8);
	phillyHighwayLights_lightmap.blend = 0;
	insert(members.indexOf(gfGroup),phillyHighwayLights_lightmap);
	
	
	
	
	var phillyHighway2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyHighway", -23, 105, 0.8, 0.8);
	insert(members.indexOf(gfGroup),phillyHighway2);

	car1 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	insert(members.indexOf(gfGroup),car1);
	
	car2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyCars", 1200, 818, 0.9, 1,["car1","car2","car3","car4"]);
	car2.flipX=true;
	insert(members.indexOf(gfGroup),car2);
	
	
	mist4 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistBack'), 0x01);
	mist4.setPosition(-650, -100);
	mist4.scrollFactor.set(0.8, 0.8);
	insert(members.indexOf(gfGroup),mist4);
	mist4.blend = 0;
	mist4.color = 0xFF5c5c5c;
	mist4.alpha = 1;
	mist4.velocity.x = 40;
	mist4.scale.set(0.7, 0.7);
	
	traffic = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyTraffic", 1840, 608, 0.9, 1,["redtogreen","greentored"]);
	insert(members.indexOf(gfGroup),traffic);
	
	var phillyTraffic_lightmap = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyTraffic_lightmap", 1840, 608, 0.9, 1);
	phillyTraffic_lightmap.blend = 0;
	insert(members.indexOf(gfGroup),phillyTraffic_lightmap);
	
	var grey1 = new BGSprite("stages/phillyStreets/phillyStreets/erect/greyGradient", -388, 7);
	grey1.scale.set(1.3, 1.3);
	grey1.updateHitbox();
	grey1.alpha = 0.3;
	insert(members.indexOf(gfGroup),grey1);
	
	var grey2 = new BGSprite("stages/phillyStreets/phillyStreets/erect/greyGradient", -388, 7);
	grey2.scale.set(1.3, 1.3);
	grey2.updateHitbox();
	grey2.alpha = 0.8;
	insert(members.indexOf(gfGroup),grey2);
	
	var phillyForeground = new BGSprite("stages/phillyStreets/phillyStreets/erect/phillyForeground", 88, 317);
	insert(members.indexOf(gfGroup),phillyForeground);
	
	propDark = new FlxSprite(-500, -1000).makeGraphic(1,1,0xFF000000);
	propDark.scale.set(5000, 5000);
	propDark.updateHitbox();
	propDark.alpha = 0;
	insert(members.indexOf(gfGroup),propDark);
	
	casingGroup = new FlxSpriteGroup(2200, 900);
	add(casingGroup);
	
	spraycanAtlas = new FlxAnimate(910, 495);
	spraycanAtlas.frames = Paths.getTextureAtlas("stages/phillyStreets/spraycanAtlas");
	spraycanAtlas.shader = colorShader;
	spraycanAtlas.anim.addBySymbolIndices("start", "Can with Labels", CoolUtil.numberArray(18), 24, false);
	spraycanAtlas.anim.addBySymbolIndices("hit", "Can with Labels", CoolUtil.numberArray(25,19), 24, false);
	spraycanAtlas.anim.addBySymbolIndices("shot", "Can with Labels", CoolUtil.numberArray(42,26), 24, false);
	spraycanAtlas.visible = false;
	
	add(spraycanAtlas);
	
	explode = new FlxSprite(1060, 245);
	explode.frames = Paths.getSparrowAtlas("stages/phillyStreets/SpraypaintExplosion");
	explode.animation.addByPrefix("idle", "Explosion 1 movie0", 24, false);
	explode.animation.play("idle");
	explode.visible = false;
	explode.shader = colorShader;
	explode.animation.finishCallback = (name) -> {
		explode.visible = false;
	};
	add(explode);
	
	explodeEZ = new FlxSprite(1660 , 395);
	explodeEZ.frames = Paths.getSparrowAtlas("stages/phillyStreets/spraypaintExplosionEZ");
	explodeEZ.shader = colorShader;
	explodeEZ.animation.addByPrefix("idle", "explosion round 1 short0", 24, false);
	explodeEZ.animation.play("idle");
	explodeEZ.visible = false;
	add(explodeEZ);
	explodeEZ.animation.finishCallback = (name) -> { explodeEZ.visible = false;
	};
	
	spraycanAtlas.anim.finishCallback = finishCanAnimation;
	spraycanAtlas.anim.onFrameChange.add(onCanFrame);
	
	
	var SpraycanPile = new BGSprite("stages/phillyStreets/SpraycanPile", 920, 1045);
	add(SpraycanPile);
	SpraycanPile.shader = colorShader;
	
	mist3 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist3.setPosition(-650, -100);
	mist3.scrollFactor.set(0.95, 0.95);
	insert(members.indexOf(gfGroup),mist3);
	mist3.blend = 0;
	mist3.color = 0xFF5c5c5c;
	mist3.alpha = 0.5;
	mist3.velocity.x = -50;
	mist3.scale.set(0.8, 0.8);
	
	
	mist0 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist0.setPosition(-650, -100);
	mist0.scrollFactor.set(1.2, 1.2);
	add(mist0);
	mist0.blend = 0;
	mist0.color = 0xFF5c5c5c;
	mist0.alpha = 0.6;
	mist0.velocity.x = 172;
	
	mist1 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistMid'), 0x01);
	mist1.setPosition(-650, -100);
	mist1.scrollFactor.set(1.1, 1.1);
	add(mist1);
	mist1.blend = 0;
	mist1.color = 0xFF5c5c5c;
	mist1.alpha = 0.6;
	mist1.velocity.x = 150;
	
	mist2 = new FlxBackdrop(Paths.image('stages/phillyStreets/phillyStreets/erect/mistBack'), 0x01);
	mist2.setPosition(-650, -100);
	mist2.scrollFactor.set(1.2, 1.2);
	add(mist2);
	mist2.blend = 0;
	mist2.color = 0xFF5c5c5c;
	mist2.alpha = 0.8;
	mist2.velocity.x = -80;
	
	paper = new BGSprite("stages/phillyStreets/phillyStreets/erect/paper", 350, 608,1.1,1.1,["Paper Blowing instance 1"]);
	add(paper);
	
	paper.alpha = 0.001;
	
	
	if (ClientPrefs.data.lowQuality){
		for (i in [mist0,mist1,mist2,mist3,mist4,mist5]) remove(i);
	}
	game.startHScriptsNamed("stages/props/rainShader");
}
function onCreatePost() {
	if (ClientPrefs.data.shaders) for (i in [dad, boyfriend, gf]) i.shader = colorShader;
}
var _timer:Float = 0;
function onUpdate(elap){
	_timer += elap;
	mist0.y = 660 + (Math.sin(_timer * 0.35) * 70);
	mist1.y = 500 + (Math.sin(_timer * 0.3) * 80);
	mist2.y = 540 + (Math.sin(_timer * 0.4) * 60);
	mist3.y = 230 + (Math.sin(_timer * 0.3) * 70);
	mist4.y = 170 + (Math.sin(_timer * 0.35) * 50);
	mist5.y = -80 + (Math.sin(_timer * 0.08) * 100);
}
var lightsStop:Bool = false;
var lastChange:Int = 0;
var changeInterval:Int = 8;
var carWaiting:Bool = false;
var carInterruptable:Bool = true;
var car2Interruptable:Bool = true;
function changeLights(beat:Int) {
	lastChange = beat;
	lightsStop = !lightsStop;
	if (lightsStop) {
		traffic.animation.play('greentored');
		changeInterval = 20;
	} else {
		traffic.animation.play('redtogreen');
		changeInterval = 30;
		if (carWaiting == true) finishCarLights(car1);
	}
}
function resetCar(left:Bool, right:Bool) {
	if (left) {
		carWaiting = false;
		carInterruptable = true;
		FlxTween.cancelTweensOf(car1);
		car1.x = 1200;
		car1.y = 818;
		car1.angle = 0;
	}
	if (right) {
		car2Interruptable = true;
		FlxTween.cancelTweensOf(car2);
		car2.x = 1200;
		car2.y = 818;
		car2.angle = 0;
	}
}
function finishCarLights(sprite) {
	carWaiting = false;
	var duration:Float = FlxG.random.float(1.8, 3);
	var rotations:Array<Int> = [-5, 18];
	var offset:Array<Float> = [306.6, 168.3];
	var startdelay:Float = FlxG.random.float(0.2, 1.2);
	
	var path = [FlxBasePoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 50), FlxBasePoint.get(3102 - offset[0], 1187 - offset[1] + 40)];

	FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.sineIn, startDelay: startdelay});
	FlxTween.quadPath(sprite, path, duration, true, {ease: FlxEase.sineIn,startDelay: startdelay,onComplete: function(_){
			carInterruptable = true;
		}
	});
}
function driveCarLights(sprite) {
	carInterruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.9, 1.5);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var rotations:Array<Int> = [-7, -5];
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var path = [FlxBasePoint.get(1500 - offset[0] - 20,1049 - offset[1] - 20), FlxBasePoint.get(1770 - offset[0] - 80, 994 - offset[1] + 10), FlxBasePoint.get(1950 - offset[0] - 80, 980 - offset[1] + 15)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, {ease: FlxEase.cubeOut});
	FlxTween.quadPath(sprite, path, duration, true, {ease: FlxEase.cubeOut,onComplete: function(_){
		carWaiting = true;
		if (lightsStop == false) finishCarLights(car1);}
	});
}
function driveCar(sprite) {
	carInterruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.6, 1.2);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var rotations:Array<Int> = [-8, 18];
	var path = [FlxBasePoint.get(1570 - offset[0], 1049 - offset[1] - 30), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 50), FlxBasePoint.get(3102 - offset[0], 1187 - offset[1] + 40)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);
	FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) {
			carInterruptable = true;
		}
	});
}
function driveCarBack(sprite) {
	car2Interruptable = false;
	FlxTween.cancelTweensOf(sprite);
	var variant:Int = FlxG.random.int(1, 4);
	sprite.animation.play('car' + variant);
	var extraOffset = [0, 0];
	var duration:Float = 2;
	switch (variant) {
		case 1:
			duration = FlxG.random.float(1, 1.7);
		case 2:
			extraOffset = [20, -15];
			duration = FlxG.random.float(0.6, 1.2);
		case 3:
			extraOffset = [30, 50];
			duration = FlxG.random.float(1.5, 2.5);
		case 4:
			extraOffset = [10, 60];
			duration = FlxG.random.float(1.5, 2.5);
	}
	var offset:Array<Float> = [306.6, 168.3];
	sprite.offset.set(extraOffset[0], extraOffset[1]);
	var rotations:Array<Int> = [18, -8];
	var path = [FlxBasePoint.get(3102 - offset[0], 1127 - offset[1] + 60), FlxBasePoint.get(2400 - offset[0], 980 - offset[1] - 30), FlxBasePoint.get(1570 - offset[0], 1049 - offset[1] - 10)];
	FlxTween.angle(sprite, rotations[0], rotations[1], duration, null);
	FlxTween.quadPath(sprite, path, duration, true, {onComplete: function(_) {
			car2Interruptable = true;
		}
	});
}
function onSongRestart() {
	lastChange = 0;
}
var paperInterruptable = true;
function onBeatHit() {
	if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && carInterruptable == true)
	{
		if (lightsStop == false) {
			driveCar(car1);
		} else {
			driveCarLights(car1);
		}
	}
	if (FlxG.random.bool(10) && curBeat != (lastChange + changeInterval) && car2Interruptable == true && lightsStop == false) driveCarBack(car2);
	if (curBeat == (lastChange + changeInterval)) changeLights(curBeat);
	if (FlxG.random.bool(8) && paperInterruptable) {
	paper.alpha = 1;
	paper.dance();
	paper.y = 608 + FlxG.random.float(-150,150);
	paperInterruptable = false;
	new FlxTimer().start(2, function() {
		paperInterruptable = true;
		paper.alpha = 0;
	 	});
	}
}
function finishCanAnimation(name){
	if (!canEnabled) return;
	switch(name){
		case "start":
			spraycanAtlas.anim.play("hit");
		case "hit":
			spraycanAtlas.visible = false;
			explodeEZ.visible = true;
			explodeEZ.animation.play("idle",true);
			FlxG.sound.play(Paths.sound("phillyStreets/Pico_Bonk"));
			if ((game.health - 0.7) <= 0) game.boyfriend.idleSuffix = "-explode";
			game.health -= 0.7;
			
			boyfriend.playAnim("hitCan",boyfriend.specialAnim=true);
			FlxFlicker.flicker(boyfriend, 1, 1 / 30, true, true, function(_) {
				FlxFlicker.flicker(boyfriend, 0.5, 1 / 60, true, true);
		});
		case "shot":
			spraycanAtlas.visible = false;
	}
}
function onCanFrame(name, frameNumber, frameIndex) {
	if (frameNumber == 3 && name == "shot") {
		explode.visible = true;
		explode.animation.play("idle",true);
	}
}
var canShootCan = false;
function goodNoteHit(note) onNoteHit(game.characterPlayingAsDad ? dad : boyfriend, note);
function opponentNoteHit(note) onNoteHit(!game.characterPlayingAsDad ? dad : boyfriend, note);
function cockGun(character:Character){
	if (character == null) character = boyfriend;
	canShootCan = true;
	new FlxTimer().start(1/24*3,function()addCasing());
	new FlxTimer().start(1,function()canShootCan=false);
	character.playAnim("reload",true);
	character.specialAnim=true;
	FlxG.sound.play(Paths.sound("phillyStreets/Gun_Prep"));
	afterImage(character);
}
function startCan(){
	spraycanAtlas.anim.play("start",true);
	spraycanAtlas.visible = true;
	canEnabled = true;
}
function shootCan(character:Character){
	if (character == null) character = boyfriend;
	spraycanAtlas.anim.play("shot",true);
	FlxG.sound.play(Paths.sound("phillyStreets/shot" + FlxG.random.int(1, 4)));
	character.playAnim("shoot");
	character.specialAnim=true;
	propDark.alpha = 0.3;
	FlxTween.tween(propDark, {alpha: 0}, 1.4, {startDelay: 1/24});
}
function afterImage(char){
	var currentFrameGraphic = FlxGraphic.fromBitmapData(char.updateFramePixels(), true, null, false);
	var fade = new FlxSprite(char.x, char.y);
	fade.frame = currentFrameGraphic.imageFrame.frame;
	fade.alpha = 0.3;
	fade.x -= char.offset.x;
	fade.y -= char.offset.y;
	fade.updateHitbox();
	FlxTween.tween(fade.scale, {x: 1.3, y: 1.3}, 0.4);
	FlxTween.tween(fade, {alpha: 0}, 0.4, {onComplete: () -> {
		remove(fade);
		fade.destroy();
	}});
	insert(members.indexOf(dadGroup), fade);
}
function addCasing(){
	var casing = new BGSprite("stages/phillyStreets/PicoBullet",0,0,1,1,["Pop0"]);
	casing.dance(true);
	new FlxTimer().start(1/25,function(){
		FlxFlicker.flicker(casing, 10 * (1/24), 1 / 30, true, true, function() {
			FlxFlicker.flicker(casing, 10 * (1/24), 1 / 60, false, true, function() {
				casingGroup.remove(casing);
			});
		});
	});
	casingGroup.add(casing);
}
function onNoteHit(character:Character, note:Note){
	switch(note.noteType) {
		case "weekend-1-cockgun":
			cockGun(character);
		case "weekend-1-firegun":
			if (canShootCan) shootCan(character);
			else character.playAnim("singLEFTmiss",true);
			canShootCan = false;
		case "weekend-1-lightcan":
			character.playAnim("lightcan");
			character.specialAnim=true;
		case "weekend-1-kickcan":
			character.playAnim("kickcan");
			character.specialAnim=true;
			startCan();
		case "weekend-1-kneecan":
			character.playAnim("kneecan");
			character.specialAnim=true;
	}
}