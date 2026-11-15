import backend.HapticUtil;
import substates.GameOverSubstate;

function onCreate()
{
	// Precache the sound for the fakeout death.
	Paths.sound("fnf_loss_sfx-fakeout");
}

function onGameOverStart()
{
	var gameOver = GameOverSubstate.instance;
	if (gameOver.boyfriend.curCharacter != "bf")
		return;

	gameOver.boyfriend.animation.onFrameChange.add(onDeathFrame);

	if (gameOver.isFakeout)
		FlxG.sound.play(Paths.sound("fnf_loss_sfx-fakeout"));
}

function onDeathFrame(name:String, frameNumber:Int, frameIndex:Int)
{
	// BF's mic drops.
	if (name == "firstDeath" && frameNumber == 27)
		HapticUtil.vibrate(0, 0.1, 0.1, 1);

	// BF's balls pulsating.
	if (name == "deathLoop" && (frameNumber == 0 || frameNumber == 18))
		HapticUtil.vibrate(0, 0.1, 0.1, 1);
}
