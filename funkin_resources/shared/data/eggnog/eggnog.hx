import animate.FlxAnimate;
import backend.InputFormatter;
import flixel.text.FlxTextBorderStyle;
var start = false;
var cutscenePlaying = false;
var cutsceneSkipped = false;
var canSkipCutscene = false;
var skipText:FlxText;
var santaSound = null;
var shootSound = null;
function onCreate() {
	if (game.isErect)
		game.startHScriptsNamed("custom_events/Subtitle");
}
function onEndSong() {
	if (!game.isErect) {
		if (!PlayState.isStoryMode || start) return;
		start = true;
		var blackBG = new FlxSprite(-FlxG.width * FlxG.camera.zoom, -FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackBG.scrollFactor.set();
		add(blackBG);
		camHUD.visible = false;
		game.inCutscene = true;
		FlxG.sound.play(Paths.sound("christmas/Lights_Shut_off"), 1, false, null, true, function() game.endCallback());
		return Function_Stop;
	}
	if (start) return;
	// what a peak
	
	var normalSanta = getVar("satan");

	// Santa clause
	var santa = new FlxAnimate(-1300, 100);
	santa.frames = Paths.getTextureAtlas("stages/christmas/santa_speaks_assets");
	santa.anim.addBySymbol("speak", "santa whole scene", 24, false);
	santa.anim.play("speak");
	santa.anim.curAnim.paused = true;
	santa.visible = false;
	if (normalSanta != null) {
		santa.shader = normalSanta.shader;
		insert(members.indexOf(normalSanta), santa);
	} else
		insert(members.indexOf(boyfriendGroup), santa);

	var parents = new FlxAnimate(-602, -3.5);
	parents.frames = Paths.getTextureAtlas("stages/christmas/parents_shoot_assets");
	parents.anim.addBySymbol("fuck u", "parents whole scene", 24, false);
	parents.anim.play("fuck u");
	parents.anim.curAnim.paused = true;
	parents.shader = santa.shader;
	insert(members.indexOf(santa), parents);
	parents.visible = false;
	
	// 1 second head start
	new FlxTimer().start(1, function() {
		// who tf nammed this dude
		if (normalSanta != null) normalSanta.visible = false;
		dadGroup.visible = false;
		santa.anim.curAnim.paused = parents.anim.curAnim.paused = false;
		santa.visible = parents.visible = true;
		//dadGroup.visible = false;
		santaSound = FlxG.sound.play(Paths.sound("christmas/santa_emotion"));
		new FlxTimer().start(0.72, () -> game.triggerEvent("Subtitle", "Wow...", "1.08"));
		new FlxTimer().start(2.14, () -> game.triggerEvent("Subtitle", "Uh, not even gonna lie to you guys.", "2.7"));
		new FlxTimer().start(5.54, () -> game.triggerEvent("Subtitle", "That's the most beautiful thing I...", "2.3"));
		new FlxTimer().start(8.08, () -> game.triggerEvent("Subtitle", "ever heard in my whole life...", "2.22"));
		game.triggerEvent("Focus Camera", "", "-100, 400, 6.53333334, expoOut");
		game.triggerEvent("Zoom Camera", "4.66666667, 0.73", "quadinout");
		new FlxTimer().start(2.8, function() {
			game.triggerEvent("Focus Camera", "", "-250, 400, 21, quartInOut");
			game.triggerEvent("Zoom Camera", "21, 0.79", "quadinout");
			new FlxTimer().start(8.57500, function() {
				if (cutsceneSkipped) return;
				shootSound = FlxG.sound.play(Paths.sound("christmas/santa_shot_n_falls"));
				new FlxTimer().start(1.45500, function() {
					if (cutsceneSkipped) return;
					FlxG.camera.shake(0.005, 0.2);
					game.triggerEvent("Focus Camera", "", "-240, 480, 11.666666656, expoOut");
					new FlxTimer().start(2.17, function() {
						if (cutsceneSkipped) return;
						camHUD.fade(0xFF000000, 1, false, null, true);
						new FlxTimer().start(1, function() {
							if (!cutsceneSkipped) game.endCallback();
						});
					});
				});
			});
		});
	});
	start = true;
	cutscenePlaying = true;

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
	return Function_Stop;
}

// The first press shows how to skip and the next one skips, as in Funkin.
function onUpdate(elapsed) {
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

	cutsceneSkipped = true;
	camOther.fade(FlxColor.BLACK, 0.5, false, null, true);
	FlxTween.tween(skipText, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
	if (santaSound != null) santaSound.stop();
	if (shootSound != null) shootSound.stop();
	new FlxTimer().start(0.5, (_) -> game.endCallback());
}