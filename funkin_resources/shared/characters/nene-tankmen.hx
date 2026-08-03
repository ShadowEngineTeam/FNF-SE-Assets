import funkin.vis.dsp.SpectralAnalyzer;
import backend.CoolUtil;
import animate.FlxAnimate;
import objects.BGSprite;
import shaders.AdjustColorShader;

var vizAdjustColor:AdjustColorShader;
var abotTextureSwapShader:FlxRuntimeShader;
var analyzer:SpectralAnalyzer;
var add:Bool = false;
var neneAbot:FlxAnimate;
var stereoBG:FlxSprite;
var visSystem:FlxSpriteGroup;
var eyeWhites:FlxSprite;
var pupil:FlxAnimate;
function onCreate() {
	neneAbot = new FlxAnimate();
	neneAbot.frames = Paths.getTextureAtlas("characters/abot/abotSystem");
	neneAbot.anim.addBySymbol("idle", "Abot System", 24, false);
	
	visSystem = new FlxSpriteGroup();
	for (i in 0...7){
		var x = [0,59,115,181,235,287,338][i];
		var y = [0,-8,-11.5,-11.9,-11.4,-4.4,3.6][i];
		var newHs = new BGSprite("characters/abot/aBotViz", x, y, 1, 1, ["viz" + (i + 1)]);
		var vizAdjustColor = new AdjustColorShader();
		vizAdjustColor.brightness = -12;
		vizAdjustColor.hue = -30;
		vizAdjustColor.contrast = 0;
		vizAdjustColor.saturation = -10;
		newHs.shader = vizAdjustColor;
		visSystem.add(newHs);
	}

	stereoBG = new FlxSprite().loadGraphic(Paths.image("characters/abot/stereoBG"));
	
	eyeWhites = new FlxSprite().makeGraphic(160,60);
	
	pupil = new FlxAnimate();
	pupil.frames = Paths.getTextureAtlas("characters/abot/systemEyes");
	pupil.anim.addBySymbolIndices("left", "a bot eyes lookin", CoolUtil.numberArray(16), 24, false);
	pupil.anim.addBySymbolIndices("right", "a bot eyes lookin",CoolUtil.numberArray(32,17),24, false);
	
	var adjustColor = new AdjustColorShader();
	adjustColor.brightness = -40;
	adjustColor.hue = -40;
	adjustColor.contrast = -25;
	adjustColor.saturation = -20;
	stereoBG.shader = adjustColor;
	pupil.shader = adjustColor;
	neneAbot.shader = adjustColor;
	
}
/*
-- normal 
-- raise knife
-- holding knife
-- throw at pico (I lazy to do)
*/
var levels = [{value:0},{value:0},{value:0},{value:0},{value:0},{value:0},{value:0}];
function onSongStart(){
	initAudioSource();
}
var curTarget = 1;
function onUpdatePost(elapsed) {
	if (!add){
		//easier to use than fucking instance add
		gfGroup.insert(0, neneAbot);
		gfGroup.insert(0, visSystem);
		gfGroup.insert(0, stereoBG);
		gfGroup.insert(0, pupil);
		gfGroup.insert(0, eyeWhites);
		add = true;
	}
	if (game.camFollow.x < (game.gf.getMidpoint().x - 30) && curTarget != 0){
		curTarget = 0;
		pupil.anim.play("left");
	}
	if (game.camFollow.x > (game.gf.getMidpoint().x + 30) && curTarget != 1) {
		curTarget = 1;
		pupil.anim.play("right");
	}
	neneAbot.setPosition(game.gf.x - 80, game.gf.y + 329);
	visSystem.setPosition(neneAbot.x + 207, neneAbot.y + 94);
	eyeWhites.setPosition(neneAbot.x + 40, neneAbot.y + 230);
	pupil.setPosition(neneAbot.x + 50, neneAbot.y + 238);
	stereoBG.setPosition(neneAbot.x + 150, neneAbot.y + 30);
	if (FlxG.sound.music != null && analyzer != null){
		levels = (FlxG.sound.music.volume == 0 || FlxG.sound.mute) ? [{value:0},{value:0},{value:0},{value:0},{value:0},{value:0},{value:0}] : analyzer.getLevels(levels);
	}
	for (i in 0...visSystem.length){
		var vis = visSystem.members[i];
		var level = levels[i].value;
		vis.animation.curAnim.curFrame = Math.round(Math.abs((level * 6 * FlxG.sound.music.volume) - 6));
		vis.visible = level > 0;
	}
//	neneAbot.anim.play("idle",true,false, 16 - specHighest(levels) * 16);
}
function initAudioSource(){
	analyzer = new SpectralAnalyzer(FlxG.sound.music._channel.__audioSource, 7, 0.1, 40);
	analyzer.minDb = -65;
	analyzer.maxDb = -25;
	analyzer.maxFreq = 22000;
	analyzer.minFreq = 10;
	analyzer.fftN = 256;
}
function onBeatHit() neneAbot.anim.play("idle",true, false,1);