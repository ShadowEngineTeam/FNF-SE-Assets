import backend.HapticUtil;
import substates.GameOverSubstate;

function onGameOverStart()
{
	var gameOver = GameOverSubstate.instance;
	if (gameOver.boyfriend.curCharacter == "bf-pixel")
		gameOver.boyfriend.animation.onFrameChange.add(onDeathFrame);
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
