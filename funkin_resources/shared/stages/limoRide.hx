import objects.BGSprite;
import backend.Funkin;

var car:BGSprite;
var bgLimo:BGSprite;
var boyfriendPole:BGSprite;
var boyfriendLight:BGSprite;
var henchmenGroup:FlxSpriteGroup;
var lampPole:FlxSpriteGroup;
var poleLamp:FlxSpriteGroup;
function onCreate(){
	var blendOverlay = new FlxRuntimeShader(Paths.getTextFromFile("shaders/overlayblend.frag"));
	blendOverlay.setBitmapData("funnyShit", Paths.image("stages/limo/limoOverlay").bitmap);
	
	var limoSunset:BGSprite = new BGSprite("stages/limo/limoSunset", -120, -50, 0.1, 0.1);
	insert(members.indexOf(gfGroup), limoSunset);
	limoSunset.shader = blendOverlay;
	
	lampPole = new FlxSpriteGroup(0, -20);
	poleLamp = new FlxSpriteGroup(0, -50);
	for (i in 0...4){
		var pole:BGSprite = new BGSprite("stages/limo/highwayPoleTall", -750 + 750 * i, 0, 0.9, 0.9);
		lampPole.add(pole);
		
		var light:BGSprite = new BGSprite("stages/limo/highwayLight", -750 + 750 * i, 0, 0.9, 0.9);
		poleLamp.add(light);
	}
	
	insert(members.indexOf(gfGroup), lampPole);
	insert(members.indexOf(gfGroup), poleLamp);
	
	boyfriendPole = new BGSprite("stages/limo/highwayPole", -750, 250);
	insert(members.indexOf(gfGroup), boyfriendPole);
	
	boyfriendLight = new BGSprite("stages/limo/highwayLight", -750, 150);
	if (PlayState.SONG.song.toLowerCase() != "milf") {
		insert(members.indexOf(gfGroup), boyfriendLight);
	}
	
	
	
	bgLimo = new BGSprite("stages/limo/bgLimo", -200, 480, 0.4, 0.4, ["background limo pink"], true);
	insert(members.indexOf(gfGroup), bgLimo);
	
	henchmenGroup = new FlxSpriteGroup(100,100);
	henchmenGroup.scrollFactor.set(0.4,0.4);
	for (i in 0...5){
		var sprite:BGSprite = new BGSprite("stages/limo/henchmen", 300 * i, 0, 0.4, 0.4, ["hench"]);
		sprite.animation.addByIndices("danceLeft","hench dancing",[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14],"",24,false);
		sprite.animation.addByIndices("danceRight", "hench dancing", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29],"",24, false);
		sprite.animation.addByPrefix("hit1", "hench hit 10",0);
		sprite.animation.addByPrefix("hit2", "hench hit 20",0);
		sprite.animation.play("danceLeft");
		henchmenGroup.add(sprite);
	}
	insert(members.indexOf(gfGroup), henchmenGroup);
	
	var limoDrive:BGSprite = new BGSprite("stages/limo/limoDrive", -128, 528, 1, 1, ["Limo stage"], true);
	insert(members.indexOf(gfGroup) + 1, limoDrive);
	
	remove(game.boyfriendGroup);
	insert(members.indexOf(limoDrive) + 1, game.boyfriendGroup);

	if (PlayState.SONG.song.toLowerCase() == "milf") {
		insert(members.indexOf(game.boyfriendGroup) + 1, boyfriendLight);
	}
	
	car = new BGSprite("stages/limo/fastCarLol", -12600, 160);
	add(car);
	
	
}
var car_can_pass = true;
function carGoInto300Kilometer(){
	FlxG.sound.play(Paths.sound("limo/carPass" + FlxG.random.int(0, 1)));
	car.x = -12600;
	car.active = true;
	car.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
	car.y = FlxG.random.int(140, 250);
	car_can_pass = false;
	new FlxTimer().start(2, function() {
		car_can_pass = true;
		car.velocity.x = 0;
		car.x = -12600;
	});
}
function onBeatHit() {
	if (FlxG.random.bool(10) && car_can_pass) carGoInto300Kilometer();
	for (i in henchmenGroup) {
		if (StringTools.startsWith(i.animation.curAnim.name, "dance")) {
			i.animation.play(curBeat % 2 == 0 ? "danceRight" : "danceLeft");
		}
	}
}
function moveLamp(){
	for (i in 0...4) {
		var lamp = lampPole.members[i];
		lamp.active = true;
		lamp.velocity.x = 75 / FlxG.elapsed * game.playbackRate;
		if (lamp.x > 2250) lamp.x = -750;
		poleLamp.members[i].x = lamp.x - 120;
	}
}
function moveBFPole(){
	boyfriendPole.active = true;
	boyfriendPole.velocity.x = 75 / FlxG.elapsed * game.playbackRate;
	boyfriendLight.x = boyfriendPole.x - 180;
}
var doHit = false;
var gfDuck = false;
// can press dodge early other than
var didDodge = false;
function resetBFPole(){
	gfDuck = false;
	doHit = false;
	didDodge = false;
	boyfriendPole.velocity.x = 0;
	boyfriendPole.x = -750;
	boyfriendLight.x = boyfriendPole.x - 180;
}
var diedByPole = false;
var lambPoleTime = 1000; //47900;
function onUpdate(){
	moveLamp();
	henchmenGroup.x = bgLimo.x + 300;
	if (Conductor.songPosition > lambPoleTime){
		moveBFPole();
		if (#if FEATURE_MOBILE_CONTROLS game.mobileControls.buttonExtra.pressed || #end FlxG.keys.justPressed.SPACE || game.cpuControlled) didDodge = true;
		if (PlayState.SONG.song.toLowerCase() == "milf") {
			if (!gfDuck && game.gf != null) {
				gfDuck = true;
				gf.playAnim("duck");
				gf.skipDance = true;
				gf.specialAnim = true;
			}
			if (Conductor.songPosition > lambPoleTime + 430 && !doHit) {
				doHit = true;
				if (gf != null) gf.skipDance = false;
				doLampHit();
			}
		}
		if (Conductor.songPosition > lambPoleTime + 900){
			lambPoleTime += 900 + FlxG.random.float(1.5, 3) * 10000;
		}
		
		// died by cringe
		for (i in 0...henchmenGroup.length){
			var henchman = henchmenGroup.members[i];
			var x = henchman.x;
			var center = henchman.getMidpoint().x + 300;
			var lamp = boyfriendPole.getGraphicMidpoint().x;
			if (lamp >= x && henchman.visible) {
				var oX = Math.max(0, lamp - x) - 30;
				var oY = 0;
				if (StringTools.startsWith(henchman.animation.curAnim.name, "dance")) {
					henchman.animation.play("hit" + FlxG.random.int(1,2));
				}
				if (henchman.animation.curAnim.name == "hit2") oY = -100;
				henchman.offset.set(-oX, oY);
				if (lamp >= center) {
					gibHenchman(henchman);
					henchman.visible = false;
					// it loud as fuck 
					if (i == 0) FlxG.sound.play(Paths.sound("limo/dancerdeath"), 0.3);
				}
			}
		}
	} else {
		resetBFPole();
	}
	if (!henchmenGroup.members[4].visible && !doTweenLimo){
		doTweenLimo = true;
		FlxTween.tween(bgLimo, {x: 1800}, 1, {ease:FlxEase.backIn, onComplete: function(){
			FlxTween.tween(bgLimo, {x: -200}, 3, {ease: FlxEase.backOut});
			for (i in henchmenGroup) {
				i.visible = true;
				i.animation.play("danceLeft");
				i.offset.set();
			}
			doTweenLimo = false;
		}});
	}
}
function onCountdownTick(t) {
	for (i in henchmenGroup) {
		if (StringTools.startsWith(i.animation.curAnim.name, "dance")) {
			i.animation.play(curBeat % 2 == 0 ? "danceRight" : "danceLeft");
		}
	}
}
function onGameOverStart(){
	if (diedByPole){
		boyfriend.active = true;
		boyfriend.velocity.x = 2500;
		boyfriend.angularVelocity = 30;
		boyfriend.angularAcceleration = 30;
	}
}
function goodNoteHitPre(n){
	if (boyfriend.anim.curAnim.name == "dodge") {
		n.noAnimation = true;
	}
}
function doLampHit(){
	if (didDodge) {
		boyfriend.playAnim("dodge");
		boyfriend.specialAnim = true;
		FlxG.sound.play(Paths.sound("limo/Light_Pass_Head_" + FlxG.random.int(1, 4)));
	} else {
		var healthLose = 0.5;
		if (game.health - healthLose <= 0) diedByPole = true;
		game.health -= healthLose;
		boyfriend.playAnim("hit");
		boyfriend.specialAnim = true;
		FlxG.sound.play(Paths.sound("limo/BF_Hit_by_Passing_Light"));
		
	}
}
function createGib(type:Int) {
	var random:Bool = FlxG.random.bool();
	var animationName = "";
	switch(type) {
		case 0:
			animationName = "hench head spin " + (random ? "1" : "2");
		case 1:
			animationName = "hench arm spin " + (random ? "1" : "2");
		case 2:
			animationName = "hench leg spin " + (random ? "1" : "2");
		default:
	}
	var gibSprite:BGSprite = new BGSprite("stages/limo/henchmen", 0, 0, 0.4, 0.4, [animationName], true);
	gibSprite.animation.curAnim.frameRate = FlxG.random.int(15, 45);
	gibSprite.angle = FlxG.random.int(0, 360);
	gibSprite.active = true;
	gibSprite.velocity.x = FlxG.random.int(-20, -1000);
	gibSprite.velocity.y = FlxG.random.int(-20, -260);
	gibSprite.maxVelocity.x = gibSprite.maxVelocity.y = 0;
	gibSprite.acceleration.y = FlxG.random.int(400, 1400);
	gibSprite.acceleration.x = 8000;
	return gibSprite;
}
var gibs:Array<FlxSprite> = [];
function gibHenchman(target:FlxSprite) {
	var headGib = createGib(0);
	headGib.x = target.x + FlxG.random.int(-20, 20);
	headGib.y = target.y + 50;
	insert(members.indexOf(henchmenGroup) + 1, headGib);
	gibs.push(headGib);

	var armGib = createGib(1);
	armGib.x = target.x + 160 + FlxG.random.int(-20, 20);
	armGib.y = target.y + 200;
	insert(members.indexOf(henchmenGroup) + 1, armGib);
	gibs.push(armGib);

	var legGib = createGib(2);
	legGib.x = target.x + 200 + FlxG.random.int(-20, 20);
	legGib.y = target.y;
	insert(members.indexOf(henchmenGroup) + 1, legGib);
	gibs.push(legGib);

	var bloodEffect:BGSprite = new BGSprite("stages/limo/effects", target.x - 110, target.y + 20, 0.4, 0.4, ["blood 1"]);
	bloodEffect.angle = -90;
	bloodEffect.flipX = true;
	insert(members.indexOf(henchmenGroup) + 1, bloodEffect);
	gibs.push(bloodEffect);
	bloodEffect.animation.finishCallback = function(_name) {
		remove(bloodEffect);
		gibs.remove(bloodEffect);
	}
	new FlxTimer().start(1, function() {destroyAllGibs();});
}
function destroyAllGibs() {
	for (gib in gibs) {
		gib.kill();
		remove(gib);
	}
	gibs = [];
}