import flixel.addons.effects.FlxSkewedSprite;
import flixel.math.FlxBasePoint;
import objects.BGSprite;
import animate.internal.elements.FlxSpriteElement;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.display.FlxBackdrop;
import animate.FlxAnimate;

var perspectiveFloor;
var lightSourse = [];
var carLight = [];
var door;
var stageShader, characterShader;
var dust1,dust2,dust3,dust4;
function onCreate() {
	initShader();
	game.startHScriptsNamed("stages/props/PerspectiveSprite");
	var bg = new BGSprite("stages/sserafim/bg", -1853, -815, 0.75, 0.75);
	insert(members.indexOf(gfGroup), bg);
	bg.shader = stageShader;
	
	perspectiveFloor = game.callOnScripts("createPerspectiveSprite", ["floor", 'stages/sserafim/floor']);
	game.callOnScripts("setPerspectivePosition", ["floor", new FlxBasePoint(790,625), new FlxBasePoint(760, 1375)]);
	game.callOnScripts("setPerspectiveScrollFactor", ["floor", new FlxBasePoint(0.93, 0.93), new FlxBasePoint(1.05, 1.05)]);
	game.callOnScripts("updatePerspectiveView");
	insert(members.indexOf(gfGroup), perspectiveFloor);
	perspectiveFloor.shader = stageShader;
	var backTables = new BGSprite("stages/sserafim/back-tables", -1857, 267, 0.93, 0.93);
	insert(members.indexOf(gfGroup), backTables);
	backTables.shader = stageShader;
	
	var counterStretch = new BGSprite("stages/sserafim/cutscene/counter-stretch", -1858, 377, 0.93, 0.93);
	counterStretch.scale.set(400, 1);
	counterStretch.updateHitbox();
	insert(members.indexOf(gfGroup), counterStretch);
	counterStretch.shader = stageShader;
	
	var burgerCutscene = new BGSprite("stages/sserafim/cutscene/burger-cutscene", -97, 237, 0.93, 0.93);
	insert(members.indexOf(gfGroup), burgerCutscene);
	burgerCutscene.shader = stageShader;
	
	var backStool = new BGSprite("stages/sserafim/back-stools", -1357, 426, 0.94, 0.94);
	insert(members.indexOf(gfGroup), backStool);
	backStool.shader = stageShader;
	
	var backLightColor = new BGSprite("stages/sserafim/lights/back-light-color", -1241, -949, 0.93, 0.93);
	backLightColor.alpha = 0;
	backLightColor.blend = 12;
	insert(members.indexOf(gfGroup), backLightColor);
	lightSourse.push(backLightColor);
	
	var backLightWhite = new BGSprite("stages/sserafim/lights/back-light-white", -771, -559, 0.93, 0.93);
	backLightWhite.alpha = 0;
	backLightWhite.blend = 0;
	insert(members.indexOf(gfGroup), backLightWhite);
	lightSourse.push(backLightWhite);
	
	var truck = new BGSprite("stages/sserafim/truck-stuff", -983, -707, 0.95, 0.95);
	insert(members.indexOf(gfGroup), truck);
	truck.shader = stageShader;
	
	door = new BGSprite("stages/sserafim/truck-door", -980, -173, 0.95, 0.95);
	insert(members.indexOf(gfGroup), door);
	door.visible = false;
	door.shader = stageShader;
	
	var truckLight1 = new BGSprite("stages/sserafim/lights/truck-light1", -962, -607, 0.95, 0.95);
	truckLight1.alpha = 0;
	insert(members.indexOf(gfGroup), truckLight1);
	carLight.push(truckLight1);
	truckLight1.blend = 12;
	
	var truckLight2 = new BGSprite("stages/sserafim/lights/truck-light2", -781, -464, 0.95, 0.95);
	truckLight2.alpha = 0;
	insert(members.indexOf(gfGroup), truckLight2);
	carLight.push(truckLight2);
	
	var frontStool = new BGSprite("stages/sserafim/front-stool", -280, 818);
	frontStool.shader = stageShader;
	add(frontStool);
	
	dust1 = new FlxBackdrop(Paths.image('stages/sserafim/dust/dustMid'), 0x01);
	dust1.setPosition(-650, -200);
	dust1.scrollFactor.set(1.1, 1.1);
	dust1.scale.set(1.5, 1.5);
	dust1.alpha = 0.8;
	dust1.velocity.x = 350;
	add(dust1);

	dust2 = new FlxBackdrop(Paths.image('stages/sserafim/dust/dustBack'), 0x01);
	dust2.setPosition(-650, -250);
	dust2.scrollFactor.set(1.15, 1.15);
	dust2.scale.set(1.5, 1.5);
	dust2.alpha = 0.9;
	dust2.velocity.x = -300;

	dust3 = new FlxBackdrop(Paths.image('stages/sserafim/dust/dustMid'), 0x01);
	dust3.setPosition(-650, -400);
	dust3.scrollFactor.set(1.2, 1.2);
	dust3.scale.set(2, 2);
	dust3.alpha = 0.8;
	dust3.velocity.x = -200;
	add(dust3);

	dust4 = new FlxBackdrop(Paths.image('stages/sserafim/dust/dustBack'), 0x01);
	dust4.setPosition(-650, -1300);
	dust4.scrollFactor.set(1.25, 1.25);
	dust4.scale.set(3.5, 3.5);
	add(dust4);
	dust4.alpha = 0.9;
	dust4.velocity.x = -150;

	dust1.color = 0xff98847d;
	dust2.color = 0xff8b6c63;
	dust3.color = 0xff6e645c;
	dust4.color = 0xff886a60;
}
var custumChar = [];
var charSing = [];
function onCreatePost(){
	game.gfGroup.scrollFactor.set(0.95, 0.95);
	game.boyfriendGroup.scrollFactor.set(0.99, 0.99);
	game.dadGroup.scrollFactor.set(0.97, 0.97);
	game.isCameraOnForcedPos = true;
	game.camFollow.setPosition(1070, 470);
	FlxG.camera.snapToTarget();
	
	iconP2.visible = false;
	
	var character = new Character(-1575, 15, "sserafim-yunjin");
	gfGroup.add(character);
	charSing.push(character);
	custumChar.push(character);
	addLip(character, "mouth yunjin", [['idle', [8,6,23]], ['singLEFT', [6,8, 23]], ['singDOWN', [8, 6, 23]], ['singUP', [6,8,22]], ['singRIGHT', [6, 8, 23]]]);
	
	character.skipDance = true;
	character.playAnim("doorclosed");
	character.specialAnim = true;
	
	charSing.push(game.dad);
	
	var character = new Character(-265, -130, "sserafim-chaewon");
	gfGroup.insert(0, character);
	charSing.push(character);
	custumChar.push(character);
	addLip(character, "mouth default", [['idle', [41, 3, -166]], ['singLEFT', [40, 2, -165]], ['singDOWN', [41, 3, -167]], ['singUP', [38, 0, -168]], ['singRIGHT', [39, 1, -165]]]);
	
	var character = new Character(-285, 495, "sserafim-eunchae");
	gfGroup.add(character);
	charSing.push(character);
	custumChar.push(character);
	addLip(character, "mouth default", [['idle', [43, 6, -168]], ['singLEFT', [43, 6, -169]],  ['singDOWN', [41, 3, -168]], ['singUP', [45, 10, -166]], ['singRIGHT', [42, 5, -166]]]);
	
	charSing.push(game.boyfriend);
	charSing.push(game.gf);
	
	addLip(dad, "mouth default", [['idle', [5,4,-13]], ['singLEFT', [5,4,-14]], ['singDOWN', [4, 6, -12]], ['singUP', [7,2,-14]], ['singRIGHT', [7, 2, -13]]]);
	addLip(game.boyfriend, "mouth edit", [['idle', [7,2,-14]], ['singLEFT', [7,2,-14]], ['singDOWN', [6,3,-15]], ['singUP', [8,1,-15]], ['singRIGHT', [7,2,-15]], ['singLEFT-joint', [7,2,-16]], ['singDOWN-joint', [5,5,-15]], ['singUP-joint', [10,-1,-14]], ['singRIGHT-joint', [6,3,-15]]]);
	
	// fuck u note miss
	// no wonder
	boyfriend.hasMissAnimations = dad.hasMissAnimations = false;
	
	for (i in 0...charSing.length) {
		if (i > 0 && i < 4) charSing[i].visible = false;
		charSing[i].shader = characterShader;
	}
	boyfriend.playAnim("intro-static", true);
	game.gf.playAnim("intro-static", true);
	game.gf.specialAnim=boyfriend.specialAnim = true;
}
var doCutscene = PlayState.isStoryMode && !PlayState.seenCutscene;
var finishedCutscene = false;
function onStartCountdown(){
	stageShader.setFloat("hue", 6);
	stageShader.setFloat("saturation", -74);
	stageShader.setFloat("brightness", -24);
	stageShader.setFloat("contrast", -26);
	characterShader.setFloat("hue", 6);
	characterShader.setFloat("saturation",-74);
	characterShader.setFloat("brightness", -24);
	characterShader.setFloat("contrast", -26);
	game.isCameraOnForcedPos = true;
	game.camFollow.setPosition(1070, 470);
	FlxG.camera.snapToTarget();
	if (finishedCutscene) return;
	if (doCutscene){
		startCutscene();
		doCutscene = false;
		return Function_Stop;
	}
	if (!doCutscene) {
		new FlxTimer().start(0.166666667, function() {
			boyfriend.playAnim("intro", true);
			game.gf.playAnim("intro", true);
			game.gf.specialAnim=boyfriend.specialAnim = true;
			new FlxTimer().start(1.05, function() {
				game.startCountdown();
				game.camFollow.setPosition(1070, 470);
			});
		});
	}
	finishedCutscene = true;
	return Function_Stop;
}
function onUpdatePost(elapsed){
	updateView(FlxG.camera);
	game.playerDance();
}
var injectedLipFrames = [];
var injectedLipSprites = [];
function addLip(char:Character, target:String, ?arrayAnim) {
	var lip = new FlxAnimate();
	var assets = "stages/sserafim/sserafim-lipsync";
	if (char.curCharacter == "sserafim-yunjin") assets = "stages/sserafim/sserafim-lipsync-yunjin";
	lip.frames = Paths.getTextureAtlas(assets);
	// make it 0 so it won't continue playing 
	lip.anim.addBySymbol("l","lip sync all",0,false);
	lip.anim.play("l");
	if (char == boyfriend || char.curCharacter == "sserafim-kazuha") lip.flipX = true;
	var element = new FlxSpriteElement(lip);
	element.active = false;
	for (frame in getFramesWithKeyword(char, target)){
		frame.add(element);
		injectedLipFrames.push([frame, element]);
	}
	injectedLipSprites.push(lip);
	var lastAnimName = null;
	var lastShader = null;
	char.anim.onFrameChange.add(function(name) {
		if (StringTools.startsWith(name, "sing")){
			lip.anim.curAnim.curFrame = Math.floor((Conductor.songPosition/1000)*24) - 1;
		} else {
			lip.anim.curAnim.curFrame = 0;
		}
		if (arrayAnim != null && lastAnimName != name) {
			lastAnimName = name;
			for (i in arrayAnim) {
				if (i[0]== name) {
					lip.offset.set(i[1][0], i[1][1]);
					lip.angle = i[1][2];
				}
			}
		}
		if (lastShader != char.shader) {
			lastShader = char.shader;
			lip.shader = lastShader;
		}
	});
}
function updateView(camera) {
	game.callOnScripts("updatePerspectiveView");
}
function onDestroy() {
	for (i in injectedLipFrames) {
		i[0].elements.remove(i[1]);
		i[0].setDirty();
	}
	injectedLipFrames = [];
	for (lip in injectedLipSprites) lip.destroy();
	injectedLipSprites = [];
}
var singAnimations = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
var baseSinging = [false, false, false, false, false];
var beautiful = false;
function goodNoteHitPre(note) {
	for (i in 0...charSing.length) {
		if (baseSinging[i] != null && (baseSinging[i] == "true" || baseSinging[i] == true)) {
			if (!note.noAnimation) {
				charSing[i].playAnim(singAnimations[note.noteData], true);
				if (i == 5 && beautiful) {
					charSing[i].playAnim(singAnimations[note.noteData] + "-beautiful", true);
				}
			}
			if (i == 4) {
				switch(note.noteType){
					case "sakura-joint":
						if (!note.noAnimation) charSing[i].playAnim(singAnimations[note.noteData] + "-joint", true);
					case "sakura-bf1":
						if (!note.noAnimation) charSing[i].playAnim(singAnimations[note.noteData] + "-bf1", true);
					case "sakura-bf2":
						if (!note.noAnimation) charSing[i].playAnim(singAnimations[note.noteData] + "-bf2", true);
				}
			}
			charSing[i].holdTimer = 0;
		}
	}
	note.noAnimation = true;
}
function noteMiss(n){
	miss(n.noteData);
}
function noteMissPress(n){
	miss(n);
}
function miss(data) {
	for (i in 0...charSing.length) {
		if (baseSinging[i] != null && (baseSinging[i] == "true" || baseSinging[i] == true)) {
			charSing[i].playAnim(singAnimations[data] + "miss", true);
			if (i == 5 && beautiful) {
				charSing[i].playAnim(singAnimations[data] + "miss-beautiful", true);
			}
		}
	}
}
var lightAssets = {
	enabled: false,
	color: ["FFFFFF"],
	duration: [0],
	intensiti: [0]
};
function onEvent(n, v1, v2) {
	switch(n) {
		case "Focus Camera": game.callOnScripts("updatePerspectiveView");
		case "Sserafim Sing":
			baseSinging = v1.split(",");
			for (i in 0...baseSinging.length)
				baseSinging[i] = baseSinging[i] == "true";
		case "Sserafim Show":
			var baseVisible = v1.split(",");
			var targetVisible = [charSing[0], charSing[1], charSing[2], charSing[3], charSing[4]];
			for (i in 0...baseVisible.length)
				targetVisible[i].visible = baseVisible[i] == "true";
		case "Sserafim Beautiful": beautiful = v1 == "true";
		case "Sserafim Dark":
			seyDadkAmt(Std.parseFloat(v1),Std.parseFloat(v2));
		case "Sserafim Pulse Lights":
			var v1Split = v1.split("|");
			var v2Split = v2.split("|");
			lightAssets.color = v1Split[0].split(",");
			lightAssets.enabled = v1Split[1] == "true";
			lightAssets.duration = v2Split[0].split(",");
			lightAssets.intensiti = v2Split[1].split(",");
		case "Sserafim Lights":
			flashTruckLight(Std.parseFloat(v1),Std.parseFloat(v2));
		case "Sserafim Kick":
			if (v1 == "true") {
				FlxG.sound.play(Paths.sound('sserafim/doorKick2'));
				charSing[0].playAnim("kick2");
				charSing[0].specialAnim = true;
				charSing[0].skipDance = false;
				var doorKick;
				doorKick = function(anim, frame) {
					if (frame == 23) {
						door.visible = true;
						charSing[0].anim.onFrameChange.remove(doorKick);
					}
				};
				charSing[0].anim.onFrameChange.add(doorKick);
			} else {
				charSing[0].playAnim("kick1");
				charSing[0].specialAnim = true;
				FlxG.sound.play(Paths.sound('sserafim/doorKick1'));
				startClear();
			}
		case "Sserafim End":
			//end1
			game.camOther.bgColor = FlxColor.BLACK;
			var n = new BGSprite("stages/sserafim/end/end1");
			n.cameras = [camOther];
			n.scale.set(0.67, 0.67);
			n.updateHitbox();
			n.screenCenter();
			add(n);
			FlxG.sound.play(Paths.sound('sserafim/cutscene/end1'));
		case "SetHealthIcon":
			if (v1 == "bf")
				if (v2 == "gf") {
					game.iconP1.changeIcon("gf");
					game.healthBar.rightBar.color= 0xFFa5004d;
				} else {
					game.iconP1.changeIcon("bf");
					game.healthBar.rightBar.color= 0xFF31b1d1;
				}
		case "Sserafim Cover":
			game.camHUD.bgColor = v1 == "true" ? FlxColor.BLACK : 0;
		case "Sserafim Flash":
			FlxG.camera.flash(null,Std.parseFloat(v1));
	}
}
function getFramesWithKeyword(char, keyword:String) {
	if (!char.anim.hasAnimateAtlas) {
		trace('WARNING: getFramesWithKeyword() only works on texture atlases!');
		return [];
	}
	var symbolItems = [];
	var frames = [];
	for (symbol in char.library.dictionary.keys()) {
		var symbolItem=char.library.getSymbol(symbol);
		if (symbolItem == null) continue;
		if (StringTools.contains(symbolItem.name, keyword)) {
			symbolItems.push(symbolItem);
		}
	}
	for (symbolItem in symbolItems) {
		symbolItem.timeline.forEachLayer((layer) -> {
			layer.forEachFrame((frame) -> {
				frames.push(frame);
			});
		});
	}
	return frames;
}
function onBeatHit(){
	for (i in custumChar){
		if (curBeat % 2 == 0 && !StringTools.startsWith(i.anim.curAnim.name, "sing")) i.dance();
	}
	if (lightAssets.enabled){
		flashBackLight(lightAssets.intensiti[curBeat % lightAssets.duration.length], lightAssets.duration[curBeat % lightAssets.duration.length], lightAssets.color[curBeat % lightAssets.duration.length]);
	}
}
function initShader(){
	stageShader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/sserafim.frag"));
	characterShader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/sserafim.frag"));

	stageShader.setFloat("hue", 6);
	stageShader.setFloat("saturation", -74);
	stageShader.setFloat("brightness", -24);
	stageShader.setFloat("contrast", -26);
	
	characterShader.setFloat("hue", 6);
	characterShader.setFloat("saturation", -74);
	characterShader.setFloat("brightness", -24);
	characterShader.setFloat("contrast", -26);
	
	stageShader.setFloat("darkAmt", 0);
	characterShader.setFloat("darkAmt", 0);
	
	stageShader.setFloatArray("lightColor",[1,1,1]);
	characterShader.setFloatArray("lightColor",[1,1,1]);
	
	stageShader.setFloat("pulseStrength",0);
	characterShader.setFloat("pulseStrength",0);
	
	stageShader.setFloat("truckStrength",0);
	characterShader.setFloat("truckStrength",0);
	
	stageShader.setBool("isChar", true);
	characterShader.setBool("isChar", true);
}
function flashBackLight(amount, duration, color){
	for (i in lightSourse) FlxTween.cancelTweensOf(i);
	lightSourse[0].alpha = amount * 0.8;
	lightSourse[1].alpha = amount * 0.7;
	
	lightSourse[0].color = FlxColor.fromString("#" + color);
	
	var red = Std.parseInt("0x" + color.substr(0,2));
	var green = Std.parseInt("0x"+ color.substr(2,2));
	var blue = Std.parseInt("0x" + color.substr(4,2));
	
	stageShader.setFloatArray("lightColor",[red/255,green/255,blue/255]);
	characterShader.setFloatArray("lightColor",[red/255,green/255,blue/255]);
	
	stageShader.setFloat("pulseStrength", amount * 0.8);
	characterShader.setFloat("pulseStrength", amount * 0.8);
	
	FlxTween.tween(lightSourse[0], {alpha: 0}, duration, {ease: FlxEase.cubeInOut, onUpdate: () -> {
		stageShader.setFloat("pulseStrength", lightSourse[0].alpha);
		characterShader.setFloat("pulseStrength", lightSourse[0].alpha);
	}});
	FlxTween.tween(lightSourse[1], {alpha: 0}, duration, {ease: FlxEase.cubeInOut});
}
var darkAmtTween = null;
function seyDadkAmt(amount, duration){
	darkAmtTween?.cancel();
	darkAmtTween = null;
	darkAmtTween = FlxTween.num(stageShader.getFloat("darkAmt"), amount, duration, {ease: FlxEase.sineInOut}, (num) -> {
		stageShader.setFloat("darkAmt", num);
		characterShader.setFloat("darkAmt", num);
	});
}
function flashTruckLight(amount, duration){
	for (i in carLight) {
		FlxTween.cancelTweensOf(i);
		i.alpha = amount;
	}
	stageShader.setFloat("truckStrength", amount);
	characterShader.setFloat("truckStrength", amount);
	FlxTween.tween(carLight[0], {alpha: 0}, duration, {ease: FlxEase.cubeInOut, onUpdate: () -> {
		stageShader.setFloat("truckStrength", carLight[0].alpha);
		characterShader.setFloat("truckStrength", carLight[0].alpha);
	}});
	FlxTween.tween(carLight[1], {alpha: 0}, duration, {ease: FlxEase.cubeInOut});
}
function startClear(){
	for(i in["hue","saturation","brightness","contrast"]){
		FlxTween.num(stageShader.getFloat(i), 0, 12, {ease: FlxEase.sineOut}, function(n){
			stageShader.setFloat(i, n);
			characterShader.setFloat(i, n);
		});
	}
	FlxTween.tween(dust1, {alpha: 0, y: dust1.y + 100}, 5.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust2, {alpha: 0, y: dust2.y + 200}, 4.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust3, {alpha: 0, y: dust3.y + 150}, 6.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust4, {alpha: 0, y: dust4.y + 100}, 4.0 * 4, {ease: FlxEase.sineOut});

	FlxTween.tween(dust1.velocity, {x: 0}, 5.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust2.velocity, {x: 0}, 4.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust3.velocity, {x: 0}, 6.0 * 4, {ease: FlxEase.sineOut});
	FlxTween.tween(dust4.velocity, {x: 0}, 4.0 * 4, {ease: FlxEase.sineOut});
}
function startCutscene(){
	var newCam = new FlxCamera();
	newCam.scroll.set(20, -560);
	var list = FlxG.cameras.list.copy();
	list.insert(2,newCam);
	for (i in list){
		FlxG.cameras.remove(i, false);
		FlxG.cameras.add(i, i == FlxG.camera);
	}
	var defaultCam = FlxCamera._defaultCameras;
	var time = 1/24;
	var bg = new BGSprite("stages/sserafim/bg", -1853, -815, 0.75, 0.75);
	bg.cameras = [newCam];
	bg.shader = stageShader;
	add(bg);
	
	var table = new BGSprite("stages/sserafim/cutscene/counter-stretch", -1858, 377, 0.93, 0.93);
	table.cameras = [newCam];
	table.shader = stageShader;
	table.scale.set(400,1);
	table.updateHitbox();
	add(table);
	
	var burger = new BGSprite("stages/sserafim/cutscene/burger-cutscene", -97, 273, 0.93, 0.93);
	burger.cameras = [newCam];
	burger.shader = stageShader;
	add(burger);
	
	var cutscene = new FlxAnimate(-395, 10);
	cutscene.frames = Paths.getTextureAtlas("stages/sserafim/cutscene/cutsceneMain");
	cutscene.anim.addBySymbol("l","cutsceneMain",24,false);
	cutscene.anim.play("l");
	cutscene.cameras = [newCam];
	add(cutscene);
	
	var solid = new FlxSprite().makeGraphic(FlxG.width*3,FlxG.height*3,FlxColor.BLACK);
	solid.cameras = [newCam];
	solid.alpha = 0;
	solid.screenCenter();
	solid.scrollFactor.set();
	add(solid);
	newCam.fade(0xFF000000, 0, false, null, true);

	for (i in ["hue","saturation","brightness","contrast"]){
		stageShader.setFloat(i,0);
		characterShader.setFloat(i,0);
	}
	perspectiveFloor.cameras = [newCam];
	perspectiveFloor.loadGraphic(Paths.image('stages/sserafim/cutscene/floor-cutscene'));
	newCam.zoom = 0.5;
	game.callOnScripts("updatePerspectiveView");
	FlxG.sound.load(Paths.sound('sserafim/cutscene/startCutscene'),0.001);
	new FlxTimer().start(1, function(){
		cutscene.anim.play("l", true);
		newCam.fade(0xFF000000, 3, true, null, true);
		FlxTween.tween(newCam.scroll,{y: -60}, 3, {ease: FlxEase.circOut, onUpdate: () -> game.callOnScripts("updatePerspectiveView")});
		FlxTween.tween(newCam,{zoom: 0.7}, 3, {ease: FlxEase.circOut, onUpdate: () -> game.callOnScripts("updatePerspectiveView")});
		new FlxTimer().start(time * 20, function(){
			FlxG.sound.play(Paths.sound('sserafim/cutscene/startCutscene'));
		});
		new FlxTimer().start(245 * time, function() { seyDadkAmt(0.2, 0.01);
		});
		new FlxTimer().start(251 * time, function() { seyDadkAmt(0, 0.8);
		});
		new FlxTimer().start(406 * time, function() { seyDadkAmt(0.2, 0.01);
		});
		new FlxTimer().start(411 * time, function() { seyDadkAmt(0, 0.8);
		});
		
		new FlxTimer().start(499 * time, function() {
			for (i in 0...4){
				cutscene.shader = characterShader;
				var value = [0,0,55,-30][i];
				var vari = ["hue","saturation","brightness","contrast"][i];
				FlxTween.num(0, value, 49*time,{ease: FlxEase.sineOut}, function(n){
					stageShader.setFloat(vari, n);
					characterShader.setFloat(vari, n);
				});
			}
		});
		new FlxTimer().start(548 * time, function() {
			for (i in 0...4){
				var value = [10,0,66,-17][i];
				var vari = ["hue","saturation","brightness","contrast"][i];
				FlxTween.num(stageShader.getFloat(vari), value, 15*time,{ease: FlxEase.sineOut}, function(n){
					stageShader.setFloat(vari, n);
					characterShader.setFloat(vari, n);});
			}
		});
		
		new FlxTimer().start(563 * time, function(){
			solid.alpha = 1;
			newCam.fade(0xFFFFFFFF, 30 * time, true, null, true);
		});
		new FlxTimer().start(650 * time, function(){
			FlxG.camera.zoom = game.defaultCamZoom = 0.7;
			game.triggerEvent("Zoom Camera", "5.575, 0.55", "circOut");
			game.startCountdown();
			newCam.bgColor = 0;
			for (i in [bg, table, burger, cutscene]) {
				remove(i);
				i.destroy();
			}
			perspectiveFloor.cameras = defaultCam;
			FlxTween.tween(solid,{alpha: 0}, 3, {ease: FlxEase.sineOut, onComplete: () -> {
				FlxG.cameras.remove(newCam, true);
				remove(solid);
				solid.destroy();
			}});
			perspectiveFloor.loadGraphic(Paths.image('stages/sserafim/floor'));
		});
	});
}