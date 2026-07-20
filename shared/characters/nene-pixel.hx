import funkin.vis.dsp.SpectralAnalyzer;
import objects.BGSprite;
import shaders.AdjustColorShader;
import flixel.math.FlxAngle;

var analyzer:SpectralAnalyzer;
var add:Bool = false;
var neneAbot:FlxSprite;
var neneAbotBack:FlxSprite;
var neneAbotSpeaker:FlxSprite;
var visSystem:FlxSpriteGroup;
var neneAbotHead:FlxSprite;

function onCreate()
{
	neneAbot = new FlxSprite();
	neneAbot.frames = Paths.getSparrowAtlas("characters/abotPixel/aBotPixelBody");
	neneAbot.scale.set(6, 6);
	neneAbot.origin.x = Math.round(neneAbot.origin.x);
	neneAbot.origin.y = Math.round(neneAbot.origin.y);
	neneAbot.antialiasing = false;
	neneAbot.animation.addByPrefix('idle', 'danceLeft', 24, false);
	neneAbot.animation.addByPrefix('lower', 'return', 24, false);

	neneAbotSpeaker = new FlxSprite();
	neneAbotSpeaker.frames = Paths.getSparrowAtlas("characters/abotPixel/aBotPixelSpeaker");
	neneAbotSpeaker.scale.set(6, 6);
	neneAbotSpeaker.origin.x = Math.round(neneAbotSpeaker.origin.x);
	neneAbotSpeaker.origin.y = Math.round(neneAbotSpeaker.origin.y);
	neneAbotSpeaker.antialiasing = false;
	neneAbotSpeaker.animation.addByPrefix('idle', 'danceLeft', 24, false);

	neneAbotBack = new BGSprite("characters/abotPixel/abotPixelBack");
	neneAbotBack.antialiasing = false;
	neneAbotBack.scale.set(6.1, 6);

	neneAbotHead = new FlxSprite();
	neneAbotHead.frames = Paths.getSparrowAtlas("characters/abotPixel/abotHead");
	neneAbotHead.animation.addByPrefix("left", "toleft", 24, false);
	neneAbotHead.animation.addByPrefix("right", "toright", 24, false);
	neneAbotHead.antialiasing = false;
	neneAbotHead.scale.set(6, 6);

	visSystem = new FlxSpriteGroup();
	for (i in 0...7)
	{
		var x = [0, 42, 88, 144, 206, 242, 284][i];
		var y = [0, -12, -18, -18, -18, -12, 0][i];
		var newHs = new BGSprite("characters/abotPixel/aBotVizPixel", x, y, 1, 1, ["viz" + (i + 1)]);
		newHs.antialiasing = false;
		newHs.scale.set(6, 6);
		newHs.updateHitbox();
		visSystem.add(newHs);
	}
}

var levels = [
	{value: 0},
	{value: 0},
	{value: 0},
	{value: 0},
	{value: 0},
	{value: 0},
	{value: 0}
];

function onSongStart()
{
	initAudioSource();
}

var curTarget = 1;
var state = 0;

