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
	var nene:FlxSprite = new FlxSprite(game.gf.x, game.gf.y);
	nene.frames = Paths.getSparrowAtlas("characters/nenePixel/nenePixelKnifeToss");
	nene.animation.addByPrefix("i", "knifetosscolor", 24, false);
	nene.animation.play("i");
	nene.antialiasing = false;
	nene.scale.set(6, 6);
	nene.updateHitbox();
	nene.offset.set();
	nene.animation.onFinish.add(function(name) nene.visible = false);
	MusicBeatSubstate.instance.add(nene);
}
