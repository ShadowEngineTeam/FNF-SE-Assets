import animate.FlxAnimate;
import shaders.AdjustColorShader;

var bloodPool:FlxAnimate;
var cigarette:FlxSprite;
var opponent:FlxAnimate;
var player:FlxAnimate;
var extendBloodPool:Bool = false;
var opponentDied:Bool = false;
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
		new FlxTimer().start(1, function() { startCutscene();
		});
		alreadyStart = true;
		return "##PSYCHLUA_FUNCTIONSTOP";
	}
	camHUD.visible = true;
}
function startCutscene(){
	try {
		var neneDance = new FlxTimer().start(60/75, function() {
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
		new FlxTimer().start(4, () -> game.triggerEvent("Focus Camera", cameraCigaAt,"0,0,0,CLASSIC"));
		
		new FlxTimer().start(6.3, () -> game.triggerEvent("Focus Camera", cameraForceAt,"0,0,0,CLASSIC"));
		
		new FlxTimer().start(8.75, () -> {
			game.triggerEvent("Focus Camera", cameraCigaAt,"0,0,0,CLASSIC");
			if (explode && game.gf != null) {
				game.gf.playAnim('laugh');
				game.gf.specialAnim = true;
			}
		});
		
		new FlxTimer().start(11.2, () -> {
			if (explode) {
				bloodPool.visible = true;
				bloodPool.anim.play("pool");
				extendBloodPool = true;
			}
		});
		new FlxTimer().start(11.5, () -> {
			if (!explode) {
				cigarette.visible = true;
				cigarette.animation.play('cigarette spit');
			}
		});
		new FlxTimer().start(13, () -> {
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
		FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoGasp"));
		if (shoot == true) {
		char.anim.play("shoot");
			new FlxTimer().start(6.29, () -> {
				FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoShoot"));
			});
			new FlxTimer().start(10.33, () -> {
				FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoSpin"));
			});
		} else {
			if (explode == true) {
				char.anim.play("explode");
				char.anim.onFinish.add(function() startLoop(char));
				new FlxTimer().start(3.7, () -> {
					FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoCigarette2"));
				});
				new FlxTimer().start(8.75, () -> {
					FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoExplode"));
				});
			} else {
				char.anim.play("cigarette");
				new FlxTimer().start(3.7, () -> {
					FlxG.sound.play(Paths.sound("phillyTrain/cutscene/picoCigarette"));
				});
			}
		}
	} catch(e:Dynamic) { debugPrint("doAnim: " + e.toString()); }
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