function onUpdate(elapsed)
{
	if (!add)
	{
		// easier to use than fucking instance add
		gfGroup.insert(0, neneAbot);
		gfGroup.insert(0, visSystem);
		gfGroup.insert(0, neneAbotBack);
		gfGroup.insert(0, neneAbotSpeaker);
		gfGroup.insert(0, neneAbotHead);
		add = true;
	}

	var h = game.health;
	if (h < 0.4 && state == 0)
	{
		state = 1;
		game.gf.playAnim("raiseKnife");
		game.gf.specialAnim = true;
	}
	else if (h >= 0.4 && state == 2)
	{
		state = 0;
		game.gf.playAnim("lowerKnife");
		game.gf.specialAnim = true;
	}
	if (game.gf.anim.curAnim.finished)
	{
		if (state == 0)
			gf.skipDance = false;
		if (state == 1)
		{
			state = 2;
			game.gf.danced = true;
			game.gf.skipDance = true;
		}
	}
	if (game.camFollow.x < (game.gf.getMidpoint().x - 30) && curTarget != 0)
	{
		curTarget = 0;
		neneAbotHead.animation.play("left");
	}
	if (game.camFollow.x > (game.gf.getMidpoint().x + 30) && curTarget != 1)
	{
		curTarget = 1;
		neneAbotHead.animation.play("right");
	}
	for (i in [neneAbot, neneAbotSpeaker, neneAbotBack, neneAbotHead])
		i.color = game.gf.color;
	neneAbot.setPosition(game.gf.x + 156, game.gf.y + 220);
	neneAbotSpeaker.setPosition(neneAbot.x - 80, neneAbot.y);
	visSystem.setPosition(neneAbot.x - 180, neneAbot.y - 50);
	neneAbotHead.setPosition(neneAbot.x - 325, neneAbot.y + 70);
	neneAbotBack.setPosition(neneAbot.x - 60, neneAbot.y);
	if (FlxG.sound.music != null && analyzer != null)
	{
		levels = (FlxG.sound.music.volume == 0 || FlxG.sound.mute) ? [
			{value: 0},
			{value: 0},
			{value: 0},
			{value: 0},
			{value: 0},
			{value: 0},
			{value: 0}
		] : analyzer.getLevels(levels);
	}
	for (i in 0...visSystem.length)
	{
		var vis = visSystem.members[i];
		var visible = levels[i].value > 0;
		var level = Math.round(levels[i].value * 6);
		level = Math.abs(level - 6);
		vis.animation.curAnim.curFrame = level;
		vis.visible = visible;
	}
}

function initAudioSource()
{
	analyzer = new SpectralAnalyzer(FlxG.sound.music._channel.__audioSource, 7, 0.1, 40);
	analyzer.minDb = -65;
	analyzer.maxDb = -25;
	analyzer.maxFreq = 22000;
	analyzer.minFreq = 10;
	analyzer.fftN = 256;
}

var countdown = FlxG.random.int(3, 7);

function onBeatHit()
{
	if (curBeat > countdown && state == 2)
	{
		countdown = curBeat + FlxG.random.int(3, 7);
		game.gf.playAnim("idleKnife");
	}
	if (state == 0)
	{
		neneAbot.animation.play("idle", true);
		neneAbotSpeaker.animation.play("idle", true);
	}
}

function applyAbotDropShadowShader()
{
	var abotSpeakerShader = new FlxRuntimeShader(Paths.getTextFromFile("shaders/dropshadow.frag"));
	abotSpeakerShader.setFloatArray("dropColor", [0.321568627, 0.207843137, 0.11372549]);
	abotSpeakerShader.setFloat("brightness", -66);
	abotSpeakerShader.setFloat("hue", 10);
	abotSpeakerShader.setFloat("contrast", 24);
	abotSpeakerShader.setFloat("saturation", -24);
	abotSpeakerShader.setFloat("AA_STAGES", 0);
	abotSpeakerShader.setFloat("dist", 5);
	abotSpeakerShader.setFloat("ang", 90 * FlxAngle.TO_RAD);
	abotSpeakerShader.setFloat("thr", 1);
	abotSpeakerShader.setFloat("thr2", 0);
	abotSpeakerShader.setFloat("str", 1);
	abotSpeakerShader.setBitmapData("altMask", Paths.image('stages/weeb/erect/masks/aBotPixelSpeaker_mask').bitmap);
	abotSpeakerShader.setBool("useMask", true);
	neneAbotSpeaker.animation.onFrameChange.add(function()
	{
		abotSpeakerShader.setFloatArray("uFrameBounds", [
			neneAbotSpeaker.frame.uv.left,
			neneAbotSpeaker.frame.uv.top,
			neneAbotSpeaker.frame.uv.right,
			neneAbotSpeaker.frame.uv.bottom
		]);
		abotSpeakerShader.setFloat("angOffset", neneAbotSpeaker.frame.angle * FlxAngle.TO_RAD);
	});

	var noRimShader = new AdjustColorShader();
	noRimShader.hue = -10;
	noRimShader.saturation = -23;
	noRimShader.brightness = -66;
	noRimShader.contrast = 24;

	neneAbot.shader = noRimShader;
	neneAbotBack.shader = noRimShader;
	neneAbotHead.shader = noRimShader;
	visSystem.shader = noRimShader;
	neneAbotSpeaker.shader = abotSpeakerShader;
}

function applyAbotColorAdjustShader()
{
	for (i in [neneAbot, pupil, stereoBG])
		i.shader = game.gf.shader;
}
