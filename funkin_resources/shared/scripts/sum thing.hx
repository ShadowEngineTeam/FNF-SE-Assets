import backend.Mods;
import backend.Difficulty;
import haxe.Json;
import backend.Song;
import psychlua.HScript;
import sys.FileSystem;
import haxe.Log;
function updateAnimation(character) {
	if (character == null) return;
	for (i in character.animationsArray){
		if (i.flipX != null) character.animation.getByName(i.anim).flipX = i.flipX;
		if (i.flipY != null) character.animation.getByName(i.anim).flipX = i.flipY;
	}
//	character.visible = false;
}
var checkOnComplete:Void = null;
var fakeGF;
var fakeBF;
function onCreate(){
	if (PlayState.SONG.variant != null && PlayState.SONG.variant != "" && !PlayState.isStoryMode) {
		#if FEATURE_HSCRIPT
		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/' + PlayState.SONG.song + "/" + PlayState.SONG.variant + '/')) {
			for (file in FileSystem.readDirectory(folder)) {
				game.startHScriptsNamed(folder + file);
			//	debugPrint("Adding " + folder + file + " Script");
			}
		}
		#end
	}
}
function onCreatePost(){
	//if (ClientPrefs.data.lowQuality) {
		// hell yea
	// a fake gf that use to check gf position
	fakeGF = new Character(0, 0, PlayState.isPixelStage ? "gf-pixel" : "gf");
	fakeGF.scrollFactor.set(0.95, 0.95);
	//game.gfGroup.add(fakeGF);
	fakeGF.alpha = 0.5;
	game.startCharacterPos(fakeGF);
	
	fakeBF = new Character(0, 0, PlayState.isPixelStage ? "bf-pixel" : "bf", true);
	//game.boyfriendGroup.add(fakeBF);
	fakeBF.alpha = 0.5;
	game.startCharacterPos(fakeBF);
	//game.startCharacterScripts(fakeGF.curCharacter);
//	} 
	game.camZooming = true;
	updateAnimation(dad);
	updateAnimation(boyfriend);
	updateAnimation(gf);
	if (PlayState.SONG.variant != null && PlayState.SONG.variant != "" && !PlayState.isStoryMode) {
		try {
			for (script in cast(game.hscriptArray, Array<Dynamic>)) {
				final hs:Hscript = cast(script, HScript);
				// WHAT THE FUCK IS THIS 
			if (StringTools.contains(hs.origin, "data/" + PlayState.SONG.song)) {
				if (!StringTools.contains(hs.origin, PlayState.SONG.song + "/" + PlayState.SONG.variant + "/")) {
						trace("Destroy " + hs.origin + " Script");
						hs.destroy();
					}
				}
			}
		} catch(e:Dynamic){trace(e.toString());}
		var songData = PlayState.SONG;
		var curSong = songData.song;
		var extraSuffix = "-" + PlayState.SONG.variant;
		var erectPrefix = "";
		if (game.isErect) erectPrefix = "-erect";
		
		FlxG.signals.focusLost.add(audioPause);
		FlxG.signals.preUpdate.add(checkOnComplete);
		try {
			game.eventNotes = [];
			if (Paths.getTextFromFile("data/" + curSong + "/" + songData.variant + "/events" + erectPrefix + ".json") != null) {
				var eventList = Song.loadFromJson("events" + erectPrefix, songData.song + "/" + songData.variant).events;
				for (event in eventList) {
					for (i in 0...event[1].length) {
						game.eventNotes.push(
						{
							strumTime: event[0],
							event: event[1][i][0],
							value1: event[1][i][1],
							value2: event[1][i][2]
						});
					}
				}
			}
			if (songData.events.length > 0)
			for (event in songData.event){
				for (i in 0...event[1].length) {
					game.eventNotes.push({
						strumTime: event[0],
						event: event[1][i][0],
						value1: event[1][i][1],
						value2: event[1][i][2]
					});
				}
			}
			game.eventNotes.sort(PlayState.sortByTime);
			for (i in game.eventNotes){
				if (i.event == "Change Character") {
					var charType:Int = 0;
					switch (i.value1.toLowerCase()) {
						case 'gf' | 'girlfriend' | '1':
							charType = 2;
						case 'dad' | 'opponent' | '0':
							charType = 1;
						default:
							var val1:Int = Std.parseInt(event.value1);
							if (Math.isNaN(val1))
								val1 = 0;
							charType = val1;
					}
					game.addCharacterToList(i.value2, charType);
				}
				game.startHScriptsNamed("custom_events/" + i.event);
			}
		
			game.checkEventNote();
		} catch(e:Dynamic) {debugPrint(e.toString());}
		try {
			game.inst.loadEmbedded(Paths.inst(curSong, songData.variant + erectPrefix),false,true);
		} catch(e:Dynamic) {}
		game.inst.pause();
		if (game.vocals != null) game.vocals.destroy();
		if (game.opponentVocals != null) game.opponentVocals.destroy();
		game.vocals = new FlxSound();
		game.opponentVocals = new FlxSound();
		try {
			if (songData.needsVoices) {
				var playerVocals = Paths.voices(curSong, game.boyfriend.vocalsFile + extraSuffix + erectPrefix);
				if (playerVocals == null)
					playerVocals = Paths.voices(curSong, 'Player' + extraSuffix + erectPrefix);
				game.vocals.loadEmbedded(playerVocals ?? Paths.voices(curSong, extraSuffix + erectPrefix),false,true);
				var oppVocals = Paths.voices(curSong, game.dad.vocalsFile + extraSuffix + erectPrefix);
				if (oppVocals == null)
					oppVocals = Paths.voices(curSong, 'Opponent' + extraSuffix + erectPrefix);
				if (oppVocals != null)
					game.opponentVocals.loadEmbedded(oppVocals,false,true);
			}
		} catch(e:Dynamic){}
		game.vocals.pitch = game.playbackRate;
		@:privateAccess
		if (game.opponentVocals._sound != null)
			game.opponentVocals.pitch = game.playbackRate;
		FlxG.sound.list.add(game.vocals);
		game.vocals.pause();
		@:privateAccess
		if (game.opponentVocals._sound != null) {
			FlxG.sound.list.add(game.opponentVocals);
			game.opponentVocals.pause();
		}
	}
}
function onStepHit(){
	if (curStep % 4 == 0) {
		fakeGF.dance();
		fakeBF.dance();
	}
	updateAnimation(dad);
	updateAnimation(boyfriend);
	updateAnimation(gf);
}
/*
var sine = 0;
function onUpdate(e){
	sine += e;
	game.playbackRate = 1 + ((Math.sin(sine) + 1)/2);
}*/
function audioPause(){
	game.vocals.pause();
	if (game.opponentVocals._sound != null)
		game.opponentVocals.pause();
}
function checkOnComplete(){
	/*
	if (FlxG.sound.music.onComplete != null && game.persistentUpdate) {
		FlxG.sound.music.onComplete = function(){
		PlayState.SONG.song += " (" + songData.variant.toUpperCase() + " Mix)";
		game.finishSong();
		};
	}*/
}
var alreadAddSuffix:Bool = false;
function onEndSong(){
	
	if (PlayState.SONG.variant != null && PlayState.SONG.variant != "" && !alreadAddSuffix) {
		PlayState.SONG.song += " (" + PlayState.SONG.variant.toUpperCase() + " Mix)";
		alreadAddSuffix = true;
	}
}
function onDestroy() {
	FlxG.signals.focusLost.remove(audioPause);
	FlxG.signals.preUpdate.remove(checkOnComplete);
	if (alreadAddSuffix) {
		PlayState.SONG.song = StringTools.replace(PlayState.SONG.song, " (" + songData.variant.toUpperCase() + " Mix)", "");
	}
}