import animate.FlxAnimate;
import shaders.AdjustColorShader;
import backend.InputFormatter;
import flixel.text.FlxTextBorderStyle;

var bloodPool:FlxAnimate;
var cigarette:FlxSprite;
var opponent:FlxAnimate;
var player:FlxAnimate;
var extendBloodPool:Bool = false;
var opponentDied:Bool = false;
var cutsceneTimers:Array<FlxTimer> = [];
var cutsceneSounds = [];
var neneDance:FlxTimer;
var skipText:FlxText;
var cutscenePlaying:Bool = false;
var cutsceneSkipped:Bool = false;
var canSkipCutscene:Bool = false;
function onCreate(){
	bloodPool = new FlxAnimate();
	bloodPool.frames = Paths.getTextureAtlas("stages/philly/erect/bloodPool");
	bloodPool.anim.addByFrameLabel("pool","poolAnim",24, false);
	bloodPool.visible = false;
	insert(members.indexOf(dadGroup), bloodPool);
	opponent = new FlxAnimate();
	opponent.frames = Paths.getTextureAtlas("stages/philly/erect/pico_doppleganger");
	opponent.anim.addByFrameLabel("shoot","shootOpponent",24, false);
	opponent.anim.addByFrameLabel("loop","loopOpponent",24, true);
	opponent.anim.addByFrameLabel("explode","explodeOpponent",24, false);
	opponent.anim.addByFrameLabel("cigarette","cigaretteOpponent",24, false);
	
	player = new FlxAnimate();
	player.frames = Paths.getTextureAtlas("stages/philly/erect/pico_doppleganger");
	player.anim.addByFrameLabel("shoot","shootPlayer",24, false);
	player.anim.addByFrameLabel("loop","loopPlayer",24, true);
	player.anim.addByFrameLabel("explode","explodePlayer",24, false);
	player.anim.addByFrameLabel("cigarette","cigarettePlayer",24, false);
	add(player);
	
	opponent.visible = player.visible = false;
	
	
	cigarette = new FlxSprite();
	cigarette.frames = Paths.getSparrowAtlas('stages/philly/erect/cigarette');
	cigarette.animation.addByPrefix('cigarette spit', 'cigarette spit', 24, false);
	cigarette.visible = false;
	insert(members.indexOf(dadGroup), cigarette);
}
var haveSeen:Bool = PlayState.seenCutscene;
var alreadyStart:Bool = false;
function onStartCountdown(){
	if (!haveSeen && !alreadyStart) {
		camHUD.visible = false;
		game.triggerEvent("Focus Camera", "dad","50,0,0,INSTANT");
		cutsceneTimer(1, startCutscene);
		alreadyStart = true;
		cutscenePlaying = true;
		addSkipText();
		return Function_Stop;
	}
	camHUD.visible = true;
}
function startCutscene(){
	try {
		neneDance = new FlxTimer().start(60/75, function() {
			if (game.gf != null) game.gf.dance();
		}, 0);
		var shader = new AdjustColorShader();
		shader.hue = -26;
		shader.saturation = -16;
		shader.brightness = -5;
		var playerShoots = FlxG.random.bool(50);
		var explode = FlxG.random.bool(8);
		
		opponent.setPosition(dad.x - 497, dad.y - 206);
		player.setPosition(boyfriend.x - 525, boyfriend.y - 206);
		var cameraForceAt:String = "dad";
		var cameraCigaAt:String = "bf";
		
		if (playerShoots) {
			cameraForceAt = "bf";
			cameraCigaAt = "dad";
			cigarette.flipX = true;
			bloodPool.setPosition(dad.x - 180, dad.y + 450);
			cigarette.setPosition(boyfriend.x - 10, boyfriend.y + 260);
			insert(members.indexOf(player), opponent);
		} else {
			bloodPool.setPosition(boyfriend.x + 510, boyfriend.y + 450);
			cigarette.setPosition(boyfriend.x - 400, boyfriend.y + 260);
			add(opponent);
		}
		if (ClientPrefs.data.shaders) {
			player.shader = shader;
			opponent.shader = shader;
		}
		opponent.visible = player.visible = true;
		bloodPool.shader = shader;
		dad.visible = boyfriend.visible = false;
		FlxG.sound.playMusic(Paths.music("phillyTrain/" + (explode ? "cutscene2" : "cutscene")));
		game.callOnScripts("initAudioSource");
		FlxG.sound.music.looped = false;
		Conductor.bpm = 150;
		doAnim(player, playerShoots, explode);
		doAnim(opponent, !playerShoots, explode);
		cutsceneTimer(4, () -> game.triggerEvent("Focus Camera", cameraCigaAt,"0,0,0,CLASSIC"));
		
		cutsceneTimer(6.3, () -> game.triggerEvent("Focus Camera", cameraForceAt,"0,0,0,CLASSIC"));
		
		cutsceneTimer(8.75, () -> {
			// Too late to skip from here, as in Funkin.
			cutscenePlaying = false;
			FlxTween.tween(skipText, {alpha: 0}, 0.5, {ease: FlxEase.quadIn});
			game.triggerEvent("Focus Camera", cameraCigaAt,"0,0,0,CLASSIC");
			if (explode && game.gf != null) {
				game.gf.playAnim('laugh');
				game.gf.specialAnim = true;
			}
		});
		
		cutsceneTimer(11.2, () -> {
			if (explode) {
				bloodPool.visible = true;
				bloodPool.anim.play("pool");
				extendBloodPool = true;
			}
		});
		cutsceneTimer(11.5, () -> {
			if (!explode) {
				cigarette.visible = true;
				cigarette.animation.play('cigarette spit');
			}
		});
		cutsceneTimer(13, () -> {
			neneDance.cancel();
			if (explode) {
				if (playerShoots) {
					
					player.visible = false;
					boyfriend.visible = true;
					if (game.characterPlayingAsDad) fadeToEnd();
					else game.startCountdown();
				} else {
					opponent.visible = false;
					dad.visible = true;
					if (!game.characterPlayingAsDad) fadeToEnd();
					else game.startCountdown();
				}
				opponentDied = true;
			} else {
				player.visible = false;
				boyfriend.visible = true;
				opponent.visible = false;
				dad.visible = true;
				game.startCountdown();
			}
			Conductor.bpm = PlayState.SONG.bpm;
		});
	} catch(e:Dynamic){
		debugPrint(e.toString());
		game.startCountdown();
	}
}
function doAnim(char:FlxAnimate, shoot:Bool = false, explode:Bool = false) {
	try {
		cutsceneSound("picoGasp");
		if (shoot == true) {
		char.anim.play("shoot");
			cutsceneTimer(6.29, () -> {
				cutsceneSound("picoShoot");
			});
			cutsceneTimer(10.33, () -> {
				cutsceneSound("picoSpin");
			});
		} else {
			if (explode == true) {
				char.anim.play("explode");
				char.anim.onFinish.add(function() startLoop(char));
				cutsceneTimer(3.7, () -> {
					cutsceneSound("picoCigarette2");
				});
				cutsceneTimer(8.75, () -> {
					cutsceneSound("picoExplode");
				});
			} else {
				char.anim.play("cigarette");
				cutsceneTimer(3.7, () -> {
					cutsceneSound("picoCigarette");
				});
			}
		}
	} catch(e:Dynamic) { debugPrint("doAnim: " + e.toString()); }
}
function cutsceneTimer(time:Float, callback) {
	var timer = new FlxTimer().start(time, function(_) callback());
	cutsceneTimers.push(timer);
	return timer;
}
function cutsceneSound(name:String) {
	cutsceneSounds.push(FlxG.sound.play(Paths.sound("phillyTrain/cutscene/" + name)));
}
function addSkipText() {
	skipText = new FlxText(936, 618, 0, 'Skip [ ' + InputFormatter.getKeyName(ClientPrefs.keyBinds.get('accept')[0]) + ' ]', 20);
	#if FEATURE_MOBILE_CONTROLS
	skipText.text = 'Skip [ Tap ]';
	#end
	skipText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.WHITE, "right", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
	skipText.x = FlxG.width - 40 - skipText.width;
	skipText.scrollFactor.set();
	skipText.borderSize = 2;
	skipText.alpha = 0;
	skipText.cameras = [camOther];
	add(skipText);
}
// The first press shows how to skip and the next one skips, as in Funkin.
function checkSkip() {
	if (!cutscenePlaying || cutsceneSkipped) return;

	var pressed = controls.ACCEPT;
	#if FEATURE_MOBILE_CONTROLS
	for (touch in FlxG.touches.list)
		if (touch.justPressed) pressed = true;
	#end
	if (!pressed) return;

	if (!canSkipCutscene) {
		FlxTween.tween(skipText, {alpha: 1}, 0.5, {ease: FlxEase.quadOut});
		new FlxTimer().start(0.5, (_) -> canSkipCutscene = true);
		return;
	}
	skipCutscene();
}
function skipCutscene() {
	cutsceneSkipped = true;
	camOther.fade(FlxColor.BLACK, 0.5, false, null, true);
	FlxTween.tween(skipText, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	if (FlxG.sound.music != null) FlxG.sound.music.fadeOut(0.5, 0);
	new FlxTimer().start(0.5, function(_) {
		for (timer in cutsceneTimers) timer.cancel();
		for (sound in cutsceneSounds) if (sound != null) sound.stop();
		if (neneDance != null) neneDance.cancel();
		if (FlxG.sound.music != null) FlxG.sound.music.stop();
		camOther.fade(FlxColor.BLACK, 0.5, true, null, true);
		player.visible = opponent.visible = false;
		cigarette.visible = bloodPool.visible = false;
		boyfriend.visible = dad.visible = true;
		Conductor.bpm = PlayState.SONG.bpm;
		game.startCountdown();
	});
}
function startLoop(char:FlxAnimate) {
	char.anim.play("loop");
}
function getSecond(second:Float){
	return second / (60 / Conductor.bpm);
}
function onSpawnNote(note){
	if (opponentDied && !note.mustPress) {
		note.ignoreNote = true;
		if (game.characterPlayingAsDad) game.vocals.volume = 0;
		else game.opponentVocals.volume = 0;
	}
}
function onUpdate(elapsed){
	checkSkip();
	if (extendBloodPool){
		var extendFactor:Float = 0.02 * elapsed;
		var scale = bloodPool.scale.x + extendFactor;
		bloodPool.scale.set(scale, scale);
	}
}
function fadeToEnd(){
	new FlxTimer().start(1, function() {
		FlxG.camera.fade(0xFF000000, 1, false, null, true);
	});
	new FlxTimer().start(2, function() {
		game.endSong();
	});
}