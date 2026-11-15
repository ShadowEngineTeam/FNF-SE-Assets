import backend.HapticUtil;
import backend.MusicBeatSubstate;
import substates.GameOverSubstate;

var state = null;
var explode = false;

function onCreate()
{
	GameOverSubstate.deathSoundName = "fnf_loss_sfx-pico";
	GameOverSubstate.loopSoundName = "gameOver-pico";
	GameOverSubstate.endSoundName = "gameOverEnd-pico";
}

function onGameOver()
{
	if (game.boyfriend.idleSuffix == "-explode")
	{
		explode = true;
		GameOverSubstate.deathSoundName = "phillyStreets/gameplay/gameOver/fnf_loss_sfx-pico-explode";
		GameOverSubstate.loopSoundName = "gameOver-pico-explode";
	}
}

var signalSound;

function onGameOverStart()
{
	var dead = GameOverSubstate.instance.boyfriend;
	if (dead.curCharacter != "pico-playable")
		return;

	if (explode)
	{
		HapticUtil.vibrate(0, 0.5, 0.5, 1);
		// Pico falls on his knees.
		new FlxTimer().start(1.85, function(_) HapticUtil.vibrate(0, 0.1, 0.1, 1));
	}
	else
		dead.animation.onFrameChange.add(onDeathFrame);

	if (boyfriend.idleSuffix == "")
	{
		var nene = new FlxSprite(game.gf.x, game.gf.y);
		nene.frames = Paths.getSparrowAtlas("characters/NeneKnifeToss");
		nene.animation.addByPrefix("i", "knife toss", 24, false);
		nene.animation.play("i");
		nene.animation.onFinish.add(function(name) nene.visible = false);
		MusicBeatSubstate.instance.add(nene);
	}
	else
	{
		signalSound = FlxG.sound.load(Paths.sound('phillyStreets/singed_loop'), 1, true);
		signalSound.pause();
	}
}

function onGameOverMusicStart()
{
	if (signalSound != null)
		signalSound.play();
}

function onGameOverConfirm()
{
	if (signalSound != null)
		signalSound.stop();
}

function onDeathFrame(name:String, frameNumber:Int, frameIndex:Int)
{
	// Pico falls on his back.
	if (name == "firstDeath" && frameNumber == 20)
		HapticUtil.vibrate(0, 0.1, 0.1, 1);

	// Blood firework woohoo!!!!
	if (name == "deathLoop" && frameNumber % 2 == 0)
		HapticUtil.vibrate(0, FlxG.random.float(0.1, 0.3), FlxG.random.float(0.1, 0.5), 1);
}
