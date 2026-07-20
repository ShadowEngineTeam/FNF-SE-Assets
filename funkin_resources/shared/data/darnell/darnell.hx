import psychlua.LuaUtils;
import backend.Difficulty;
var videoStart = false;
var cutsceneStart = false;
var allowToStart = !PlayState.seenCutscene;
function onStartCountdown() {
	if (!PlayState.isStoryMode) return;
	if (allowToStart) {
		if (!videoStart) {
			game.startVideo("darnellCutscene");
			game.inCutscene = true;
			videoStart = true;
			return LuaUtils.Function_Stop;
		}
		if (!cutsceneStart) {
			cutsceneStart = true;
			startCutscene();
			return LuaUtils.Function_Stop;
		}
	}
}
function startCutscene() {
	FlxG.sound.playMusic(Paths.music("phillyStreets/darnellCanCutscene"), 1, false);
	var beat = new FlxTimer().start(60/168, function() {
		game.gf.dance();
	}, 0);
	// nene
	game.callOnScripts("initAudioSource");
	Conductor.bpm = 168;
	FlxG.camera.fade(FlxColor.BLACK, 0.001, false, true);
	game.triggerEvent("Focus Camera", "bf", "250,0,4,instant");
	boyfriend.playAnim("pissed");
	boyfriend.skipDance = true;
	FlxG.camera.zoom = 1.3;
	new FlxTimer().start(1, function() {
		FlxG.camera.fade(FlxColor.BLACK, 2, true, true);
		new FlxTimer().start(2, function() {
			game.triggerEvent("Focus Camera", "dad", "100,0,7,quadinout");
			game.triggerEvent("Zoom Camera", "7,0.66", "quadinout");
			new FlxTimer().start(1, function() {
				FlxG.sound.play(Paths.sound("phillyStreets/Darnell_Lighter"));
				dad.playAnim("lightcan");
				dad.specialAnim = true;
				new FlxTimer().start(0.4, function() {
					FlxG.sound.play(Paths.sound("phillyStreets/Gun_Prep"));
					game.triggerEvent("Focus Camera", "dad", "100,0,1.12,backOut");
					game.callOnScripts("cockGun");
					new FlxTimer().start(0.3, function() {
						FlxG.sound.play(Paths.sound("phillyStreets/Kick_Can_UP"));
						dad.playAnim("kickcan");
						dad.specialAnim = true;
						game.callOnScripts("startCan");
						new FlxTimer().start(0.3, function() {
							FlxG.sound.play(Paths.sound("phillyStreets/Kick_Can_FORWARD"));
							dad.playAnim("kneecan");
							dad.specialAnim = true;
							new FlxTimer().start(0.2, function() {
								game.triggerEvent("Focus Camera", "dad", "100,0,2.8,quadinout");
								game.callOnScripts("shootCan");
								boyfriend.playAnim("shootAndReturn");
								boyfriend.specialAnim = true;
								new FlxTimer().start(0.8, function() {
									dad.playAnim("laugh");
									dad.specialAnim = true;
									FlxG.sound.play(Paths.sound("phillyStreets/cutscene/darnell_laugh"), 0.6);
									new FlxTimer().start(0.3, function() {
										gf.playAnim("laugh");
										gf.specialAnim = true;
										FlxG.sound.play(Paths.sound("phillyStreets/cutscene/nene_laugh"), 0.6);
										new FlxTimer().start(1.8, function() {
											game.triggerEvent("dad Camera", "dad", "100,0,5.6,sineInOut");
											game.triggerEvent("Zoom Camera", "5.6,0.77", "quadinout");
											Conductor.bpm = PlayState.SONG.bpm;
											boyfriend.skipDance = false;
											game.startCountdown();
											FlxG.sound.music.stop();
											beat.cancel();
										});
									});
								});
							});
						});
					});
				});
			});
		});
	});
}