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
	if (boyfriend.idleSuffix == "")
	{
		var nene = new FlxSprite(game.gf.x, game.gf.y);
		nene.frames = Paths.getSparrowAtlas("characters/neneKnifeToss");
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
