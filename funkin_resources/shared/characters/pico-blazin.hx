import backend.HapticUtil;
import substates.GameOverSubstate;

function onCreate(){
	GameOverSubstate.deathSoundName = "phillyStreets/gameplay/gameOver/fnf_loss_sfx-pico-gutpunch";
	GameOverSubstate.loopSoundName = "gameOver-pico";
	GameOverSubstate.endSoundName = "gameOverEnd-pico";
}

function onGameOverStart()
{
	if (GameOverSubstate.instance.boyfriend.curCharacter != "pico-blazin")
		return;

	// Pico falls on his knees.
	new FlxTimer().start(0.5, function(_) HapticUtil.vibrate(0, 0.1, 0.1, 1));
	// Pico falls "asleep". :)
	new FlxTimer().start(1.1, function(_) HapticUtil.vibrate(0, 0.1, 0.1, 1));
}
