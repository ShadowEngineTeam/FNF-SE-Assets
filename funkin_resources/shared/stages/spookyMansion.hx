import backend.HapticUtil;
import animate.FlxAnimate;
var bg;
function onCreate() {
	bg = new FlxAnimate(-395, -505);
	bg.frames = Paths.getTextureAtlas("stages/spookyMansion/halloween_bg");
	bg.anim.addBySymbol("light", "halloweem bg lightning strike", 24, false);
	bg.anim.play("light", true, false, 34);
	insert(members.indexOf(gfGroup), bg);
}
var lightningStrikeBeat:Int = 0;
var lightningStrikeOffset:Int = 8;
function onSongRestart() {
	lightningStrikeBeat = 0;
}
function onBeatHit(){
	if (curBeat == 4&&PlayState.SONG.song == "spookeez") doLightningStrike(false, curBeat);
	if (FlxG.random.bool(10) && curBeat > (lightningStrikeBeat + lightningStrikeOffset)) doLightningStrike(true, curBeat);
}
function doLightningStrike(playSound, beat) {
	if (playSound) {
		FlxG.sound.play(Paths.sound("spookyMansion/thunder_" + FlxG.random.int(1, 2)));
	}
	bg.anim.play("light");
	lightningStrikeBeat = beat;
	lightningStrikeOffset = FlxG.random.int(8, 24);
	if (boyfriend.animOffsets.exists("scared") && (boyfriend.anim.curAnim == null || boyfriend.anim.curAnim.name != "cheer")) {
		boyfriend.playAnim("scared", true);
		boyfriend.specialAnim = true;
	}
	if (gf != null && gf.animOffsets.exists("scared")) {
		gf.playAnim("scared", true);
		gf.specialAnim = true;
	}
	triggerLightningHaptics();
}

var doPostShockHaptics:Bool = false;
var postShockCounter:Int = 0;
var counterTargetNum:Int = 10;

function triggerLightningHaptics()
{
	HapticUtil.vibrate(0, 0.05, 1, 1);

	doPostShockHaptics = true;
}

function onStepHit()
{
	if (doPostShockHaptics)
	{
		postShockCounter++;

		var postShockAmplitude:Float = 0.05 * (counterTargetNum - postShockCounter) * 2.5;
		HapticUtil.vibrate(0, 0.01, postShockAmplitude, 0);

		if (postShockCounter == counterTargetNum)
		{
			doPostShockHaptics = false;
			postShockCounter = 0;
		}
	}
}
