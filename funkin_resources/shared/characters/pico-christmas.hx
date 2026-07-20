import backend.MusicBeatSubstate;
import substates.GameOverSubstate;
function onCreate(){
	GameOverSubstate.deathSoundName = "phillyStreets/gameplay/gameOver/fnf_loss_sfx-pico";
	GameOverSubstate.loopSoundName = "gameOver-pico";
	GameOverSubstate.endSoundName = "gameOverEnd-pico";
}
var signalSound;
function onGameOverStart(){
	var nene:FlxSprite = new FlxSprite(game.gf.x, game.gf.y);
	nene.frames = Paths.getSparrowAtlas("characters/neneKnifeToss");
	nene.animation.addByPrefix("i", "knife toss", 24, false);
	nene.animation.play("i");
	nene.animation.onFinish.add(function(name) nene.visible = false);
	MusicBeatSubstate.instance.add(nene);
}