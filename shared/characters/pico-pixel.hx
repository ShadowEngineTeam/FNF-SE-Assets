import backend.HapticUtil;
import backend.MusicBeatSubstate;
import substates.GameOverSubstate;

function onCreate()
{
	GameOverSubstate.deathSoundName = "fnf_loss_sfx-pico-pixel";
	GameOverSubstate.loopSoundName = "gameOver-pico";
	GameOverSubstate.endSoundName = "gameOverEnd-pico";
}

function onGameOverStart()
{
	var dead = GameOverSubstate.instance.boyfriend;
	if (dead.curCharacter != "pico-pixel")
		return;

	dead.animation.onFrameChange.add(onDeathFrame);

	var nene:FlxSprite = new FlxSprite(game.gf.x, game.gf.y);
	nene.frames = Paths.getSparrowAtlas("characters/nenePixelKnifeToss");
	nene.animation.addByPrefix("i", "knifetosscolor", 24, false);
	nene.animation.play("i");
	nene.antialiasing = false;
	nene.scale.set(6, 6);
	nene.updateHitbox();
	nene.offset.set();
	nene.animation.onFinish.add(function(name) nene.visible = false);
	MusicBeatSubstate.instance.add(nene);
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
